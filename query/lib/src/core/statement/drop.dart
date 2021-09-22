part of query;

class Drop implements Statement {
  final _tables = <String>[];

  final bool onlyIfExists;

  Drop(/* String | Iterable<String> */ table, {this.onlyIfExists = false}) {
    if (table is String) _tables.add(table);
    if (table is Iterable<String>) _tables.addAll(table);
  }

  Iterable<String> get tables => _tables;

  Drop also(String table) {
    _tables.add(table);
    return this;
  }

  Drop allOf(Iterable<String> tables) {
    _tables.addAll(tables);
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.dropTable(this);
}
