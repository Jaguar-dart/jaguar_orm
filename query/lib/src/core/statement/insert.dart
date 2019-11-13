part of query;

/// Insert SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `set`, `setMany`, `setValue`, `setInt`, `setString`, `setBool`,
/// `setDateTime` and `setValues` to set column values.
///
/// Use `exec` statement or `Adapter` to execute the statement against a
/// database.
class Insert implements Statement, Settable {
  final String name;
  final bool ignoreIfExist;

  String _id;

  final Map<String, dynamic> _values = {};

  Insert(this.name, {this.ignoreIfExist = false}) {
    _immutable = ImmutableInsertStatement(this);
  }

  /// Id is the auto-generated primary key that is set by the database. [Adapter]
  /// will request the database to return this column on inserts.
  Insert id(String id) {
    _id = id;
    return this;
  }

  /// Set the the [value] of given column ([field]).
  Insert set<ValType>(Field<ValType> field, ValType value) {
    setValue(field.name, value);
    return this;
  }

  /// Sets many [columns] with a single call.
  Insert setMany(Iterable<SetColumn> columns) {
    for (SetColumn col in columns) {
      _values[col.name] = col.value;
    }
    return this;
  }

  /// Sets the [value] of the given [column].
  Insert setValue<ValType>(String column, ValType value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Insert setValues(Map<String, dynamic> values) {
    _values.addAll(values);
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Insert setInt(String column, int value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of string [column].
  Insert setString(String column, String value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of bool [column].
  Insert setBool(String column, bool value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of date time [column].
  Insert setDateTime(String column, DateTime value) {
    _values[column] = value;
    return this;
  }

  /// Executes the statement with the given adapter.
  Future<T> exec<T>(Adapter adapter) => adapter.insert<T>(this);

  ImmutableInsertStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableInsertStatement get asImmutable => _immutable;

//  Insert setId<ValType>(Field<ValType> field, ValType value) {
//    _id = field.name;
//    return set<ValType>(field, value);
//  }

//  Insert setIdValue<ValType>(String column, ValType value) {
//    _id = column;
//    return setValue<ValType>(column, value);
//  }
}

class ImmutableInsertStatement {
  final Insert _inner;

  ImmutableInsertStatement(this._inner)
      : values = UnmodifiableMapView<String, dynamic>(_inner._values);

  String get table => _inner.name;

  String get id => _inner._id;

  bool get ignoreIfExist => _inner.ignoreIfExist;

  final UnmodifiableMapView<String, dynamic> values;
}
