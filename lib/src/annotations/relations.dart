part of jaguar_orm.annotation;

class BelongsTo {
  final String by;

  const BelongsTo(this.by);
}

class HasOneBean {
  final Type bean;

  const HasOneBean(this.bean);
}

class HasMany {
  const HasMany();
}

/* TODO
/// Annotation to declare a model property as foreign key with 'one-to-one'
/// relationship to another model
class OneToOne implements ColumnBase {
  /// Name of the column in database
  final String key;

  /// The bean of the foreign model
  final Type bean;

  /// The field/column in the foreign bean
  final Symbol field;

  const OneToOne(this.bean, this.field, [this.key]);
}

/// Annotation to declare a model property as foreign key with 'many-to-one'
/// relationship to another model
class ManyToOne implements ColumnBase {
  /// Name of the column in database
  final String key;

  /// The bean of the foreign model
  final Type bean;

  /// The field/column in the foreign bean
  final Symbol field;

  const ManyToOne(this.bean, this.field, [this.key]);
}

/// Annotation to declare a model property as foreign key with 'many-to-many'
/// relationship to another model
class ManyToMany implements ColumnBase {
  /// Name of the column in database
  final String key;

  /// The bean of the foreign model
  final Type bean;

  /// The field/column in the foreign bean
  final Symbol field;

  const ManyToMany(this.bean, this.field, [this.key]);
}
*/
