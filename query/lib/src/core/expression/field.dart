part of 'expression.dart';

/// Field is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final age = IntField(age);
///     var value = await Find()
///             .from('user')
///             .where(age > 30)  // Simplifies query expressions
///             .exec(adapter).one();
class Field<ValType> extends Expression implements I {
  /// Name of the field
  final String name;

  const Field(this.name);

  SelClause aliasAs(String alias, {String prefix}) =>
      SelClause(I((prefix != null ? '$prefix.' : '') + name), alias: alias);

  /// Returns a "set column" clause
  ///
  ///     UpdateStatement update = UpdateStatement();
  ///     Field<int> age = Field<int>('age');
  ///     update.set(age.set(20));
  SetColumn set(/* literal | Expression */ value) => SetColumn(name, value);
}

/// IntField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final age = IntField(age);
///     var value = await Find()
///             .from('user')
///             .where(age > 30)  // Simplifies query expressions
///             .exec(adapter).one();
class IntField extends Field<int> {
  IntField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool autoIncrement = false,
      bool isPrimary = false,
      bool notNull = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    statement.addInt(name,
        notNull: notNull,
        autoIncrement: autoIncrement,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
  }
}

/// DoubleField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final score = DoubleField('age');
///     var value = await Find()
///             .from('user')
///             .where(score > 90.0)  // Simplifies query expressions
///             .exec(adapter).one();
class DoubleField extends Field<double> {
  DoubleField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool notNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    statement.addDouble(name,
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
  }
}

/// StrField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final name = DoubleField('name');
///     var value = await Find()
///             .from('user')
///             .where(name.eq('teja'))  // Simplifies query expressions
///             .exec(adapter).one();
class StrField extends Field<String> {
  StrField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool notNull = false,
      int length = 20,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    statement.addStr(name,
        notNull: notNull,
        length: length,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
  }
}

/// DateTimeField is a convenience DSL used to construct queries in a concise and
/// understandable way.
class DateTimeField extends Field<DateTime> {
  DateTimeField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool notNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    statement.addTimestamp(name,
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
  }
}

/// BoolField is a convenience DSL used to construct queries in a concise and
/// understandable way.
class BoolField extends Field<bool> {
  BoolField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool notNull = false, List<Constraint> constraints = const []}) {
    statement.addBool(name, constraints: constraints);
  }
}
