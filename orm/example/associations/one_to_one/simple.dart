// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.has_one;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../model/associations/one_to_one/simple.dart';

/// The adapter
final adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await adapter.connect();

  // Create beans
  final userBean = UserBean(adapter);
  final addressBean = AddressBean(adapter);

  // Drop old tables
  await addressBean.drop();
  await userBean.drop();

  // Create new tables
  await userBean.createTable();
  await addressBean.createTable();

  // Cascaded One-To-One insert
  {
    final user = User()
      ..id = '1'
      ..name = 'Teja'
      ..address = (Address()
        ..id = '1'
        ..street = 'Stockholm');
    await userBean.insert(user, cascade: true);
  }

  // Fetch One-To-One preloaded
  {
    final user = await userBean.find('1', preload: true);
    print(user);
  }

  // Manual One-To-One insert
  {
    User user = User()
      ..id = '2'
      ..name = 'Kleak';
    await userBean.insert(user, cascade: true);

    user = await userBean.find('2');

    final address = Address()
      ..id = '2'
      ..street = 'Stockholm';
    addressBean.associateUser(address, user);
    await addressBean.insert(address);
  }

  // Manual One-To-One preload
  {
    final user = await userBean.find('2');
    print(user);
    user.address = await addressBean.findByUser(user.id);
    print(user);
  }

  // Preload many
  {
    final users = await userBean.getAll();
    print(users);
    await userBean.preloadAll(users);
    print(users);
  }

  // Cascaded One-To-One update
  {
    User user = await userBean.find('1', preload: true);
    user.name = 'Teja Hackborn';
    user.address.street = 'Stockholm, Sweden';
    await userBean.update(user, cascade: true);
  }

  // Fetch One-To-One relationship preloaded
  {
    final user = await userBean.find('1', preload: true);
    print(user);
  }

  // Cascaded removal of One-To-One relation
  await userBean.remove('1', cascade: true);

  {
    final users = await userBean.getAll();
    print(users);
    final addresses = await addressBean.getAll();
    print(addresses);
  }

  // Remove addresses belonging to a User
  await addressBean.removeByUser('2');

  exit(0);
}
