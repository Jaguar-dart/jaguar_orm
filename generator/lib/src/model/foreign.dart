part of jaguar_orm.generator.model;

abstract class ForeignSpec implements ColumnDef {
  String get references;
}

class BelongsToSpec implements ForeignSpec {
  final DartType bean;

  final String references;

  final DartType model;

  final bool byHasMany;

  final bool belongsToMany;

  final String name;

  BelongsToSpec(this.bean, this.references, this.byHasMany, this.belongsToMany,
      {this.name})
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

class ReferencesSpec implements ForeignSpec {
  final String table;

  final String references;

  final String name;

  // TODO association

  ReferencesSpec(this.table, this.references, {this.name});
}

/* TODO
class BeanedForeign implements Foreign {
  final DartType bean;

  final String refCol;

  final DartType model;

  BeanedForeign(this.bean, this.refCol) : model = getModelForBean(bean);
}
*/
