// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.basic;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../model/basic/simple.dart';

/// The adapter
final _adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await _adapter.connect();

  // Create beans
  final userBean = UserBean(_adapter);

  // Drop old tables
  await userBean.drop();

  // Create new tables
  await userBean.createTable();

  // Insert a new record
  int id = await userBean.insert(User(name: 'teja', age: 29));
  await userBean.insert(User(name: 'kleak', age: 24));
  await userBean.insert(User(name: 'lejard', age: 25));

  // Fetching record by primary key
  User user = await userBean.find(id);
  print(user);

  // Updating a record
  user.name = 'teja hackborn';
  await userBean.update(user);

  // Fetching all records
  List<User> users = await userBean.getAll();
  print(users);

  // Remove
  await userBean.remove(id);

  users = await userBean.getAll();
  print(users);

  // Remove all
  await userBean.removeAll();

  users = await userBean.getAll();
  print(users);

  exit(0);
}
