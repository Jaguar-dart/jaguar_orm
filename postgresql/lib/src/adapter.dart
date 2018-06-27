// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_postgresql.src;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar_query_postgresql/composer.dart';

abstract class JaguarOrmException {}

class NoRecordFound implements JaguarOrmException {
  const NoRecordFound();

  String toString() => 'No record found!';
}

class PgAdapter implements Adapter<pg.Connection> {
  pg.Connection _connection;

  String _connectionString;

  PgAdapter(String connectionString) {
    _connectionString = connectionString;
  }

  PgAdapter.FromConnection(this._connection);

  /// Connects to the database
  Future<Null> connect() async {
    if (_connection != null) return;
    this._connection = await pg.connect(this._connectionString);
  }

  /// Closes all connections to the database.
  Future<Null> close() async {
    _connection.close();
  }

  pg.Connection get connection => _connection;

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    Stream<pg.Row> stream = await _connection.query(composeFind(st));

    pg.Row rowFound;
    await for (pg.Row row in stream) {
      rowFound = row;
      break;
    }

    if (rowFound == null) {
      throw const NoRecordFound();
    }

    return rowFound.toMap();
  }

  // Finds many records in the table
  Future<Stream<Map>> find(Find st) async {
    // Convert [pg.Row] to [Map]
    final StreamTransformer transformer = new StreamTransformer.fromHandlers(
        handleData: (pg.Row row, EventSink<dynamic> sink) {
      sink.add(row.toMap());
    });

    Stream<pg.Row> stream = await _connection.query(composeFind(st));
    return stream.transform(transformer);
  }

  /// Inserts a record into the table
  Future<dynamic> insert(Insert st) async {
    var result = await _connection.query(composeInsert(st)).toList();

    if (result.length > 0) {
      // if we have any results, here will be returned new primary key
      // of the inserted row
      return result[0][0];
    }

    // if model does'nt have primary key we simply return 0
    return null;
  }

  /// Updates a record in the table
  Future<int> update(Update st) => _connection.execute(composeUpdate(st));

  /// Deletes a record from the table
  Future<int> remove(Remove st) => _connection.execute(composeRemove(st));

  /// Creates the table
  Future<Null> createTable(Create statement) async {
    await _connection.execute(composeCreate(statement));
  }

  /// Create the database
  Future<Null> createDatabase(CreateDb st) async {
    await _connection.execute(composeCreateDb(st));
  }

  /// Drops tables from database
  Future<Null> dropTable(Drop st) async {
    await _connection.execute(composeDrop(st));
  }

  Future<Null> dropDb(DropDb st) async {
    await _connection.execute(composeDropDb(st));
  }
}
