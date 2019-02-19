// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.has_one;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../model/reflexive/one_to_one/simple.dart';

/// The adapter
final adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await adapter.connect();

  // Create beans
  final dirBean = DirectoryBean(adapter);

  // Drop old tables
  await dirBean.drop();

  // Create new tables
  await dirBean.createTable();

  // Cascaded One-To-One insert
  {
    final user = Directory(id: '1', name: 'etc')
      ..child = (Directory(id: '2', name: 'nginx'));
    await dirBean.insert(user, cascade: true);
  }

  // Fetch One-To-One preloaded
  {
    final user = await dirBean.find('1', preload: true);
    print(user);
  }

  // Manual One-To-One insert
  {
    var parent = Directory(id: '3', name: 'opt');
    await dirBean.insert(parent);

    parent = await dirBean.find('3');

    final child = Directory(id: '4', name: 'var');
    dirBean.associateDirectory(child, parent);
    await dirBean.insert(child);
  }

  // Manual One-To-One preload
  {
    final dir = await dirBean.find('3');
    print(dir);
    dir.child = await dirBean.findByDirectory(dir.id);
    print(dir);
  }

  // Preload many
  {
    final users = await dirBean.getAll();
    print(users);
    await dirBean.preloadAll(users);
    print(users);
  }

  // Cascaded One-To-One update
  {
    Directory dir = await dirBean.find('1', preload: true);
    dir.name = 'Etc';
    dir.child.name = 'Nginx';
    await dirBean.update(dir, cascade: true);
  }

  // Fetch One-To-One relationship preloaded
  {
    final user = await dirBean.find('1', preload: true);
    print(user);
  }

  // Cascaded removal of One-To-One relation
  await dirBean.remove('1', cascade: true);

  {
    final users = await dirBean.getAll();
    print(users);
  }

  await dirBean.removeByDirectory('3');

  {
    final users = await dirBean.getAll();
    print(users);
  }

  exit(0);
}
