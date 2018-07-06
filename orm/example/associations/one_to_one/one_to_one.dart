// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet

library example.has_one;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_orm/src/relations/relations.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'one_to_one.jorm.dart';

class User {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 50)
  String name;

  @HasOne(AddressBean)
  Address address;

  static const String tableName = '_user';

  String toString() => "User($id, $name, $address)";
}

class Address {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 150)
  String street;

  @BelongsTo(UserBean)
  String userId;

  static String tableName = 'address';

  String toString() => "Address($id, $userId, $street)";
}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter)
      : addressBean = new AddressBean(adapter),
        super(adapter);

  final AddressBean addressBean;
}

@GenBean()
class AddressBean extends Bean<Address> with _AddressBean {
  AddressBean(Adapter adapter) : super(adapter);
}

/// The adapter
final PgAdapter _adapter =
    new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await _adapter.connect();

  // Create beans
  final userBean = new UserBean(_adapter);
  final addressBean = new AddressBean(_adapter);

  // Drop old tables
  await addressBean.drop();
  await userBean.drop();

  // Create new tables
  await userBean.createTable();
  await addressBean.createTable();

  // Cascaded One-To-One insert
  {
    final user = new User()
      ..id = '1'
      ..name = 'Teja'
      ..address = (new Address()
        ..id = '1'
        ..street = 'Stockholm');
    var id = await userBean.insert(user, cascade: true);
    print(id);
  }

  // Fetch One-To-One preloaded
  {
    final user = await userBean.find('1', preload: true);
    print(user);
  }

  // Manual One-To-One insert
  {
    User user = new User()
      ..id = '2'
      ..name = 'Kleak';
    await userBean.insert(user, cascade: true);

    user = await userBean.find('2');

    final address = new Address()
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
  await userBean.remove('1', true);

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
