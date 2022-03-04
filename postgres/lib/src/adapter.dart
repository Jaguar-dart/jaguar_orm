// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_postgresql.src;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';
import 'package:postgres/postgres.dart' as pg;

class PgAdapter implements Adapter<pg.PostgreSQLConnection?> {
  pg.PostgreSQLConnection? _connection;

  final String host;

  final int port;

  final String databaseName;
  final String? username;
  final String? password;

  PgAdapter(this.databaseName,
      {this.username, this.password, this.host: 'localhost', this.port: 5432});

  PgAdapter.FromConnection(pg.PostgreSQLConnection connection)
      : _connection = connection,
        host = connection.host,
        port = connection.port,
        databaseName = connection.databaseName,
        username = connection.username,
        password = connection.password;

  /// Connects to the database
  Future<void> connect() async {
    if (_connection == null)
      _connection = new pg.PostgreSQLConnection(host, port, databaseName,
          username: username, password: password);
    if (_connection!.isClosed) await connection!.open();
  }

  /// Closes all connections to the database.
  Future<void> close() => _connection!.close();

  pg.PostgreSQLConnection? get connection => _connection;

  /// Finds one record in the table
  Future<Map<String, dynamic>?> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> rows =
        await _connection!.mappedResultsQuery(stStr);

    if (rows.isEmpty) return null;

    Map<String, Map<String, dynamic>> row = rows.first;

    if (row.length == 0) return {};

    if (row.length == 1) return rows.first.values.first;

    final ret = <String, dynamic>{};
    for (Map<String, dynamic> table in row.values) ret.addAll(table);
    return ret;
  }

  // Finds many records in the table
  Future<List<Map<String, dynamic>>> find(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> list =
        await _connection!.mappedResultsQuery(stStr);

    return list.map((v) => v.values.first).toList();
  }

  /// Inserts a record into the table
  Future<T?> insert<T>(Insert st) async {
    String strSt = composeInsert(st);
    var ret = await _connection!.query(strSt);
    if (ret.isEmpty || ret.first.isEmpty) return null;
    return ret.first.first;
  }

  @override
  Future<void> insertMany(InsertMany statement) {
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
  Future<int> update(Update st) => _connection!.execute(composeUpdate(st));

  /// Deletes a record from the table
  Future<int> remove(Remove st) => _connection!.execute(composeRemove(st));

  @override
  Future<void> alter(Alter statement) async {
    await _connection!.execute(composeAlter(statement));
  }

  /// Creates the table
  Future<void> createTable(Create statement) async {
    await _connection!.execute(composeCreate(statement));
  }

  /// Create the database
  Future<void> createDatabase(CreateDb st) async {
    await _connection!.execute(composeCreateDb(st));
  }

  /// Drops tables from database
  Future<void> dropTable(Drop st) async {
    String stStr = composeDrop(st);
    await _connection!.execute(stStr);
  }

  Future<void> dropDb(DropDb st) async {
    await _connection!.execute(composeDropDb(st));
  }

  @override
  T parseValue<T>(dynamic v) {
    return v as T;
  }

  @override
  Future<void> updateMany(UpdateMany statement) {
    throw UnimplementedError('TODO need to be implemented');
  }
}
