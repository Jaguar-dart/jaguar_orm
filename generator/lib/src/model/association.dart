part of jaguar_orm.generator.model;

class ManyToManyTarget {
  // TODO bean?

  final String beanInstanceName;

  final String modelName;

  const ManyToManyTarget(
      {@required this.beanInstanceName, @required this.modelName});
}

abstract class Association {
  DartType get bean;

  DartType get model;

  List<ParsedField> get fields;

  List<ParsedField> get foreignFields;

  bool get toMany;

  String get modelName;
}

/// [BelongsTo] association has a complementing [Relation]
class AssociationByRelation implements Association {
  final DartType bean;

  final DartType model;

  final String name;

  final List<ParsedField> fields;

  final List<ParsedField> foreignFields;

  final bool toMany;

  bool get isManyToMany => manyToManyTarget != null;

  final ManyToManyTarget manyToManyTarget;

  AssociationByRelation(this.bean, this.fields, this.foreignFields,
      this.manyToManyTarget, this.toMany,
      {@required this.name})
      : model = getModelForBean(bean);

  String get beanName => bean.name;

  String get modelName => model.name;

  String get beanInstanceName => uncap(modelName) + 'Bean';
}

abstract class ForeignAssociation {}

/// [BelongsTo] association does not have a complementing [Relation].
class AssociationWithoutRelation extends ForeignAssociation
    implements Association {
  final DartType bean;

  final DartType model;

  final List<ParsedField> fields;

  final List<ParsedField> foreignFields;

  final bool toMany;

  AssociationWithoutRelation(
      this.bean, this.fields, this.foreignFields, this.toMany)
      : model = getModelForBean(bean);

  String get modelName => model.name;
}

class ReferenceAssociation extends ForeignAssociation {
  final DartType bean;

  final DartType model;

  final List<ParsedField> fields;

  ReferenceAssociation(this.bean, this.fields) : model = getModelForBean(bean);
}
