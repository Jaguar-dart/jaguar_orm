part of query;

/// Insert or update SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `set`, `setMany`, `setValue`, `setInt`, `setString`, `setBool`,
/// `setDateTime` and `setValues` to set column values.
///
/// Use `exec` statement or `Adapter` to execute the statement against a
/// database.
class Upsert implements Statement {
  final String name;

  final Map<String, dynamic> _values = {};

  String _id;

  Upsert(this.name) {
    _immutable = ImmutableUpsertStatement(this);
  }

  /// Id is the auto-generated primary key that is set by the database. [Adapter]
  /// will request the database to return this column on inserts.
  Upsert id(String id) {
    _id = id;
    return this;
  }

  /// Set the the [value] of given column ([field]).
  Upsert set<ValType>(Field<ValType> field, ValType value) {
    setValue(field.name, value);
    return this;
  }

  /// Sets many [columns] with a single call.
  Upsert setMany(Iterable<SetColumn> columns) {
    for (SetColumn col in columns) {
      _values[col.name] = col.value;
    }
    return this;
  }

  /// Sets the [value] of the given [column].
  Upsert setValue<ValType>(String column, ValType value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Upsert setInt(String column, int value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of string [column].
  Upsert setString(String column, String value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of bool [column].
  Upsert setBool(String column, bool value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of date time [column].
  Upsert setDateTime(String column, DateTime value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Upsert setValues(Map<String, dynamic> values) {
    _values.addAll(values);
    return this;
  }

  /// Executes the statement with the given adapter.
  Future<T> exec<T>(Adapter adapter) => adapter.upsert<T>(this);

  ImmutableUpsertStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableUpsertStatement get asImmutable => _immutable;
}

class ImmutableUpsertStatement {
  final Upsert _inner;

  ImmutableUpsertStatement(this._inner)
      : values = UnmodifiableMapView<String, dynamic>(_inner._values);

  String get table => _inner.name;

  final UnmodifiableMapView<String, dynamic> values;
}
