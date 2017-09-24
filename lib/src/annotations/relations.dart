part of jaguar_orm.annotation;

abstract class Relation {}

class HasOne implements Relation {
  final Type bean;

  const HasOne(this.bean);
}

class HasMany implements Relation {
  final Type bean;

  const HasMany(this.bean);
}

class ManyToMany implements Relation {
  final Type pivotBean;

  final Type targetBean;

  const ManyToMany(this.pivotBean, this.targetBean);
}

class BelongsTo implements ForeignKey {
  final Type bean;

  /// Name of the column in database
  final String col;

  final bool nullable;

  final String table = null;

  /// The field/column in the foreign bean
  final String refCol;

  const BelongsTo(this.bean,
      {this.col, this.nullable: false, this.refCol: 'id'});
}

class BelongsToMany implements ForeignKey {
  final Type bean;

  /// Name of the column in database
  final String col;

  final bool nullable;

  final String table = null;

  /// The field/column in the foreign bean
  final String refCol;

  const BelongsToMany(this.bean,
      {this.col, this.nullable: false, this.refCol: 'id'});
}
