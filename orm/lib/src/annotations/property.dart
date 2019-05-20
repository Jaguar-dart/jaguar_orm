part of jaguar_orm.annotation;

/// Interface for annotation on/for model property
abstract class ColumnBase {
  /// Name of the column in database
  String get name;

  bool get isNullable;

  String get uniqueGroup;

  bool get auto;

  int get length;
}

/// Annotation on model property to ignore it
class IgnoreColumn implements ColumnBase {
  final String name = null;

  final bool isNullable = false;

  final String uniqueGroup = null;

  final bool auto = false;

  final int length = 0;

  const IgnoreColumn();
}

/// Annotation to declare a model property as database column
///
/// In general, all model properties are used as
class Column implements ColumnBase {
  /// Name of the column in database
  final String name;

  final bool isNullable;

  final String uniqueGroup;

  final bool auto;

  final int length;

  const Column(
      {this.name,
      this.isNullable = false,
      this.uniqueGroup,
      this.auto = false,
      this.length});
}

/// Annotation to declare a model property as primary key in database table
class PrimaryKey implements ColumnBase {
  /// Name of the column in database
  final String name;

  final bool isNullable;

  final String uniqueGroup;

  final bool auto;

  final int length;

  const PrimaryKey(
      {this.name,
      this.isNullable = false,
      this.uniqueGroup,
      this.auto = false,
      this.length});
}

abstract class ForeignBase implements ColumnBase {
  bool get isPrimary;
}

class ForeignKey implements ForeignBase {
  /// Name of the column in database
  final String name;

  final bool isPrimary;

  final bool isNullable;

  final String uniqueGroup;

  final String toTable;

  final String refCol;

  final bool auto = false;

  final int length;

  const ForeignKey(this.toTable,
      {this.name,
      this.isPrimary = false,
      this.isNullable = false,
      this.uniqueGroup,
      this.refCol = 'id',
      this.length});
}

class BelongsTo implements ForeignBase {
  final Type bean;

  /// Name of the column in database
  final String name;

  final bool isPrimary;

  final bool isNullable;

  final String uniqueGroup;

  final bool auto = false;

  final int length;

  /// The field/column in the foreign bean
  final String refCol;

  final bool byHasMany;

  final bool toMany;

  const BelongsTo(this.bean,
      this.byHasMany,
      {this.name,
      this.isPrimary = false,
      this.isNullable = false,
      this.uniqueGroup,
      this.length,
      this.refCol = 'id'})
      : toMany = false;

  const BelongsTo.many(this.bean,
      this.byHasMany,
      {this.name,
      this.isPrimary = false,
      this.isNullable = false,
      this.uniqueGroup,
      this.length,
      this.refCol = 'id'})
      : toMany = true;

}
