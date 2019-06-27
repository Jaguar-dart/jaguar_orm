// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library jaguar_query_postgresql.src;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:postgres/postgres.dart' as pg;

import 'connection.dart';

export 'connection.dart';

class PgAdapter extends Adapter<pg.PostgreSQLConnection> {
  final String host;

  final int port;

  final String databaseName;
  final String username;
  final String password;

  PgAdapter(this.databaseName,
      {this.username, this.password, this.host: 'localhost', this.port: 5432});

  /// Connects to the database
  Future<Connection> open() async {
    return PgConn.open(databaseName,
        host: host, port: port, username: username, password: password);
  }

  @override
  T parseValue<T>(dynamic v) {
    return v as T;
  }
}
