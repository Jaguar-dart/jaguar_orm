part of query.core;

class CreateDb implements Statement {
  final String name;

  CreateDb(this.name);

  Future<void> exec(Connection connection) => connection.createDatabase(this);
}

class DropDb implements Statement {
  final String name;

  bool _onlyIfExists = false;

  DropDb(this.name);

  DropDb onlyIfExists() {
    _onlyIfExists = true;
    return this;
  }

  Future<void> exec(Connection connection) => connection.dropDb(this);
}
