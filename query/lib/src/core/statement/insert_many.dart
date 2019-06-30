part of query.core;

/// Insert many SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `add`, `addAll`, `addMap` and `addAllMap` to set column values.
///
/// Use `exec` statement or `Connection` to execute the statement against a
/// database.
class InsertMany implements Statement {
  final String name;

  final List<Map<String, dynamic>> _bulkValues = [];

  InsertMany(this.name) {
    _immutable = ImInsertMany(this);
  }

  /// Adds a single [row] to be inserted.
  InsertMany add(Iterable<SetColumn> row) {
    _bulkValues.add(_convertColsToMap(row));
    return this;
  }

  /// Adds many [rows] to be inserted.
  InsertMany addAll(Iterable<Iterable<SetColumn>> rows) {
    for (Iterable<SetColumn> row in rows)
      _bulkValues.add(_convertColsToMap(row));
    return this;
  }

  Map<String, dynamic> _convertColsToMap(Iterable<SetColumn> row) {
    final map = <String, dynamic>{};
    for (SetColumn d in row) map[d.name] = d.value;
    return map;
  }

  /// Adds a single [row] to be inserted.
  InsertMany addMap(Map<String, dynamic> row) {
    _bulkValues.add(row);
    return this;
  }

  /// Adds many [rows] to be inserted.
  InsertMany addAllMap(Iterable<Map<String, dynamic>> rows) {
    _bulkValues.addAll(rows);
    return this;
  }

  /// Executes the statement with the given connection.
  Future<T> exec<T>(Connection connection) => connection.insertMany<T>(this);

  ImInsertMany _immutable;

  /// Read-only representation of this statement.
  ImInsertMany get asImmutable => _immutable;
}

class ImInsertMany {
  final InsertMany _inner;

  ImInsertMany(this._inner)
      : values = UnmodifiableListView<UnmodifiableMapView<String, dynamic>>(
            _inner._bulkValues.map((values) => UnmodifiableMapView(values)));

  String get table => _inner.name;

  final UnmodifiableListView<UnmodifiableMapView<String, dynamic>> values;
}
