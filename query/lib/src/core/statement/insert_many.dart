part of query;

/// Insert many SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `add`, `addAll`, `addMap` and `addAllMap` to set column values.
///
/// Use `exec` statement or `Adapter` to execute the statement against a
/// database.
class InsertMany implements Statement {
  String _tableName;

  final List<Map<String, dynamic>> _bulkValues = [];

  InsertMany([/* Iterable<SetColumn> | Iterable<Iterable<SetColumn>> */ rows]) {
    _immutable = new ImmutableInsertManyStatement(this);

    if (rows is Iterable<Iterable<SetColumn>>) {
      addAll(rows);
    } else if (rows is Iterable<SetColumn>) add(rows);
  }

  String get table => _tableName;

  InsertMany into(String tableName) {
    if (_tableName != null) {
      throw new Exception("Name already assigend!");
    }
    _tableName = tableName;
    return this;
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

  /// Executes the statement with the given adapter.
  Future<T> exec<T>(Adapter adapter) => adapter.insertMany<T>(this);

  ImmutableInsertManyStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableInsertManyStatement get asImmutable => _immutable;
}

class ImmutableInsertManyStatement {
  final InsertMany _inner;

  ImmutableInsertManyStatement(this._inner)
      : values = new UnmodifiableListView<UnmodifiableMapView<String, dynamic>>(
            _inner._bulkValues.map((values) => UnmodifiableMapView(values)));

  String get table => _inner.table;

  final UnmodifiableListView<UnmodifiableMapView<String, dynamic>> values;
}
