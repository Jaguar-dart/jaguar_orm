import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_orm_gen/src/common/common.dart';
import 'model.dart';

abstract class RelationSpec {
  String get property;

  String get linkBy;
}

abstract class HasXSpec implements RelationSpec {
  String get property;

  String get linkBy;

  DartType get bean;
}

class HasOneSpec implements HasXSpec {
  final String property;

  final String linkBy;

  final DartType bean;

  HasOneSpec(this.property, this.bean, this.linkBy);
}

class HasManySpec implements HasXSpec {
  final String property;

  final String linkBy;

  final DartType bean;

  HasManySpec(this.property, this.bean, this.linkBy);
}

class ManyToManySpec implements RelationSpec {
  final String property;

  final String linkBy;

  final DartType pivotBean;

  final DartType targetBean;

  ManyToManySpec(
      this.property, this.pivotBean, this.targetBean, this.linkBy);
}

/// Contains information about `HasOne`, `HasMany`, `ManyToMany` relationships
abstract class Preload {
  RelationSpec get spec;

  DartType get bean;

  String get beanName => bean.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';

  String get modelName => getModelForBean(bean).name;

  String get linkBy => spec.linkBy;

  String get property => spec.property;

  List<ParsedField> get fields;

  List<ParsedField> get foreignFields;

  bool get hasMany;
}

/// Contains information about `HasOne`, `HasMany` relationships
class PreloadOneToX extends Preload {
  final HasXSpec spec;

  DartType get bean => spec.bean;

  final List<ParsedField> fields = <ParsedField>[];

  final List<ParsedField> foreignFields;

  /// true for `HasMany`. false for `HasOne`
  bool get hasMany => spec is HasManySpec;

  PreloadOneToX(this.spec, this.foreignFields);
}

class PreloadManyToMany extends Preload {
  final ManyToManySpec spec;

  DartType get bean => spec.pivotBean;

  DartType get targetBean => spec.targetBean;

  String get targetBeanName => targetBean.name;

  String get targetBeanInstanceName => uncap(targetModelName) + 'Bean';

  String get targetModelName => getModelForBean(targetBean).name;

  String get property => spec.property;

  final UnAssociatedBean targetInfo;

  final UnAssociatedBean beanInfo;

  final List<ParsedField> fields = <ParsedField>[];

  final List<ParsedField> foreignFields;

  final bool hasMany = true;

  PreloadManyToMany(
      this.spec, this.targetInfo, this.beanInfo, this.foreignFields);
}
