library jaguar_orm.generator.parser;

import 'package:jaguar_orm_gen/src/parser/parser.dart';
import 'package:tuple/tuple.dart';
import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/constant/value.dart';

import 'package:jaguar_orm_gen/src/common/common.dart';
import 'package:jaguar_orm_gen/src/model/model.dart';
import 'package:jaguar_orm/jaguar_orm.dart' hide Field;

import '../exceptions.dart';

part 'field.dart';

/// Parses the `@GenBean()` into [UnAssociatedBean].
///
/// This only parses into intermediate form. It has to be further processed by
/// [BeanParser].
class UnassociatedBeanParser {
  final bool associatePreloads;

  /// The [ClassElement] element of the `GenBean` spec.
  final ClassElement clazz;

  /// The model of the Bean
  DartType model;

  /// Constant reader used to read fields from the `GenBean`
  ConstantReader reader;

  DartType get curBean => clazz.type;

  /// Parsed fields are stored here while being parsed.
  final fields = <String, ParsedField>{};

  final primaries = <ParsedField>[];

  final relations = <String, RelationSpec>{};

  /// Parsed preloads are stored here while being parsed.
  ///
  /// This is part of the state of the parser.
  final preloads = <Preload>[];

  UnassociatedBeanParser(this.clazz, {this.associatePreloads = true});

  UnAssociatedBean parse() {
    // Finds bean's model and  parses GenBean annotation
    _findModel();

    // Parses Fields in the model
    _parseFields();

    _computePreloads();

    final ret = UnAssociatedBean(
      clazz.name,
      model.name,
      fields: fields,
      primary: primaries,
      relations: relations,
      preloads: preloads,
      // TODO references: ,
    );

    return ret;
  }

  /// Parses and populates [model] and [reader]
  void _findModel() {
    if (!isBean.isAssignableFromType(clazz.type)) {
      throw Exception("Beans must implement Bean interface!");
    }

    final DartObject meta = isGenBean.firstAnnotationOf(clazz);
    if (meta == null) {
      throw Exception("GenBean annotation not found for ${clazz.name}!");
    }
    reader = ConstantReader(meta);

    final InterfaceType interface = clazz.allSupertypes
        .firstWhere((InterfaceType i) => isBean.isExactlyType(i));

    model = interface.typeArguments.first;

    if (model.isDynamic) throw Exception("Model cannot be dynamic!");
  }

  /// Parses and populates [fields]
  void _parseFields() {
    final ignores = Set<String>();

    final ClassElement modelClass = model.element;

    final relations = Set<String>();

    /// Parse getters, setters and fields in model
    for (FieldElement field in modelClass.fields) {
      try {
        if (fields.containsKey(field.name)) continue;
        if (relations.contains(field.name)) continue;
        if (ignores.contains(field.name)) continue;

        if (field.displayName == 'hashCode' ||
            field.displayName == 'runtimeType') continue;

        // TODO allow setter only fields
        if (field.getter == null) continue;
        if (field.setter == null) {
          if (!field.isFinal || field.isSynthetic) continue;
        }

        if (isIgnore.hasAnnotationOf(field)) {
          ignores.add(field.name);
          continue;
        }

        if (field.isStatic) continue;

        if (!_relation(clazz.type, field)) {
          final val = _parseField(field);
          fields[val.field] = val;
          if (val.column.isPrimary) primaries.add(val);
        }
      } catch (e, s) {
        throw FieldParseException(field.name, e, s);
      }
    }
  }

