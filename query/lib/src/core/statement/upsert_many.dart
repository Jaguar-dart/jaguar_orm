part of query;

/// Insert or update many SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `add`, `addAll`, `addMap` and `addAllMap` to set column values.
///
/// Use `exec` statement or `Adapter` to execute the statement against a
/// database.
class UpsertMany implements Statement {
  final String name;

  final List<Map<String, dynamic>> _bulkValues = [];

  UpsertMany(this.name) {
    _immutable = ImmutableUpsertManyStatement(this);
  }

  /// Adds a single [row] to be inserted.
  UpsertMany add(Iterable<SetColumn> row) {
    _bulkValues.add(_convertColsToMap(row));
    return this;
  }

  /// Adds many [rows] to be inserted.
  UpsertMany addAll(Iterable<Iterable<SetColumn>> rows) {
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
  UpsertMany addMap(Map<String, dynamic> row) {
    _bulkValues.add(row);
    return this;
  }

  /// Adds many [rows] to be inserted.
  UpsertMany addAllMap(Iterable<Map<String, dynamic>> rows) {
    _bulkValues.addAll(rows);
    return this;
  }

  /// Executes the statement with the given adapter.
  Future<T> exec<T>(Adapter adapter) => adapter.upsertMany<T>(this);

  ImmutableUpsertManyStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableUpsertManyStatement get asImmutable => _immutable;
}

class ImmutableUpsertManyStatement {
  final UpsertMany _inner;

  ImmutableUpsertManyStatement(this._inner)
      : values = UnmodifiableListView<UnmodifiableMapView<String, dynamic>>(
            _inner._bulkValues.map((values) => UnmodifiableMapView(values)));

  String get table => _inner.name;

  final UnmodifiableListView<UnmodifiableMapView<String, dynamic>> values;
}
