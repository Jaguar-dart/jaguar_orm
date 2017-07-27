part of jaguar_orm.annotation;

/// Annotation on model property to ignore it
class IgnoreColumn {
  const IgnoreColumn();
}

/// Interface for annotation on/for model property
abstract class ColumnBase {
  /// Name of the column in database
  String get key;
}

/// Annotation to declare a model property as database column
///
/// In general, all model properties are used as
class Column implements ColumnBase {
  /// Name of the column in database
  final String key;

  const Column([this.key]);
}

/// Annotation to declare a model property as primary key in database table
class PrimaryKey implements ColumnBase {
  /// Name of the column in database
  final String key;

  const PrimaryKey([this.key]);
}

/// Annotation to declare a model property as foreign key in database table
class ForeignKey implements ColumnBase {
  /// Name of the column in database
  final String key;

  /// The field/column in the foreign bean
  final String foreign;

  const ForeignKey(this.foreign, [this.key]);
}

/// Annotation to declare a model property as foreign key in database table
class ForeignKeyBean implements ColumnBase {
  final Type bean;

  /// Name of the column in database
  final String key;

  /// The field/column in the foreign bean
  final String foreign;

  const ForeignKeyBean(this.bean, {this.key, this.foreign: 'id'});
}