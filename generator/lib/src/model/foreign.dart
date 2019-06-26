part of jaguar_orm.generator.model;

abstract class ForeignSpec implements ColumnDef {
  String get references;
}

class BelongsToSpec implements ForeignSpec {
  final DartType bean;

  final String references;

  final DartType model;

  final bool belongsToMany;

  /// Name of the foreign key.
  ///
  /// Is also used to connect to [Relation]. Same as [BelongsTo.link].
  final String link;

  BelongsToSpec(this.bean, this.references, this.belongsToMany, {this.link})
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

class ReferencesSpec implements ForeignSpec {
  final String table;

  final String references;

  final String link;

  // TODO association

  ReferencesSpec(this.table, this.references, {this.link});
}

/* TODO
class BeanedForeign implements Foreign {
  final DartType bean;

  final String refCol;

  final DartType model;

  BeanedForeign(this.bean, this.refCol) : model = getModelForBean(bean);
}
*/
