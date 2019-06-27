library jaguar_orm.adapter;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'connection.dart';

export 'connection.dart';
export 'to_dialect.dart';

typedef Logger = void Function(String statement);

/// Adapter interface that must be implemented to support new databases
abstract class Adapter<ConnType> {
  Logger get logger;

  /// Opens a new connection to database
  Future<Connection> open();

  Future<T> run<T>(Future<T> Function(Connection<ConnType> conn) task,
      {Connection<ConnType> withConn}) async {
    if (withConn == null) {
      withConn = await open();
      try {
        return task(withConn);
      } catch (e) {
        await withConn.release();
        rethrow;
      }
    }

    return await task(withConn);
  }

  Future<T> transaction<T>(Future<T> Function(Connection<ConnType> conn) tx,
      {Connection<ConnType> withConn}) async {
    final task = (Connection<ConnType> conn) async {
      return conn.transaction(tx);
    };
    return run(task, withConn: withConn);
  }

  Future<dynamic> query(String sql, {Connection withConn}) {
    return run((conn) {
      return conn.query(sql);
    }, withConn: withConn);
  }

  Future<dynamic> exec(String sql, {Connection withConn}) {
    return run((conn) {
      return conn.exec(sql);
    }, withConn: withConn);
  }

  /// Returns a row found by executing [statement]
  Future<Map> findOne(Find statement, {Connection withConn}) {
    return run((conn) {
      return conn.findOne(statement);
    }, withConn: withConn);
  }

  /// Returns a list of rows found by executing [statement]
  Future<List<Map>> find(Find statement, {Connection withConn}) {
    return run((conn) {
      return conn.find(statement);
    }, withConn: withConn);
  }

  /// Executes the insert or update statement and returns the primary key of
  /// inserted row
  Future<T> upsert<T>(Upsert statement, {Connection withConn}) {
    return run((conn) {
      return conn.upsert<T>(statement);
    }, withConn: withConn);
  }

  /// Executes bulk insert or update statement
  Future<void> upsertMany<T>(UpsertMany statement, {Connection withConn}) {
    return run((conn) {
      return conn.upsertMany(statement);
    }, withConn: withConn);
  }

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<T> insert<T>(Insert statement, {Connection withConn}) {
    return run((conn) {
      return conn.insert(statement);
    }, withConn: withConn);
  }

  /// Executes the insert statement for many element
  Future<void> insertMany<T>(InsertMany statement, {Connection withConn}) {
    return run((conn) {
      return conn.insertMany(statement);
    }, withConn: withConn);
  }

  /// Updates the row and returns the number of rows updated
  Future<int> update(Update statement, {Connection withConn}) {
    return run((conn) {
      return conn.update(statement);
    }, withConn: withConn);
  }

  /// Updates many rows
  Future<void> updateMany(UpdateMany statement, {Connection withConn}) {
    return run((conn) {
      return conn.updateMany(statement);
    }, withConn: withConn);
  }

  /// Deletes the requested row
  Future<int> remove(Remove statement, {Connection withConn}) {
    return run((conn) {
      return conn.remove(statement);
    }, withConn: withConn);
  }

  Future<void> alter(Alter statement, {Connection withConn}) {
    return run((conn) {
      return conn.alter(statement);
    }, withConn: withConn);
  }

  /// Creates the table
  Future<void> createTable(Create statement, {Connection withConn}) {
    return run((conn) {
      return conn.createTable(statement);
    }, withConn: withConn);
  }

  /// Create the database
  Future<void> createDatabase(CreateDb statement, {Connection withConn}) {
    return run((conn) {
      return conn.createDatabase(statement);
    }, withConn: withConn);
  }

  /// Drops tables from database
  Future<void> dropTable(Drop st, {Connection withConn}) {
    return run((conn) {
      return conn.dropTable(st);
    }, withConn: withConn);
  }

  /// Drops tables from database
  Future<void> dropDb(DropDb st, {Connection withConn}) {
    return run((conn) {
      return conn.dropDb(st);
    }, withConn: withConn);
  }

  /// Parses values coming from database into Dart values
  T parseValue<T>(dynamic v);

  Future<Connection> beginTx({Connection withConn}) {
    return run((conn) {
      return conn.startTx();
    }, withConn: withConn);
  }
}

/// Convenience class to execute `Find` statement using [connection]
class FindExecutor<ConnType> {
  /// The adapter used to execute find statement
  final Connection<ConnType> connection;

  final Find _st;

  FindExecutor(this.connection, this._st);

  /// Returns a row found by executing [statement]
  Future<Map> one() => connection.findOne(_st);

  /// Returns a row found by executing [statement]
  Future<List<Map>> many() async => await connection.find(_st);

  /// Returns a row found by executing [statement]
  Future<T> oneTo<T>(T converter(Map v)) async {
    final Map map = await connection.findOne(_st);
    return converter(map);
  }

  /// Returns a row found by executing [statement]
  Future<List<T>> manyTo<T>(T converter(Map v)) async =>
      (await connection.find(_st)).map(converter).toList();
}
