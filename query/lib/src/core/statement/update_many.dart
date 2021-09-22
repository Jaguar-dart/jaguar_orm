part of query;

class UpdateMany implements Statement /*, Whereable */ {
  String name;

  final List<Update> _bulkValues = [];

  UpdateMany(this.name) {
    _immutable = ImmutableUpdateManyStatement(this);
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

  Future<void> exec<T>(Adapter adapter) => adapter.updateMany(this);

  late ImmutableUpdateManyStatement _immutable;

  /// Read-only representation of this statement.
  ImmutableUpdateManyStatement get asImmutable => _immutable;
}

class ImmutableUpdateManyStatement {
  final UpdateMany _inner;

  ImmutableUpdateManyStatement(this._inner)
      : values = UnmodifiableListView<ImmutableUpdateStatement>(
            _inner._bulkValues.map((values) => values.asImmutable));

  String get tableName => _inner.name;

  final UnmodifiableListView<ImmutableUpdateStatement> values;
}
