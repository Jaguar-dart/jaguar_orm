part of query;

class InsertMany implements Statement {
  String _tableName;

  final List<Map<String, dynamic>> _bulkValues = [];

  InsertMany() {
    _info = new QueryInsertManyInfo(this);
  }

  String get tableName => _tableName;

  InsertMany into(String tableName) {
    if (_tableName != null) {
      throw new Exception("Name already assigend!");
    }
    _tableName = tableName;
    return this;
  }

  InsertMany bulk(List<List<SetColumn>> items) {
    _bulkValues.clear();
    _bulkValues.addAll(items.map(toMap));
    return this;
  }

  Map<String, dynamic> toMap(List<SetColumn> data) {
    final map = Map<String, dynamic>();
    for (var d in data) {
      map[d.getColumn] = d.getValue;
    }
    return map;
  }

  InsertMany bulkFromMap(List<Map<String, dynamic>> items) {
    _bulkValues.clear();
    _bulkValues.addAll(items);
    return this;
  }

  Future<T> exec<T>(Adapter adapter) => adapter.insertMany<T>(this);

  QueryInsertManyInfo _info;

  QueryInsertManyInfo get info => _info;
}

class QueryInsertManyInfo {
  final InsertMany _inner;

  QueryInsertManyInfo(this._inner)
      : values = new UnmodifiableListView<UnmodifiableMapView<String, dynamic>>(_inner._bulkValues.map((values) => UnmodifiableMapView(values)));

  String get tableName => _inner.tableName;

  final UnmodifiableListView<UnmodifiableMapView<String, dynamic>> values;
}
