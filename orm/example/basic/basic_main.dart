// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.basic;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'basic_main.jorm.dart';

class User {
  @PrimaryKey()
  String id;

  String name;

  static const String tableName = 'usr';

  String toString() => "User($id, $name)";
}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter) : super(adapter);
}

/// The adapter
final PgAdapter _adapter =
    new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await _adapter.connect();

  // Create beans
  final userBean = new UserBean(_adapter);

  // Drop old tables
  await userBean.drop();

  // Create new tables
  await userBean.createTable();

  // Insert a new record
  await userBean.insert(new User()
    ..id = '1'
    ..name = 'teja');
  await userBean.insert(new User()
    ..id = '2'
    ..name = 'kleak');
  await userBean.insert(new User()
    ..id = '3'
    ..name = 'lejard');

  // Fetching record by primary key
  User user = await userBean.find('1');
  print(user);

  // Updating a record
  user.name = 'teja hackborn';
  await userBean.update(user);

  // Fetching all records
  List<User> users = await userBean.getAll();
  print(users);

  // Remove
  await userBean.remove('1');

  users = await userBean.getAll();
  print(users);

  // Remove all
  await userBean.removeAll();

  users = await userBean.getAll();
  print(users);

  exit(0);
}
