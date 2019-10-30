// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_sqflite.src;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_sqflite/src/connection.dart';
import 'package:sqflite/sqflite.dart' as sqf;

class SqfliteAdapter extends Adapter<sqf.Database> {
  SqfConn _connection;

  final String path;
  final int version;

  Logger logger;

  SqfliteAdapter(this.path, {this.version, this.logger});

  /// Connects to the database
  Future<Connection> open() async {
    return _connection ??= await SqfConn.open(path, version: version, logger: logger);
  }

  /// Closes all connections to the database.
  Future<void> close() => connection.close();

  sqf.Database get connection => _connection.connection;

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
}
