library jaguar_orm.generator.model;

import 'package:analyzer/dart/element/type.dart';

import 'package:jaguar_orm_gen/src/common/common.dart';

abstract class FindByForeign {
  List<Field> get fields;

  bool get isMany;
}

/// Model that contains information to write find method by foreign relation
class FindByForeignBean implements FindByForeign {
  final DartType bean;

  final DartType model;

  final List<Field> fields;

  final List<Field> foreignFields;

  bool get isMany => other.hasMany;

  bool get belongsToMany => other is PreloadManyToMany;

  final WriterInfo beanInfo;

  final Preload other;

  FindByForeignBean(
      this.bean, this.fields, this.foreignFields, this.beanInfo, this.other)
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

class FindByForeignTable implements FindByForeign {
  final List<Field> fields;

  final bool isMany;

  final String table;

  FindByForeignTable(this.fields, this.isMany, this.table);
}

abstract class Foreign {
  String get refCol;
}

class ForeignBeaned implements Foreign {
  final DartType bean;

  final String refCol;

  final DartType model;

  final bool belongsToMany;

  ForeignBeaned(this.bean, this.refCol, this.belongsToMany)
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

class ForeignTabled implements Foreign {
  final String table;

  final String refCol;

  ForeignTabled(this.table, this.refCol);
}

class Field {
  final String type;

  final String field;

  String get vType {
    try {
      return getValType(type);
    } catch (e) {
      throw new FieldException(field, e.toString());
    }
  }

  final String colName;

  final bool nullable;

  final bool autoIncrement;

  final int length;

  final bool primary;

  final Foreign foreign;

  // TODO unique

  Field(this.type, this.field, String colName,
      {this.nullable: false,
      this.autoIncrement: false,
      this.length,
      this.primary: false,
      this.foreign})
      : colName = colName ?? field;
}

class WriterInfo {
  final String name;

  final String modelType;

  final Map<String, Field> fields;

  final List<Field> primary;

  /// A map of bean to [FindByForeign]
  final Map<DartType, FindByForeignBean> getByForeign;

  /// A map of association to [FindByForeign]
  final Map<String, FindByForeignTable> getByForeignTabled;

  final List<Preload> preloads;

  Field fieldByColName(String colName) => fields.values
      .firstWhere((Field f) => f.colName == colName, orElse: () => null);

  WriterInfo(this.name, this.modelType, this.fields, this.primary,
      this.getByForeign, this.getByForeignTabled, this.preloads);

  Preload findHasXByAssociation(DartType association) {
    final found =
        preloads.firstWhere((p) => p.bean == association, orElse: () => null);

    if (found == null) {
      throw new Exception('Association not found!');
    }

    return found;
  }

  FindByForeignBean getMatchingManyToMany(FindByForeignBean val) {
    for (FindByForeignBean f in getByForeign.values) {
      if (!f.belongsToMany) continue;

      if (f == val) continue;

      return f;
    }
    return null;
  }
}

String getValType(String type) {
  if (type == 'String') {
    return 'StrField';
  } else if (type == 'bool') {
    return 'BoolField';
  } else if (type == 'int') {
    return 'IntField';
  } else if (type == 'num' || type == 'double') {
    return 'DoubleField';
  } else if (type == 'DateTime') {
    return 'DateTimeField';
  }

  throw new Exception('Field type not recognised!');
}

/// Contains information about `HasOne`, `HasMany`, `ManyToMany` relationships
abstract class Preload {
  DartType get bean;

  String get beanName => bean.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';

  String get modelName => getModelForBean(bean).name;

  String get property;

  List<Field> get fields;

  List<Field> get foreignFields;

  bool get hasMany;
}

/// Contains information about `HasOne`, `HasMany` relationships
class PreloadOneToX extends Preload {
  final DartType bean;

  final String property;

  final List<Field> fields = <Field>[];

  final List<Field> foreignFields;

  /// true for `HasMany`. false for `HasOne`
  final bool hasMany;

  PreloadOneToX(this.bean, this.property, this.foreignFields, this.hasMany);
}

class PreloadManyToMany extends Preload {
  final DartType bean;

  final DartType targetBean;

  String get targetBeanName => targetBean.name;

  String get targetBeanInstanceName => uncap(targetModelName) + 'Bean';

  String get targetModelName => getModelForBean(targetBean).name;

  final String property;

  final WriterInfo targetInfo;

  final WriterInfo beanInfo;

  final List<Field> fields = <Field>[];

  final List<Field> foreignFields;

  final bool hasMany = true;

  PreloadManyToMany(this.bean, this.targetBean, this.property, this.targetInfo,
      this.beanInfo, this.foreignFields);
}
