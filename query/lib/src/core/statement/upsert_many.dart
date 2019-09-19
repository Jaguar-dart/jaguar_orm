part of query.core;

/// Insert or update many SQL statement builder.
///
/// Use `into` method to set the table to insert into.
/// Use `add`, `addAll`, `addMap` and `addAllMap` to set column values.
///
/// Use `exec` statement or `Connection` to execute the statement against a
/// database.
class UpsertMany implements Statement {
  final String name;

  final List<Upsert> _bulkValues = [];

  UpsertMany(this.name) {
    _immutable = ImUpsertMany(this);
  }

  UpsertMany addAll(List<List<SetColumn>> items) {
    _bulkValues.clear();
    for (var i = 0; i < items.length; ++i) {
      var item = items[i];
      _bulkValues.add(Upsert(
        name,
      )..setMany(item));
    }

    return this;
  }

  /// Executes the statement with the given connection.
  Future<T> exec<T>(Connection connection) => connection.upsertMany<T>(this);

  ImUpsertMany _immutable;

  /// Read-only representation of this statement.
  ImUpsertMany get asImmutable => _immutable;
}

class ImUpsertMany {
  final UpsertMany _inner;

  ImUpsertMany(this._inner)
      : values = UnmodifiableListView<ImUpsert>(_inner._bulkValues.map((values) => values.asImmutable));

  String get table => _inner.name;

  final UnmodifiableListView<ImUpsert> values;
}