  bool _relation(DartType curBean, FieldElement f) {
    DartObject rel = isRelation.firstAnnotationOf(f);
    if (rel == null) return false;

    String linkByName = getString(rel, 'linkByName');

    if (isHasOne.isExactlyType(rel.type) || isHasMany.isExactlyType(rel.type)) {
      final DartType bean = rel.getField('bean').toTypeValue();

      if (!isBean.isAssignableFromType(bean)) {
        throw Exception("Non-bean type used for Relation!");
      }

      final bool hasMany = isHasMany.isExactlyType(rel.type);

      if (!hasMany) {
        relations[f.displayName] = HasOneSpec(f.displayName, bean, linkByName);
      } else {
        relations[f.displayName] = HasManySpec(f.displayName, bean, linkByName);
      }
    } else if (isManyToMany.isExactlyType(rel.type)) {
      final DartType pivot = rel.getField('pivotBean').toTypeValue();
      final DartType target = rel.getField('targetBean').toTypeValue();

      if (!isBean.isAssignableFromType(pivot)) {
        throw Exception("Non-bean type provided!");
      }

      if (!isBean.isAssignableFromType(target)) {
        throw Exception("Non-bean type provided!");
      }

      relations[f.displayName] =
          ManyToManySpec(f.displayName, pivot, target, linkByName);
    } else {
      throw Exception('Invalid Relation type!');
    }

    return true;
  }

  /// Computes preloads for all [Relation]s
  void _computePreloads() {
    for (String fieldName in relations.keys) {
      RelationSpec spec = relations[fieldName];

      if (spec is HasOneSpec) {
        BelongsToAssociationByRelation g;
        if (associatePreloads) {
          if (spec.bean != curBean) {
            final ParsedBean info =
                BeanParser(spec.bean.element, doRelations: false).parse();
            g = info.associationsWithRelations[curBean];
            if (g == null || g is! BelongsToAssociationByRelation)
              throw Exception(
                  'Association ${spec.bean} not found! Field ${spec.property}.');
          }
        }

        preloads.add(
            PreloadOneToX(spec.bean, spec.property, g?.fields ?? [], false));
      } else if (spec is HasManySpec) {
        BelongsToAssociationByRelation g;
        if (associatePreloads) {
          if (spec.bean != curBean) {
            final ParsedBean info =
                BeanParser(spec.bean.element, doRelations: false).parse();
            g = info.associationsWithRelations[curBean];
            if (g == null || g is! BelongsToAssociationByRelation)
              throw Exception(
                  'Association ${spec.bean} not found! Field ${spec.property}.');
          }
        }

        preloads.add(
            PreloadOneToX(spec.bean, spec.property, g?.fields ?? [], true));
      } else if (spec is ManyToManySpec) {
        BelongsToAssociationByRelation g;
        if (associatePreloads) {
          final ParsedBean beanInfo =
              BeanParser(spec.pivotBean.element, doRelations: false).parse();
          g = beanInfo.associationsWithRelations[curBean];
          if (g == null || g is! BelongsToAssociationByRelation) {
            throw Exception(
                'Association $curBean not found! Field ${spec.property}.');
          }
          final UnAssociatedBean targetInfo =
              UnassociatedBeanParser(spec.targetBean.element, associatePreloads: false).parse();
          preloads.add(PreloadManyToMany(spec.pivotBean, spec.targetBean,
              spec.property, targetInfo, beanInfo, g?.fields));
          return;
        }

        preloads.add(PreloadManyToMany(
            spec.pivotBean, spec.targetBean, spec.property, null, null, null));
      } else {
        throw Exception("Unknown Relation type");
      }
    }
  }
}

/* TODO
    // Collect [TabledForeignAssociation] from [TableForeign]
    for (ParsedField f in fields.values) {
      if (f.foreign is! ReferencesSpec) continue;

      // TODO throw UnimplementedError('ForeignKey that is not beaned!');

      /*
      final ForeignTabled foreign = f.foreign;
      final String association = foreign.association;
      FindByForeign current = findByForeign[association];

      if (current == null) {
        current =
            FindByForeignTable(association, [], foreign.hasMany, foreign.table);
        findByForeign[association] = current;
      } else if (current is FindByForeignTable) {
        if (current.table != foreign.table) {
          throw Exception('Mismatching table for association!');
        }
        if (current.isMany != foreign.hasMany) {
          throw Exception('Mismatching ForeignKey association type!');
        }
      } else {
        throw Exception('Table and bean associations mixed!');
      }
      findByForeign[association].fields.add(f);
       */
    }
 */