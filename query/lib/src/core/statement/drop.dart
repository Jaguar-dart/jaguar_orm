part of query;

class Drop implements Statement {
  final List<String> _tables = [];

  bool _onlyIfExists = false;

  UnmodifiableListView<String> get tables => new UnmodifiableListView(_tables);

  bool get onlyDropIfExists => _onlyIfExists;

  Drop();

  Drop named(String table) {
    _tables.add(table);
    return this;
  }

  Drop many(List<String> table) {
    _tables.addAll(table);
    return this;
  }

  Drop onlyIfExists() {
    _onlyIfExists = true;
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.dropTable(this);
}
