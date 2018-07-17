library jaguar_orm.generator.parser;

import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';

import 'package:jaguar_orm_gen/src/common/common.dart';
import 'package:jaguar_orm_gen/src/model/model.dart';

class _BeanGetter {
  final ConstantReader reader;
  final DartType model;

  _BeanGetter(this.reader, this.model);

  static _BeanGetter get(ClassElement clazz) {
    if (!isBean.isAssignableFromType(clazz.type)) {
      throw new Exception("Beans must implement Bean interface!");
    }

    final InterfaceType interface = clazz.allSupertypes
        .firstWhere((InterfaceType i) => isBean.isExactlyType(i));

    final DartType model = interface.typeArguments.first;

    if (model.isDynamic) {
      throw new Exception("Don't support Model of type dynamic!");
    }

    ConstantReader reader = new ConstantReader(clazz.metadata
        .firstWhere((m) => isGenBean.isExactlyType(m.constantValue.type))
        .constantValue);

    return new _BeanGetter(reader, model);
  }
}

class ParsedBean {
  static WriterInfo detect(ClassElement clazz, {bool doRelations: true}) {
    ConstantReader genBean;
    DartType model;

    {
      final getter = _BeanGetter.get(clazz);
      genBean = getter.reader;
      model = getter.model;
    }

    final ClassElement modelClass = model.element;

    final fields = <String, Field>{};

    final preloads = <Preload>[];

    final primaries = <Field>[];

    final Set<String> ignores = new Set<String>();

    // Parse columns from GenBean::columns specification
    {
      final Map cols = genBean.read('columns').mapValue;
      for (DartObject name in cols.keys) {
        final fName = name.toStringValue();
        final f = modelClass.getField(fName);

        if (f == null) {
          throw new Exception('Cannot find field $fName!');
        }

        final DartObject spec = cols[name];
        if (isIgnore.isExactlyType(spec.type)) {
          ignores.add(fName);
          continue;
        }

        final val = parseColumn(f, spec);

        fields[val.field] = val;
        if (val.primary) primaries.add(val);
      }
    }

    final Set<String> relations = new Set<String>();

    // Parse relations from GenBean::relations specification
    {
      final Map cols = genBean.read('relations').mapValue;
      for (DartObject name in cols.keys) {
        final fName = name.toStringValue();
        final f = modelClass.getField(fName);

        if (f == null) {
          throw new Exception('Cannot find field $fName!');
        }

        relations.add(fName);

        final DartObject spec = cols[name];
        preloads.add(parseRelation(clazz.type, f, spec, doRelations));
      }
    }

    for (FieldElement field in modelClass.fields) {
      if (fields.containsKey(field.name)) continue;

      if (relations.contains(field.name)) continue;

      if (ignores.contains(field.name)) continue;

      //If IgnoreField is present, skip!
      {
        int ignore = field.metadata
            .map((ElementAnnotation annot) => annot.computeConstantValue())
            .where((DartObject inst) => isIgnore.isExactlyType(inst.type))
            .length;

        if (ignore != 0) {
          ignores.add(field.name);
          continue;
        }
      }

      if (field.isStatic) continue;

      final val = _makeField(field);

      if (val is Field) {
        fields[val.field] = val;
        if (val.primary) primaries.add(val);
      } else {
        if (isPropRelation(field)) {
          print('here');
          preloads.add(_relation(clazz.type, field, doRelations));
        } else {
          final vf = new Field(field.type.name, field.name, field.name);
          fields[vf.field] = vf;
        }
      }
    }

    final findByForeign = <DartType, FindByForeignBean>{};

    // Collect get by foreign beaned
    for (Field f in fields.values) {
      if (f.foreign == null || f.foreign is! ForeignBeaned) continue;

      final ForeignBeaned foreign = f.foreign;
      final DartType bean = foreign.bean;
      FindByForeign current = findByForeign[bean];

      final WriterInfo info =
          ParsedBean.detect(foreign.bean.element, doRelations: false);
      final Preload other = info.findHasXByAssociation(clazz.type);
      if (current == null) {
        current = new FindByForeignBean(foreign.bean, [], [], info, other);
        findByForeign[bean] = current;
      } else if (current is FindByForeignBean) {
        if (current.isMany != other.hasMany) {
          throw new Exception('Mismatching association type!');
        }
        if (current.belongsToMany != other is PreloadManyToMany) {
          throw new Exception('Mismatching association type!');
        }
      } else {
        throw new Exception('Table and bean associations mixed!');
      }
      findByForeign[bean].fields.add(f);
    }

    // Collect find by foreign table
    for (Field f in fields.values) {
      if (f.foreign == null || f.foreign is! ForeignTabled) continue;

      throw new UnimplementedError('ForeignKey that is not beaned!');

      /* TODO
      final ForeignTabled foreign = f.foreign;
      final String association = foreign.association;
      FindByForeign current = findByForeign[association];

      if (current == null) {
        current = new FindByForeignTable(
            association, [], foreign.hasMany, foreign.table);
        findByForeign[association] = current;
      } else if (current is FindByForeignTable) {
        if (current.table != foreign.table) {
          throw new Exception('Mismatching table for association!');
        }
        if (current.isMany != foreign.hasMany) {
          throw new Exception('Mismatching ForeignKey association type!');
        }
      } else {
        throw new Exception('Table and bean associations mixed!');
      }
      findByForeign[association].fields.add(f);
      */
    }

    for (FindByForeign m in findByForeign.values) {
      if (m is FindByForeignBean) {
        final WriterInfo info =
            ParsedBean.detect(m.bean.element, doRelations: false);

        for (Field f in m.fields) {
          Field ff = info.fieldByColName(f.foreign.refCol);

          if (ff == null)
            throw new Exception('Foreign key in foreign model not found!');

          m.foreignFields.add(ff);
        }
      }
    }

    final ret = WriterInfo(clazz.name, model.name, fields, primaries,
        findByForeign, {} /* TODO*/, preloads);

    if (doRelations) {
      for (Preload p in preloads) {
        for (Field f in p.foreignFields) {
          Field ff = ret.fieldByColName(f.foreign.refCol);

          if (ff == null)
            throw new Exception('Foreign key in foreign model not found!');

          p.fields.add(ff);
        }
      }
    }

    return ret;
  }

