part of query.core;

/// Insert SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `set`, `setMany`, `setValue`, `setInt`, `setString`, `setBool`,
/// `setDateTime` and `setValues` to set column values.
///
/// Use `exec` statement or `Connection` to execute the statement against a
/// database.
class Insert implements Statement, Settable {
  final String name;

  String _id;

  final Map<String, Expression> _values = {};

  Insert(this.name) {
    _immutable = ImInsert(this);
  }

  /// Id is the auto-generated primary key that is set by the database. [Connection]
  /// will request the database to return this column on inserts.
  Insert id(String id) {
    _id = id;
    return this;
  }

  /// Set the the [value] of given column ([field]).
  Insert set(/* String | I */ column, /* literal | Expression */ value) {
    if (column is I) column = column.name;
    _values[column] = Expression.toExpression(value);
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Insert setValues(Map<String, /* literal | Expression */ dynamic> values) {
    values.forEach(set);
    return this;
  }

  Insert setOne(SetColumn col) {
    _values[col.name] = col.value;
    return this;
  }

  /// Sets many [columns] with a single call.
  Insert setMany(Iterable<SetColumn> columns) {
    for (SetColumn c in columns) _values[c.name] = c.value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Insert setInt(/* String | I */ column, int value) {
    return set(column, IntLiteral(value));
  }

  /// Convenience method to set the [value] of string [column].
  Insert setString(/* String | I */ column, String value) {
    return set(column, StrLiteral(value));
  }

  /// Convenience method to set the [value] of bool [column].
  Insert setBool(/* String | I */ column, bool value) {
    return set(column, BoolLiteral(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Insert setTimestamp(/* String | I */ column, DateTime value) {
    return set(column, TimestampLiteral(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Insert setDuration(/* String | I */ column, Duration value) {
    return set(column, DurationLiteral(value));
  }

  /// Executes the statement with the given connection.
  Future<T> exec<T>(Connection connection) => connection.insert<T>(this);

  ImInsert _immutable;

  /// Read-only representation of this statement.
  ImInsert get asImmutable => _immutable;

//  Insert setId<ValType>(Field<ValType> field, ValType value) {
//    _id = field.name;
//    return set<ValType>(field, value);
//  }

//  Insert setIdValue<ValType>(String column, ValType value) {
//    _id = column;
//    return setValue<ValType>(column, value);
//  }
}

class ImInsert {
  final Insert _inner;

  ImInsert(this._inner)
      : values = UnmodifiableMapView<String, Expression>(_inner._values);

  String get table => _inner.name;

  String get id => _inner._id;

  final UnmodifiableMapView<String, Expression> values;
}
