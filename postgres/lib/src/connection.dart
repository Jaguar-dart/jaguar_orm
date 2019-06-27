import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';
import 'package:postgres/postgres.dart' as pg;

class PgConn extends Connection<pg.PostgreSQLConnection> {
  pg.PostgreSQLConnection _connection;

  PgConn(this._connection);

  /// Closes all connections to the database.
  Future<void> release() => _connection.close();

  pg.PostgreSQLConnection get connection => _connection;

  Future<dynamic> query(String sql) async {
    return await _connection.mappedResultsQuery(sql);
  }

  Future<dynamic> exec(String sql) async {
    return await _connection.execute(sql);
  }

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> rows =
        await _connection.mappedResultsQuery(stStr);

    if (rows.isEmpty) return null;

    Map<String, Map<String, dynamic>> row = rows.first;

    if (row.length == 0) return {};

    if (row.length == 1) return rows.first.values.first;

    final ret = <String, dynamic>{};
    for (Map<String, dynamic> table in row.values) ret.addAll(table);
    return ret;
  }

  // Finds many records in the table
  Future<List<Map>> find(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> list =
        await _connection.mappedResultsQuery(stStr);

    return list.map((v) => v.values.first).toList();
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    String strSt = composeInsert(st);
    var ret = await _connection.query(strSt);
    if (ret.isEmpty || ret.first.isEmpty) return null;
    return ret.first.first;
  }

  @override
  Future<void> insertMany<T>(InsertMany statement) {
    throw UnimplementedError('InsertMany is not implemented yet!');
  }

  /// Executes the insert or update statement and returns the primary key of
  /// inserted row
  Future<T> upsert<T>(Upsert statement) {
    throw UnimplementedError();
  }

  /// Executes bulk insert or update statement
  Future<void> upsertMany<T>(UpsertMany statement) {
    throw UnimplementedError();
  }

  /// Updates a record in the table
  Future<int> update(Update st) => _connection.execute(composeUpdate(st));

  /// Deletes a record from the table
  Future<int> remove(Remove st) => _connection.execute(composeRemove(st));

  @override
  Future<void> alter(Alter statement) async {
    await _connection.execute(composeAlter(statement));
  }

  /// Creates the table
  Future<void> createTable(Create statement) async {
    await _connection.execute(composeCreate(statement));
  }

  /// Create the database
  Future<void> createDatabase(CreateDb st) async {
    await _connection.execute(composeCreateDb(st));
  }

  /// Drops tables from database
  Future<void> dropTable(Drop st) async {
    String stStr = composeDrop(st);
    await _connection.execute(stStr);
  }

  Future<void> dropDb(DropDb st) async {
    await _connection.execute(composeDropDb(st));
  }

  @override
  T parseValue<T>(dynamic v) {
    return v as T;
  }

  @override
  Future<void> updateMany(UpdateMany statement) {
    throw UnimplementedError('TODO need to be implemented');
  }

  /// Connects to the database
  static Future<PgConn> open(String databaseName,
      {String username,
      String password,
      String host: 'localhost',
      int port: 5432}) async {
    final connection = pg.PostgreSQLConnection(host, port, databaseName,
        username: username, password: password);
    await connection.open();
    return PgConn(connection);
  }

  Future<void> startTx() async {
    await _connection.execute("START TRANSACTION");
  }

  Future<void> commit() async {
    await _connection.execute("COMMIT");
  }

  Future<void> rollback({String savepoint}) async {
    await _connection
        .execute("ROLLBACK" + savepoint != null ? "TO $savepoint" : '');
  }
}
