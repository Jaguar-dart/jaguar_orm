// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_postgresql.src;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:postgres/postgres.dart' as pg;
import 'package:jaguar_query_postgres/composer.dart';

abstract class JaguarOrmException {}

class NoRecordFound implements JaguarOrmException {
  const NoRecordFound();

  String toString() => 'No record found!';
}

class PgAdapter implements Adapter<pg.PostgreSQLConnection> {
  pg.PostgreSQLConnection _connection;

  final String host;

  final int port;

  final String databaseName;
  final String username;
  final String password;

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
    if (_connection.isClosed) await connection.open();
  }

  /// Closes all connections to the database.
  Future<void> close() => _connection.close();

  pg.PostgreSQLConnection get connection => _connection;

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> stream =
        await _connection.mappedResultsQuery(stStr);

    if (stream.length == 0) {
      throw const NoRecordFound();
    }

    return stream.first.values.first;
  }

  // Finds many records in the table
  Future<Stream<Map>> find(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, Map<String, dynamic>>> stream =
        await _connection.mappedResultsQuery(stStr);

    return new Stream.fromIterable(stream.map((v) => v.values.first).toList());
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    var ret = await _connection.query(composeInsert(st));
    if (ret.isEmpty || ret.first.isEmpty) return null;
    return ret.first.first;
  }

  /// Updates a record in the table
  Future<int> update(Update st) => _connection.execute(composeUpdate(st));

  /// Deletes a record from the table
  Future<int> remove(Remove st) => _connection.execute(composeRemove(st));

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
    await _connection.execute(composeDrop(st));
  }

  Future<void> dropDb(DropDb st) async {
    await _connection.execute(composeDropDb(st));
  }
}
