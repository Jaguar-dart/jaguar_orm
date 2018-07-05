// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_orm_sqljocky.src;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:sqljocky5/sqljocky.dart' as sj;
import 'package:sqljocky5/src/query/standard_data_packet.dart' as sj;
import 'dart:async';

import 'package:jaguar_query_sqljocky/src/compose/compose.dart';
import 'package:sqljocky5/src/results/results_impl.dart' as sj;

abstract class JaguarOrmException {}

class NoRecordFound implements JaguarOrmException {
  const NoRecordFound();

  String toString() => 'No record found!';
}

class SqlJockyAdapter implements Adapter<sj.ConnectionPool> {
  sj.ConnectionPool _connection;

  final String host, username, password, databaseName;
  final int port;

  SqlJockyAdapter(this.databaseName,
      {this.username, this.password, this.host: 'localhost', this.port: 3306});

  SqlJockyAdapter.FromConnection(this._connection)
      : host = null,
        username = null,
        password = null,
        databaseName = null,
        port = null;

  /// Connects to the database
  Future<Null> connect() async {
    if (_connection != null) return;
    _connection = new sj.ConnectionPool(
        host: host,
        port: port,
        user: username,
        password: password,
        db: databaseName,
        max: 5);
  }

  /// Closes all connections to the database.
  Future<Null> close() async {
    _connection.closeConnectionsWhenNotInUse();
  }

  sj.ConnectionPool get connection => _connection;

  /// Finds one record in the table
  Future<Map> findOne(Find st) async {
    sj.Results stream = await _connection.query(composeFind(st));

    sj.StandardDataPacket rowFound;
    await for (sj.StandardDataPacket row in stream) {
      rowFound = row;
      break;
    }

    if (rowFound == null) {
      throw const NoRecordFound();
    }

    return rowFound.fields;
  }

  // Finds many records in the table
  Future<Stream<Map>> find(Find st) async {
    final controller = new StreamController<Map>();

    final sj.ResultsImpl stream = (await _connection.query(composeFind(st)));
    StreamSubscription<sj.Row> sub;
    sub = stream.listen((sj.Row row) {
      controller.add(row.fields);
    }, onDone: () async {
      await sub.cancel();
      await controller.close();
    }, cancelOnError: true);

    return controller.stream;
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    sj.Results result = await _connection.query(composeInsert(st));
    return result.insertId as T;
  }

  /// Updates a record in the table
  Future<int> update(Update st) async {
    final sj.Results res = await _connection.query(composeUpdate(st));
    return res.affectedRows;
  }

  /// Deletes a record from the table
  Future<int> remove(Remove st) async {
    final sj.Results res = await _connection.query(composeDelete(st));
    return res.affectedRows;
  }

  /// Creates the table
  Future<Null> createTable(Create st) async {
    await _connection.query(composeCreate(st));
  }

  /// Create the database
  Future<Null> createDatabase(CreateDb st) async {
    await _connection.query(composeCreateDb(st));
  }

  /// Drops tables from database
  Future<Null> dropTable(Drop st) async {
    await _connection.query(composeDrop(st));
  }

  @override
  T parseValue<T>(dynamic v) {
    return v as T;
  }
}
