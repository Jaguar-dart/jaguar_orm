part of query;

class CreateDb implements Statement {
  String _dbName;

  String get dbName => _dbName;

  CreateDb(this._dbName);

  CreateDb named(String dbName) {
    this._dbName = dbName;
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.createDatabase(this);
}

class DropDb implements Statement {
  String _dbName;

  String get dbName => _dbName;

  bool _onlyIfExists = false;

  DropDb(this._dbName);

  DropDb named(String dbName) {
    this._dbName = dbName;
    return this;
  }

  DropDb onlyIfExists() {
    _onlyIfExists = true;
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.dropDb(this);
}
