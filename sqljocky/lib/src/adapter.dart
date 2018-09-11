// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_orm_sqljocky.src;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_sqljocky/composer.dart';
import 'package:sqljocky5/sqljocky.dart' as sj;

class MysqlAdapter implements Adapter<sj.MySqlConnection> {
  sj.MySqlConnection _connection;

  final String host;

  final int port;

  final String databaseName;
  final String username;
  final String password;

  MysqlAdapter(this.databaseName,
      {this.username, this.password, this.host: 'localhost', this.port: 3306});

  MysqlAdapter.FromConnection(sj.MySqlConnection connection)
      : _connection = connection,
        host = null,
        port = null,
        databaseName = null,
        username = null,
        password = null;

  /// Connects to the database
  Future<void> connect() async {
    if (_connection == null) {
      sj.ConnectionSettings connSettings = sj.ConnectionSettings(
          host: host,
          port: port,
          db: databaseName,
          user: username,
          password: password);
      _connection = await sj.MySqlConnection.connect(connSettings);
    }
    //if (_connection.isClosed) await connection.open();
  }

  /// Closes all connections to the database.
  Future<void> close() => _connection.close();

  sj.MySqlConnection get connection => _connection;

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    String stStr = composeFind(st);
    sj.Results results = await _connection.execute(stStr);

    if (results.isEmpty) return null;

    List resList = results.toList();
    Map map = {};
    for (int i = 0; i < resList[0].length; i++) {
      Object value = resList[0][i];
      map[results.fields[i].name] = value;
    }
    return map;
  }

  // Finds many records in the table
  Future<List<Map>> find(Find st) async {
    String stStr = composeFind(st);
    sj.Results results = await _connection.execute(stStr);

    return results.map((v) => v.first.first).toList();
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    String strSt = composeInsert(st);
    sj.Results ret = await _connection.execute(strSt);
    if (ret.isEmpty || ret.first.isEmpty) return null;
    return ret.first.first;
  }

  @override
  Future<void> insertMany<T>(InsertMany statement) {
    throw new UnimplementedError('InsertMany is not implemented yet!');
  }

  /// Updates a record in the table
  Future<int> update(Update st) async {
    sj.Results results = await _connection.execute(composeUpdate(st));
    return results.affectedRows;
  }

  /// Deletes a record from the table
  Future<int> remove(Remove st) async {
    sj.Results results = await _connection.execute(composeRemove(st));
    return results.affectedRows;
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
      throw new Exception("Invalid type $T!");
    }
  }

  @override
  Future<void> updateMany(UpdateMany statement) {
    throw UnimplementedError('TODO need to be implemented');
  }
}
