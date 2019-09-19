import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_sqflite/composer.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class SqfConn extends Connection<sqf.Database> {
  sqf.Database _connection;

  /// Connects to the database
  static Future<SqfConn> open(String path, {int version, Logger logger}) async {
    final connection = await sqf.openDatabase(path, version: version);
    return SqfConn(connection, logger: logger);
  }

  Logger logger;

  SqfConn(this._connection, {this.logger});

  /// Closes all connections to the database.
  @override
  Future<void> release() => _connection.close();

  @override
  sqf.Database get connection => _connection;

  @override
  Future<List<Map<String, Map<String, dynamic>>>> query(String sql) async {
    if (logger != null) logger(sql);
    return await _connection.rawQuery(sql);
  }

  @override
  Future<dynamic> exec(String sql) async {
    if (logger != null) logger(sql);
    var ret = await _connection.execute(sql);
    return ret;
  }

  /// Returns a row found by executing [statement]
  @override
  Future<Map> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, dynamic>> list = await connection.rawQuery(stStr);

    if (list.length == 0) return null;

    return list.first;
  }

  /// Returns a list of rows found by executing [statement]
  @override
  Future<List<Map>> find(Find st) {
    String stStr = composeFind(st);
    if (logger != null) logger(stStr);
    return connection.rawQuery(stStr);
  }

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  @override
  Future<T> insert<T>(Insert st) {
    String strSt = composeInsert(st);
    if (logger != null) logger(strSt);
    return connection.rawInsert(strSt) as Future<T>;
  }

  /// Executes the insert statement for many element
  @override
  Future<void> insertMany<T>(InsertMany st) async {
    String strSt = composeInsertMany(st);
    return exec(strSt);
  }

  /// Executes the insert or update statement and returns the primary key of
  /// inserted row
  @override
  Future<T> upsert<T>(Upsert st) {
    String strSt = composeUpsert(st);
    if (logger != null) logger(strSt);
    return connection.rawInsert(strSt) as Future<T>;
  }

  /// Executes bulk insert or update statement
  @override
  Future<void> upsertMany<T>(UpsertMany st) {
    List<String> strSt = composeUpsertMany(st);
    if (logger != null) logger(strSt.toString());
    final batch = connection.batch();
    for (var query in strSt) {
      batch.execute(query);
    }
    return batch.commit(noResult: true);
  }

  /// Updates a record in the table
  @override
  Future<int> update(Update st) {
    String strSt = composeUpdate(st);
    if (logger != null) logger(strSt);
    return connection.rawUpdate(strSt);
  }

  /// Deletes a record from the table
  @override
  Future<int> remove(Remove st) {
    String sql = composeRemove(st);
    if (logger != null) logger(sql);
    return connection.rawDelete(sql);
  }

  @override
  Future<void> alter(Alter statement) async {
    await exec(composeAlter(statement));
  }

  /// Creates the table
  @override
  Future<void> createTable(Create statement) async {
    await exec(composeCreate(statement));
  }

  /// Create the database
  @override
  Future<void> createDatabase(CreateDb st) async {
    await exec(composeCreateDb(st));
  }

  /// Drops tables from database
  @override
  Future<void> dropTable(Drop st) async {
    String stStr = composeDrop(st);
    await exec(stStr);
  }

  /// Drops tables from database
  @override
  Future<void> dropDb(DropDb st) async {
    String strSt = composeDropDb(st);
    await exec(strSt);
  }

  /// Parses values coming from database into Dart values
  @override
  T parseValue<T>(dynamic v) {
    if (T == String) {
      return v;
    } else if (T == int) {
      return v?.toInt();
    } else if (T == double) {
      return v?.toDouble();
    } else if (T == num) {
      return v;
    } else if (T == DateTime) {
      if (v == null) return null;
      if (v is String) return DateTime.parse(v) as T;
      if (v == int) return DateTime.fromMillisecondsSinceEpoch(v * 1000) as T;
      return null;
    } else if (T == bool) {
      if (v == null) return null;
      return (v == 0 ? false : true) as T;
    } else {
      return v as T;
    }
  }

  /// Updates many rows
  @override
  Future<void> updateMany(UpdateMany st) {
    List<String> strSt = composeUpdateMany(st);
    if (logger != null) logger(strSt.toString());
    final batch = connection.batch();
    for (var query in strSt) {
      batch.execute(query);
    }
    return batch.commit(noResult: true);
  }

  @override
  Future<void> startTx() async {
    await exec("BEGIN TRANSACTION");
  }

  @override
  Future<void> commit() async {
    await exec("COMMIT");
  }

  @override
  Future<void> rollback({String savepoint}) async {
    await exec("ROLLBACK");
  }
}
