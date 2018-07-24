part of jaguar_orm.generator.model;

abstract class Foreign {
  String get refCol;
}

class BelongsToForeign implements Foreign {
  final DartType bean;

  final String refCol;

  final DartType model;

  final bool byHasMany;

  final bool belongsToMany;

  BelongsToForeign(this.bean, this.refCol, this.byHasMany, this.belongsToMany)
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

class TableForeign implements Foreign {
  final String table;

  final String refCol;

  TableForeign(this.table, this.refCol);
}
