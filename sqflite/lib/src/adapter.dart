// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_sqflite.src;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:sqflite/sqflite.dart' as sqf;
import 'package:jaguar_query_sqflite/composer.dart';

abstract class JaguarOrmException {}

class NoRecordFound implements JaguarOrmException {
  const NoRecordFound();

  String toString() => 'No record found!';
}

class SqfliteAdapter implements Adapter<sqf.Database> {
  sqf.Database _connection;

  final String path;
  final int version;

  SqfliteAdapter(this.path, {this.version});

  SqfliteAdapter.FromConnection(sqf.Database connection)
      : _connection = connection,
        path = connection.path,
        version = null;

  /// Connects to the database
  Future<void> connect() async {
    if (_connection == null) {
      _connection = await sqf.openDatabase(path, version: version);
    }
  }

  /// Closes all connections to the database.
  Future<void> close() => _connection.close();

  sqf.Database get connection => _connection;

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, dynamic>> stream = await _connection.rawQuery(stStr);

    if (stream.length == 0) {
      throw const NoRecordFound();
    }

    return stream.first;
  }

  // Finds many records in the table
  Future<Stream<Map>> find(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, dynamic>> stream = await _connection.rawQuery(stStr);
    return Stream.fromIterable(stream);
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    String strSt = composeInsert(st);
    return _connection.rawInsert(strSt) as Future<T>;
  }

  /// Updates a record in the table
  Future<int> update(Update st) {
    String strSt = composeUpdate(st);
    return _connection.rawUpdate(strSt);
  }

  /// Deletes a record from the table
  Future<int> remove(Remove st) {
    String strSt = composeRemove(st);
    return _connection.execute(strSt);
  }

  /// Creates the table
  Future<void> createTable(Create statement) async {
    String strSt = composeCreate(statement);
    await _connection.execute(strSt);
  }

  /// Create the database
  Future<void> createDatabase(CreateDb st) async {
    String strSt = composeCreateDb(st);
    await _connection.execute(strSt);
  }

  /// Drops tables from database
  Future<void> dropTable(Drop st) async {
    String strSt = composeDrop(st);
    await _connection.execute(strSt);
  }

  Future<void> dropDb(DropDb st) async {
    String strSt = composeDropDb(st);
    await _connection.execute(strSt);
  }
}
