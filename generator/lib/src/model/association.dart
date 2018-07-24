part of jaguar_orm.generator.model;

abstract class BeanedAssociation {
  DartType get bean;

  DartType get model;

  List<Field> get fields;

  List<Field> get foreignFields;

  bool get byHasMany;

  String get modelName;
}

/// Model that contains information to write find method by foreign relation
class BelongsToAssociation implements BeanedAssociation {
  final DartType bean;

  final DartType model;

  final List<Field> fields;

  final List<Field> foreignFields;

  final bool byHasMany;

  bool get belongsToMany => other is PreloadManyToMany;

  final Preload other;

  BelongsToAssociation(
      this.bean, this.fields, this.foreignFields, this.other, this.byHasMany)
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

abstract class ForeignAssociation {}

class BeanedForeignAssociation extends ForeignAssociation
    implements BeanedAssociation {
  final DartType bean;

  final DartType model;

  final List<Field> fields;

  final List<Field> foreignFields;

  final bool byHasMany;

  BeanedForeignAssociation(
      this.bean, this.fields, this.foreignFields, this.byHasMany)
      : model = getModelForBean(bean);

  String get modelName => model.name;
}

class TabledForeignAssociation extends ForeignAssociation {
  final DartType bean;

  final DartType model;

  final List<Field> fields;

  TabledForeignAssociation(this.bean, this.fields)
      : model = getModelForBean(bean);
}
