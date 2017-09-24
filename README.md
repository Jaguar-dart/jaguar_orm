# jaguar_orm

Source-generated ORM with relations (one-to-one, one-to-many, many-to-many), preloading, cascading, polymorphic relations, etc 

# Features

* Relationships
  * [One To One](https://github.com/jaguar-orm/one_to_one)  
  * [One To Many](https://github.com/jaguar-orm/one_to_many)  
  * [Many To Many](https://github.com/jaguar-orm/many_to_many)  
* Preloads
* Cascading
  * Cascaded inserts
  * Cascaded updates
  * Cascaded removals
* Migration
* Polymorphic relations
* Composite primary keys
* Composite foreign keys


# Gettings started

## Install source generator

**jaguar_orm_cli** provides **orm** CLI tool to generate ORM code.

```
pub global activate jaguar_orm_cli
```

## Project configuration

**orm** CLI tool reads project configuration from `orm.yaml` configuration file. The `orm` property in configuration file
must list the paths of all libraries that need ORM generation.

### Example orm.yaml file

```yaml
beans:
  - bin/main.dart
  - lib/models/user.dart
  - lib/models/book.dart
```

## Simple example

### Model

```dart
class User {
  @PrimaryKey()
  String id;

  String name;

  static const String tableName = '_user';

  String toString() => "User($id, $name)";
}
```

### Bean

A `Bean` performs database actions on behalf of the model. In this case, `UserBean` performs actions for `User` model.
Much of the `Bean`'s functionality will be source generated.

```dart
@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter) : super(adapter);
}
```

### Generating the Bean

Given the configuration and `GenBean` annotation, **orm** CLI can magically generate ORM methods for you. Here is the
command:

```bash
orm build
```

We will see, how we can use the generated ORM methods to perform basic CRUD operations on `User` table/model.

### Connecting to database

We will use PostgreSQL for this tutorial. `PgAdapter` is found in the package [**jaguar_query_postgresql**](https://github.com/Jaguar-dart/jaguar_query_postgresql).

```dart
PgAdapter _adapter =
    new PgAdapter('postgres://postgres:dart_jaguar@localhost/example');
await _adapter.connect();
```

### Creating instance of bean

`Bean`s internally use **jaguar_query**'s `Adapter` interface to talk to database. Lets create an instance of `UserBean`.

```dart
final userBean = new UserBean(_adapter);
```

### Dropping table

```dart
await userBean.drop();
```

### Creating table

```dart
await userBean.createTable();

```

### Inserting new record

```dart
await userBean.insert(new User()
    ..id = '1'
    ..name = 'teja');
```

### Fetching record by primary key

```dart
User user = await userBean.find('1');
```

### Fetching all records

```dart
List<User> users = await userBean.getAll();
```

### Updating a record

```dart
User user = await userBean.find('1');
user.name = 'teja hackborn';
await userBean.update(user);
```

### Remove by id

```dart
await userBean.remove('1');
```

### Remove all

```dart
await userBean.removeAll();
```

# One-To-One example

```dart
class User {
  @PrimaryKey()
  String id;

  String name;

  @HasOne(AddressBean)
  Address address;

  static const String tableName = '_user';

  String toString() => "User($id, $name, $address)";
}

class Address {
  @PrimaryKey()
  String id;

  @BelongsTo(UserBean)
  String userId;

  String street;

  static String tableName = 'address';

  String toString() => "Post($id, $userId, $street)";
}

@GenBean()
class UserBean extends Bean<User> with _UserBean {
  UserBean(Adapter adapter)
      : addressBean = new AddressBean(adapter),
        super(adapter);

  final AddressBean addressBean;

  Future createTable() {
    final st = Sql
        .create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('name', length: 50);
    return execCreateTable(st);
  }
}

@GenBean()
class AddressBean extends Bean<Address> with _AddressBean {
  AddressBean(Adapter adapter) : super(adapter);

  Future createTable() {
    final st = Sql
        .create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('street', length: 150)
        .addStr('user_id', length: 50, foreignTable: '_user', foreignCol: 'id');
    return execCreateTable(st);
  }
}

/// The adapter
PgAdapter _adapter =
    new PgAdapter('postgres://postgres:dart_jaguar@localhost/example');

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
    await userBean.insert(user, cascade: true);
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

  // Remove addresses belonging to a User
  await addressBean.removeByUser('2');

  exit(0);
}
```