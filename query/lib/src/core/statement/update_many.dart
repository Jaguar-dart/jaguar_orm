part of query.core;

class UpdateMany implements Statement /*, Whereable */ {
  String name;

  final List<Update> _bulkValues = [];

  UpdateMany(this.name) {
    _immutable = ImUpdateMany(this);
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

  Future<T> exec<T>(Connection connection) => connection.updateMany(this);

  ImUpdateMany _immutable;

  /// Read-only representation of this statement.
  ImUpdateMany get asImmutable => _immutable;
}

class ImUpdateMany {
  final UpdateMany _inner;

  ImUpdateMany(this._inner)
      : values = UnmodifiableListView<ImUpdate>(
            _inner._bulkValues.map((values) => values.asImmutable));

  String get tableName => _inner.name;

  final UnmodifiableListView<ImUpdate> values;
}
