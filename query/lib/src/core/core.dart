// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library query;

import 'dart:async';
import 'dart:collection';
import 'dart:core';
import 'dart:core' as core;

import 'package:jaguar_query/src/adapter/adapter.dart';
import 'package:jaguar_query/src/operators/operators.dart' as q;

part 'expression/and.dart';
part 'expression/condition.dart';
part 'expression/expressions.dart';
part 'expression/field.dart';
part 'expression/in_between.dart';
part 'expression/or.dart';
part 'operators/comparision.dart';
part 'statement/alter.dart';
part 'statement/create/column.dart';
part 'statement/create/create.dart';
part 'statement/create_db.dart';
part 'statement/drop.dart';
part 'statement/find/find.dart';
part 'statement/insert.dart';
part 'statement/insert_many.dart';
part 'statement/remove.dart';
part 'statement/statements.dart';
part 'statement/update.dart';
part 'statement/update_many.dart';
part 'table/table.dart';

/// Main DSL class to create SQL statements
class Sql {
  /// Creates a new [Find] statement
  static Find find(String table, {String alias}) =>
      new Find(table, alias: alias);

  /// Creates a new [Insert] statement
  static Insert insert(String table) => new Insert(table);

  /// Creates a new [InsertMany] statement
  static InsertMany insertMany(String table) => new InsertMany(table);

  /// Creates a new [Update] statement
  static Update update(String table, {Expression where}) =>
      new Update(table, where: where);

  /// Creates a new [UpdateMany] statement
  static UpdateMany updateMany(String table) => new UpdateMany(table);

  /// Creates a new [Delete] statement
  static Remove remove(String table) => new Remove(table);

  /// Returns a new [Create] statement
  static Create create(String table, {bool ifNotExists: false}) =>
      new Create(table, ifNotExists: ifNotExists);

  /// Returns a new [Drop] statement
  static Drop drop(String table, {bool onlyIfExists: false}) =>
      new Drop(table, onlyIfExists: onlyIfExists);

  /// Returns a new [CreateDb] statement
  static CreateDb createDb(String database) => new CreateDb(database);

  static DropDb dropDb(String database) => new DropDb(database);
}
