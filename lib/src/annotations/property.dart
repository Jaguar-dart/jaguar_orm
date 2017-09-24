part of jaguar_orm.annotation;

/// Annotation on model property to ignore it
class IgnoreColumn {
  const IgnoreColumn();
}

/// Interface for annotation on/for model property
abstract class ColumnBase {
  /// Name of the column in database
  String get col;

  bool get nullable;
}

/// Annotation to declare a model property as database column
///
/// In general, all model properties are used as
class Column implements ColumnBase {
  /// Name of the column in database
  final String col;

  final bool nullable;

  const Column({this.col, this.nullable: false});
}

/// Annotation to declare a model property as primary key in database table
class PrimaryKey implements ColumnBase {
  /// Name of the column in database
  final String col;

  final bool nullable;

  const PrimaryKey({this.col, this.nullable: false});
}

abstract class ForeignBase implements ColumnBase {
  String get refCol;
}

class ForeignKey implements ColumnBase {
  final Type bean;

  /// Name of the column in database
  final String col;

  final bool nullable;

  final String table;

  /// The field/column in the foreign bean
  final String refCol;

  const ForeignKey(this.table,
      {this.col, this.nullable: false, this.refCol: 'id'})
      : bean = null;
}
