library example.has_one;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'simple.jorm.dart';

class User {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 50)
  String name;

  @HasOne(AddressBean)
  Address address;

  User({this.id, this.name, this.address});

  String toString() => "User($id, $name, $address)";

  bool operator ==(final other) {
    if (other is User)
      return id == other.id && name == other.name && address == other.address;
    return false;
  }
}

class Address {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 150)
  String street;

  @BelongsTo(UserBean)
  String userId;

  Address({this.id, this.street, this.userId});

  String toString() => "Address($id, $userId, $street)";

  bool operator ==(final other) {
    if (other is Address)
      return id == other.id && street == other.street && userId == other.userId;
    return false;
  }
}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter)
      : addressBean = AddressBean(adapter),
        super(adapter);

  final AddressBean addressBean;

  String get tableName => 'oto_simple_user';
}

@GenBean()
class AddressBean extends Bean<Address> with _AddressBean {
  UserBean _userBean;
  UserBean get userBean => _userBean ??= UserBean(adapter);

  AddressBean(Adapter adapter) : super(adapter);

  String get tableName => 'oto_simple_address';
}
