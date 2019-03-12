part of query;

class SelColumn {
  final String name;

  final String alias;

  SelColumn(this.name, [this.alias]);
}

class CountSelColumn extends SelColumn {
  final bool isDistinct;

  CountSelColumn(String name, {String alias, this.isDistinct = false})
      : super(name, alias);
}

/// name:value pair used to set a column named [name] to [value]. Used during
/// inserts and updates.
class SetColumn<ValType> {
  /// Name of the column to set
  final String name;

  /// Value of the column
  final ValType value;

  SetColumn(this.name, this.value);

  /// Returns a [SetColumn] that sets the current column to new [value].
  SetColumn<ValType> setTo(ValType value) => SetColumn<ValType>(name, value);
}

abstract class Statement {}

abstract class Settable implements Statement {
  Settable set<ValType>(Field<ValType> field, ValType value);

  Settable setMany(List<SetColumn> columns);

  Settable setValue<ValType>(String column, ValType value);

  Settable setValues(Map<String, dynamic> values);

  /// Convenience method to set the [value] of int [column].
  Settable setInt(String column, int value);

  /// Convenience method to set the [value] of string [column].
  Settable setString(String column, String value);

  /// Convenience method to set the [value] of bool [column].
  Settable setBool(String column, bool value);

  /// Convenience method to set the [value] of date time [column].
  Settable setDateTime(String column, DateTime value);
}

abstract class Whereable implements Statement {
  Whereable or(Expression exp);

  Whereable and(Expression exp);

  Whereable orMap<T>(Iterable<T> iterable, MappedExpression<T> func);

  Whereable andMap<T>(Iterable<T> iterable, MappedExpression<T> func);

  Whereable where(Expression exp);

  Whereable eq<T>(String column, T val);

  Whereable ne<T>(String column, T val);

  Whereable gt<T>(String column, T val);

  Whereable gtEq<T>(String column, T val);

  Whereable ltEq<T>(String column, T val);

  Whereable lt<T>(String column, T val);

  Whereable like(String column, String val);

  Whereable between<T>(String column, T low, T high);
}
