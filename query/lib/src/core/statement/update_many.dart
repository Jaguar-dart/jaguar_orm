part of query;

class UpdateMany implements Statement /*, Whereable */ {
  final String name;

  final List<Update> _bulkValues = [];

  ImmutableUpdateManyStatement get asImmutable => ImmutableUpdateManyStatement(this);

  UpdateMany(this.name);

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

}

class ImmutableUpdateManyStatement {
  final UpdateMany _inner;

  ImmutableUpdateManyStatement(this._inner)
      : values = UnmodifiableListView<ImmutableUpdateStatement>(
            _inner._bulkValues.map((values) => values.asImmutable));

  String get tableName => _inner.name;

  final UnmodifiableListView<ImmutableUpdateStatement> values;
}