  static bool isPropRelation(FieldElement f) =>
      f.metadata
          .map((ElementAnnotation annot) => annot.computeConstantValue())
          .where((DartObject i) => isRelation.isAssignableFromType(i.type))
          .length >
      0;

  static Field _makeField(FieldElement f) {
    List<Field> fields = f.metadata
        .map((ElementAnnotation annot) => annot.computeConstantValue())
        .where((DartObject i) => isColumnBase.isAssignableFromType(i.type))
        .map((DartObject i) => parseColumn(f, i))
        .toList();

    if (fields.length > 1) {
      throw new Exception('Only one Column annotation is allowed on a Field!');
    }

    if (fields.length == 0) return null;

    return fields.first;
  }

  static Preload _relation(DartType curBean, FieldElement f, bool doRelations) {
    List<Preload> preloads = f.metadata
        .map((ElementAnnotation annot) => annot.computeConstantValue())
        .where((DartObject i) => isRelation.isAssignableFromType(i.type))
        .map((DartObject i) => parseRelation(curBean, f, i, doRelations))
        .toList();

    if (preloads.length > 1) {
      throw new Exception(
          'Only one Relation annotation is allowed on a Field!');
    }

    return preloads.first;
  }
}

Field parseColumn(FieldElement f, DartObject obj) {
  final String colName = obj.getField('col').toStringValue();
  final bool nullable = obj.getField('nullable').toBoolValue();
  final bool autoIncrement = obj.getField('autoIncrement').toBoolValue();
  final int length = obj.getField('length').toIntValue();
  if (isColumn.isExactlyType(obj.type)) {
    return new Field(f.type.name, f.name, colName,
        nullable: nullable, autoIncrement: autoIncrement, length: length);
  } else if (isPrimaryKey.isExactlyType(obj.type)) {
    return new Field(f.type.name, f.name, colName,
        nullable: nullable,
        primary: true,
        autoIncrement: autoIncrement,
        length: length);
  } else if (isForeignKey.isAssignableFromType(obj.type)) {
    final DartType bean = obj.getField('bean').toTypeValue();
    final String table = obj.getField('table').toStringValue();
    final String refCol = obj.getField('refCol').toStringValue();

    Foreign fore;

    if (bean != null) {
      if (!isBean.isAssignableFromType(bean)) {
        throw new Exception("Non-bean type provided!");
      }
      final bool belongsToMany = isBelongsToMany.isExactlyType(obj.type);
      fore = new ForeignBeaned(bean, refCol, belongsToMany);
    } else if (table != null) {
      fore = new ForeignTabled(table, refCol);
    } else {
      throw new Exception('ForeignKey must either be tabled or beaned!');
    }
    return new Field(f.type.name, f.name, colName,
        nullable: nullable,
        foreign: fore,
        autoIncrement: autoIncrement,
        length: length);
  }

  throw new FieldException(f.name, 'Invalid ColumnBase type!');
}

Preload parseRelation(
    DartType curBean, FieldElement f, DartObject obj, bool doRelations) {
  if (isHasOne.isExactlyType(obj.type) || isHasMany.isExactlyType(obj.type)) {
    final DartType bean = obj.getField('bean').toTypeValue();

    if (!isBean.isAssignableFromType(bean)) {
      throw new Exception("Non-bean type provided!");
    }

    FindByForeignBean g;
    if (doRelations) {
      final WriterInfo info =
          ParsedBean.detect(bean.element, doRelations: false);
      g = info.getByForeign[curBean];
      if (g == null || g is! FindByForeignBean)
        throw new Exception('Association $bean not found! Field ${f.name}.');
    }

    final bool hasMany = isHasMany.isExactlyType(obj.type);

    return new PreloadOneToX(bean, f.name, g?.fields, hasMany);
  } else if (isManyToMany.isExactlyType(obj.type)) {
    final DartType pivot = obj.getField('pivotBean').toTypeValue();
    final DartType target = obj.getField('targetBean').toTypeValue();

    if (!isBean.isAssignableFromType(pivot)) {
      throw new Exception("Non-bean type provided!");
    }

    if (!isBean.isAssignableFromType(target)) {
      throw new Exception("Non-bean type provided!");
    }

    FindByForeignBean g;
    if (doRelations) {
      final WriterInfo beanInfo =
          ParsedBean.detect(pivot.element, doRelations: false);
      g = beanInfo.getByForeign[curBean];
      if (g == null || g is! FindByForeignBean) {
        throw new Exception('Association $curBean not found! Field ${f.name}.');
      }
      final WriterInfo targetInfo =
          ParsedBean.detect(target.element, doRelations: false);
      return new PreloadManyToMany(
          pivot, target, f.name, targetInfo, beanInfo, g?.fields);
    }

    return new PreloadManyToMany(pivot, target, f.name, null, null, null);
  }

  throw new Exception('Invalid Relation type!');
}
