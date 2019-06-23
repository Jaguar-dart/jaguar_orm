library example.has_one;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'references.jorm.dart';

class User {
  @primaryKey
  @auto
  int id;

  @Str(length: 50)
  String name;

  @ignoreColumn
  Address address;

  User({this.id, this.name, this.address});

  String toString() => "User($id, $name, $address)";

  bool operator ==(final other) {
    if (other is User)
      return id == other.id && name == other.name && address == other.address;
    return false;
  }

  @override
  int get hashCode => super.hashCode;
}

class Address {
  @primaryKey
  @auto
  int id;

  @Str(length: 150)
  String street;

  @References('oto_simple_user', 'id')
  int userId;

  @References('oto_simple_user', 'name')
  String userName;

  Address({this.id, this.street, this.userId});

  String toString() => "Address($id, $userId, $street)";

  bool operator ==(final other) {
    if (other is Address)
      return id == other.id && street == other.street && userId == other.userId;
    return false;
  }

  @override
  int get hashCode => super.hashCode;
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
