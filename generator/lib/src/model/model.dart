library jaguar_orm.generator.model;

import 'package:meta/meta.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_orm_gen/src/common/common.dart';
import 'package:jaguar_orm/src/annotations/nextgen.dart';

part 'association.dart';
part 'foreign.dart';

class Field {
  final String type;

  final String field;

  final bool isFinal;

  final Column column;

  final String dataType;

  final ForeignSpec foreign;

  Field(this.type, this.field,
      {@required Column column,
      @required this.dataType,
      @required this.foreign,
      @required this.isFinal})
      : column = column ?? Column();

  String get colName => column?.name ?? field;

  String get vType {
    try {
      return getValType(type);
    } catch (e) {
      throw FieldSpecException(field, e.toString());
    }
  }

  bool get isAuto {
    /* TODO
    if (dataType is Int) return (dataType as Int).auto;
     */
    return false;
  }
}

class WriterModel {
  final String name;

  final String modelType;

  final Map<String, Field> fields;

  final List<Field> primary;

  /// A map of bean to [BelongsToAssociation]
  final Map<DartType, BelongsToAssociation> belongTos;

  /// A map of association to [BeanedForeignAssociation]
  final Map<DartType, BeanedForeignAssociation> beanedForeignAssociations;

  /// A map of association to [ForeignKey]
  // TODO final Map<String, BaseForeignKey> getByForeignTabled;

  final List<Preload> preloads;

  Field fieldByColName(String colName) => fields.values
      .firstWhere((Field f) => f.colName == colName, orElse: () => null);

  WriterModel(this.name, this.modelType, this.fields, this.primary,
      this.belongTos, this.beanedForeignAssociations, this.preloads);

  Preload findHasXByAssociation(DartType association) {
    return preloads.firstWhere((p) => p.bean == association,
        orElse: () => null);
  }

  BelongsToAssociation getMatchingManyToMany(BelongsToAssociation val) {
    for (BelongsToAssociation f in belongTos.values) {
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

  throw Exception('Field type not recognised: $type!');
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

  final WriterModel targetInfo;

  final WriterModel beanInfo;

  final List<Field> fields = <Field>[];

  final List<Field> foreignFields;

  final bool hasMany = true;

  PreloadManyToMany(this.bean, this.targetBean, this.property, this.targetInfo,
      this.beanInfo, this.foreignFields);
}
