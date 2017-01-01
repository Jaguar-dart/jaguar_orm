library jaguar_orm.annotation;

export 'package:jaguar_query/jaguar_query.dart' show OrderBy;

/// Annotation on model class to request generation of ORM bean for a model
class GenBean {
  const GenBean();
}

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

/*
class AddColumn implements ColumnBase {
  final Symbol field;

  final String key;

  const AddColumn(this.field, [this.key]);
}
*/

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

  /// The bean of the foreign model
  final Type bean;

  /// The field/column in the foreign bean
  final Symbol field;

  const ForeignKey(this.bean, this.field, [this.key]);
}

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

/// Annotation to generate 'find' method in beans
class Find {
  const Find();
}

/// Annotation to generate 'update' method in beans
class Update {
  const Update();
}

/// Annotation to generate 'delete' method in beans
class Delete {
  const Delete();
}

/// Annotation on parameter of bean method to declare them as condition
abstract class Where {}

/// Annotation on parameter of bean method to declare them as 'is equal to' condition
class WhereEq implements Where {
  const WhereEq();
}

/// Annotation on parameter of bean method to declare them as 'is not equal to' condition
class WhereNe implements Where {
  const WhereNe();
}

/// Annotation on parameter of bean method to declare them as 'is less than' condition
class WhereLt implements Where {
  const WhereLt();
}

/// Annotation on parameter of bean method to declare them as 'is greater than' condition
class WhereGt implements Where {
  const WhereGt();
}

/// Annotation on parameter of bean method to declare them as 'is greater than or equal to'
/// condition
class WhereGtEq implements Where {
  const WhereGtEq();
}

/// Annotation on parameter of bean method to declare them as 'is less than or equal to'
/// condition
class WhereLtEq implements Where {
  const WhereLtEq();
}

/// Annotation on parameter of bean method to declare them as 'is like' condition
class WhereLike implements Where {
  const WhereLike();
}

/// Annotation on parameter of bean method to declare them as 'set'
class SetField {
  const SetField();
}
