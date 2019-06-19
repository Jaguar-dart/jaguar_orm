part of jaguar_orm.generator.model;

abstract class ForeignSpec implements ColumnDef {
  String get references;
}

class BelongsToForeign implements ForeignSpec {
  final DartType bean;

  final String references;

  final DartType model;

  final bool byHasMany;

  final bool belongsToMany;

  BelongsToForeign(
      this.bean, this.references, this.byHasMany, this.belongsToMany)
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

/*
class BeanedForeign implements Foreign {
  final DartType bean;

  final String refCol;

  final DartType model;

  BeanedForeign(this.bean, this.refCol) : model = getModelForBean(bean);
}
*/

class TableForeign implements ForeignSpec {
  final String table;

  final String references;

  TableForeign(this.table, this.references);
}
