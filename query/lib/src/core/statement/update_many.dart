part of query;

class UpdateMany implements Statement {
  String name;

  final List<Update> _bulkValues = [];

  UpdateMany(this.name) {
    _immutable = new ImmutableUpdateManyStatement(this);
  }

  UpdateMany addAll(List<List<SetColumn>> items, List<Expression> where) {
    _bulkValues.clear();
    for (var i = 0; i < items.length; ++i) {
      var item = items[i];
      var w = where[i];
      _bulkValues.add(Update(
        name,
        where: w,
      )..setMany(item));
    }

    return this;
  }

  Future<T> exec<T>(Adapter adapter) => adapter.updateMany(this);

  ImmutableUpdateManyStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableUpdateManyStatement get asImmutable => _immutable;
}

class ImmutableUpdateManyStatement {
  final UpdateMany _inner;

  ImmutableUpdateManyStatement(this._inner)
      : values = new UnmodifiableListView<ImmutableUpdateStatement>(
            _inner._bulkValues.map((values) => values.asImmutable));

  String get tableName => _inner.name;

  final UnmodifiableListView<ImmutableUpdateStatement> values;
}
