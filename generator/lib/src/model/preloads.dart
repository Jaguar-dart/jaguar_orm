import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_orm_gen/src/common/common.dart';
import 'model.dart';

abstract class RelationSpec {
  String get property;

  String get linkByName;
}

class HasOneSpec implements RelationSpec {
  final String property;

  final String linkByName;

  final DartType bean;

  HasOneSpec(this.property, this.bean, this.linkByName);
}

class HasManySpec implements RelationSpec {
  final String property;

  final String linkByName;

  final DartType bean;

  HasManySpec(this.property, this.bean, this.linkByName);
}

class ManyToManySpec implements RelationSpec {
  final String property;

  final String linkByName;

  final DartType pivotBean;

  final DartType targetBean;

  ManyToManySpec(
      this.property, this.pivotBean, this.targetBean, this.linkByName);
}

/// Contains information about `HasOne`, `HasMany`, `ManyToMany` relationships
abstract class Preload {
  DartType get bean;

  String get beanName => bean.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';

  String get modelName => getModelForBean(bean).name;

  String get property;

  List<ParsedField> get fields;

  List<ParsedField> get foreignFields;

  bool get hasMany;
}

/// Contains information about `HasOne`, `HasMany` relationships
class PreloadOneToX extends Preload {
  final DartType bean;

  final String property;

  final List<ParsedField> fields = <ParsedField>[];

  final List<ParsedField> foreignFields;

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

  final UnAssociatedBean targetInfo;

  final UnAssociatedBean beanInfo;

  final List<ParsedField> fields = <ParsedField>[];

  final List<ParsedField> foreignFields;

  final bool hasMany = true;

  PreloadManyToMany(this.bean, this.targetBean, this.property, this.targetInfo,
      this.beanInfo, this.foreignFields);
}
