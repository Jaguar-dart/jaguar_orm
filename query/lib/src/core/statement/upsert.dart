part of query.core;

/// Insert or update SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `set`, `setMany`, `setValue`, `setInt`, `setString`, `setBool`,
/// `setDateTime` and `setValues` to set column values.
///
/// Use `exec` statement or `Connection` to execute the statement against a
/// database.
class Upsert implements Statement {
  final String name;

  final Map<String, Expression> _values = {};

  String _id;

  Upsert(this.name) {
    _immutable = ImUpsert(this);
  }

  /// Id is the auto-generated primary key that is set by the database. [Connection]
  /// will request the database to return this column on upserts.
  Upsert id(String id) {
    _id = id;
    return this;
  }

  /// Set the the [value] of given column ([field]).
  Upsert set(/* String | I */ column, /* literal | Expression */ value) {
    if (column is I) column = column.name;
    _values[column] = Expression.toExpression(value);
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Upsert setValues(Map<String, /* literal | Expression */ dynamic> values) {
    values.forEach(set);
    return this;
  }

  Upsert setOne(SetColumn col) {
    _values[col.name] = col.value;
    return this;
  }

  /// Sets many [columns] with a single call.
  Upsert setMany(Iterable<SetColumn> columns) {
    for (SetColumn c in columns) _values[c.name] = c.value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Upsert setInt(/* String | I */ column, int value) {
    return set(column, IntL(value));
  }

  /// Convenience method to set the [value] of string [column].
  Upsert setString(/* String | I */ column, String value) {
    return set(column, StrL(value));
  }

  /// Convenience method to set the [value] of bool [column].
  Upsert setBool(/* String | I */ column, bool value) {
    return set(column, BoolL(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Upsert setTimestamp(/* String | I */ column, DateTime value) {
    return set(column, TimestampL(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Upsert setDuration(/* String | I */ column, Duration value) {
    return set(column, DurationL(value));
  }

  /// Executes the statement with the given connection.
  Future<T> exec<T>(Connection connection) => connection.upsert<T>(this);

  ImUpsert _immutable;

  /// Read-only representation of this statement.
  ImUpsert get asImmutable => _immutable;
}

class ImUpsert {
  final Upsert _inner;

  ImUpsert(this._inner) : values = UnmodifiableMapView<String, Expression>(_inner._values);

  String get table => _inner.name;

  final UnmodifiableMapView<String, Expression> values;
}
