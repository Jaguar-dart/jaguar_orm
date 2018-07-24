part of jaguar_orm.annotation;

/// Interface for annotation on/for model property
abstract class ColumnBase {
  /// Name of the column in database
  String get col;

  bool get nullable;

  /// Valid only in the context of integer types
  bool get autoIncrement;

  /// Valid only in the context of text types
  int get length;
}

/// Annotation on model property to ignore it
class IgnoreColumn implements ColumnBase {
  final String col = null;

  final bool nullable = true;

  final bool autoIncrement = false;

  final int length = 0;

  const IgnoreColumn();
}

/// Annotation to declare a model property as database column
///
/// In general, all model properties are used as
class Column implements ColumnBase {
  /// Name of the column in database
  final String col;

  final bool nullable;

  final bool autoIncrement;

  final int length;

  const Column(
      {this.col, this.nullable: false, this.autoIncrement: false, this.length});
}

/// Annotation to declare a model property as primary key in database table
class PrimaryKey implements ColumnBase {
  /// Name of the column in database
  final String col;

  final bool nullable;

  final bool autoIncrement;

  final int length;

  const PrimaryKey(
      {this.col, this.nullable: false, this.autoIncrement: false, this.length});
}

abstract class ForeignBase implements ColumnBase {}

class ForeignKey implements ForeignBase {
  /// Name of the column in database
  final String col;

  final bool nullable;

  final bool autoIncrement = false;

  final int length;

  final String table;

  /// The field/column in the foreign bean
  final String refCol;

  const ForeignKey(this.table,
      {this.col, this.nullable: false, this.length, this.refCol: 'id'});
}

class BelongsTo implements ForeignBase {
  final Type bean;

  /// Name of the column in database
  final String col;

  final bool nullable;

  final bool autoIncrement = false;

  final int length;

  /// The field/column in the foreign bean
  final String refCol;

  final bool byHasMany;

  final bool toMany;

  const BelongsTo(this.bean,
      {this.col,
      this.nullable: false,
      this.length,
      this.refCol: 'id',
      this.byHasMany})
      : toMany = false;

  const BelongsTo.many(this.bean,
      {this.col,
      this.nullable: false,
      this.length,
      this.refCol: 'id',
      this.byHasMany})
      : toMany = true;
}
