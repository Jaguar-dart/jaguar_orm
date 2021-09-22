// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_sqflite.src;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_sqflite/composer.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class SqfliteAdapter implements Adapter<sqf.Database> {
  sqf.Database? _connection;

  final String? path;
  final int? version;

  SqfliteAdapter(this.path, {this.version});

  @Deprecated("Use fromConnection instead")
  SqfliteAdapter.FromConnection(sqf.Database connection)
      : _connection = connection,
        path = null,
        version = null;

  SqfliteAdapter.fromConnection(sqf.Database connection)
      : _connection = connection,
        path = null,
        version = null;

  /// Connects to the database
  Future<void> connect() async {
    if (_connection == null) {
      _connection = await sqf.openDatabase(path!, version: version);
    }
  }

  /// Closes all connections to the database.
  Future<void> close() => connection.close();

  sqf.Database get connection => _connection!;

  /// Finds one record in the table
  Future<Map<String, dynamic>?> findOne(Find st) async {
    String stStr = composeFind(st);
    List<Map<String, dynamic>> list = await connection.rawQuery(stStr);

    if (list.length == 0) return null;

    return list.first;
  }

  // Finds many records in the table
  Future<List<Map<String, dynamic>>> find(Find st) async {
    String stStr = composeFind(st);
    return connection.rawQuery(stStr);
  }

  /// Inserts a record into the table
  Future<T> insert<T>(Insert st) async {
    String strSt = composeInsert(st);
    return connection.rawInsert(strSt) as Future<T>;
  }

  /// Inserts or update a record into the table
  Future<T> upsert<T>(Upsert st) async {
    String strSt = composeUpsert(st);
    return connection.rawInsert(strSt) as Future<T>;
  }

  /// Inserts or update records into the table
  Future<List<Object?>> upsertMany<T>(UpsertMany st) async {
    List<String> strSt = composeUpsertMany(st);
    final batch = connection.batch();
    for (var query in strSt) {
      batch.execute(query);
    }
    return batch.commit(noResult: true);
  }

  /// Inserts many records into the table
  Future<void> insertMany<T>(InsertMany st) {
    String strSt = composeInsertMany(st);
    return connection.execute(strSt);
  }

  /// Updates a record in the table
  Future<int> update(Update st) {
    String strSt = composeUpdate(st);
    return connection.rawUpdate(strSt);
  }

  /// Updates a record in the table
  Future<void> updateMany(UpdateMany st) {
    List<String> strSt = composeUpdateMany(st);
    final batch = connection.batch();
    for (var query in strSt) {
      batch.execute(query);
    }
    return batch.commit(noResult: true);
  }

  /// Deletes a record from the table
  Future<int> remove(Remove st) {
    String strSt = composeRemove(st);
    return connection.rawDelete(strSt);
  }

  /// Creates the table
  Future<void> createTable(Create statement) async {
    String strSt = composeCreate(statement);
    await connection.execute(strSt);
  }

  /// Create the database
  Future<void> createDatabase(CreateDb st) async {
    String strSt = composeCreateDb(st);
    await connection.execute(strSt);
  }

  /// Drops tables from database
  Future<void> dropTable(Drop st) async {
    String strSt = composeDrop(st);
    await connection.execute(strSt);
  }

  Future<void> dropDb(DropDb st) async {
    String strSt = composeDropDb(st);
    await connection.execute(strSt);
  }

  @override
  Future<void> alter(Alter st) async {
    String strSt = composeAlter(st);
    await connection.execute(strSt);
  }

  bool _typesEqual<T1, T2>() => T1 == T2;

  T parseValue<T>(dynamic v) {
    if (_typesEqual<T, String>()) {
      return v ?? '';
    } else if (_typesEqual<T, String?>()) {
      return v;
    } else if (_typesEqual<T, int>()) {
      return (v ?? 0)?.toInt();
    } else if (_typesEqual<T, int?>()) {
      return v?.toInt();
    } else if (_typesEqual<T, double>()) {
      return (v ?? 0.0)?.toDouble();
    } else if (_typesEqual<T, double?>()) {
      return v?.toDouble();
    } else if (_typesEqual<T, num>() || _typesEqual<T, num?>()) {
      return v;
    } else if (_typesEqual<T, DateTime>() || _typesEqual<T, DateTime?>()) {
      if (v == null) {
        if (_typesEqual<T, DateTime>()) {
          return DateTime.fromMicrosecondsSinceEpoch(0) as T;
        }
        return null as T;
      }
      if (v is String) return DateTime.parse(v) as T;
      if (v == int) return DateTime.fromMillisecondsSinceEpoch(v * 1000) as T;
      throw new Exception(
          "Can parse date, required int or String but found: ${v.dartType} $v");
    } else if (_typesEqual<T, bool>()) {
      if (v == null) return false as T;
      return (v == 0 ? false : true) as T;
    } else if (_typesEqual<T, bool?>()) {
      if (v == null) return null as T;
      return (v == 0 ? false : true) as T;
    } else {
      throw new Exception("Invalid type $T!");
    }
  }
}
