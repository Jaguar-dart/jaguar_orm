// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.has_one;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = StrField('id');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  User fromMap(Map map) {
    User model = User();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
    }

    return ret;
  }

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      Str(length: 50),
      isPrimary: true,
    );
    st.addByType(
      name.name,
      Str(length: 50),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(User model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      User newModel;
      if (model.address != null) {
        newModel ??= await find(model.id, withConn: withConn);
        addressBean.associateUser(model.address, newModel);
        await addressBean.insert(model.address,
            cascade: cascade, withConn: withConn);
      }
    }
    return retId;
  }

  Future<void> insertMany(List<User> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade, withConn: withConn));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = insertser.addAll(data);
      await adapter.insertMany(insert, withConn: withConn);
      return;
    }
  }

  Future<dynamic> upsert(User model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      User newModel;
      if (model.address != null) {
        newModel ??= await find(model.id, withConn: withConn);
        addressBean.associateUser(model.address, newModel);
        await addressBean.upsert(model.address,
            cascade: cascade, withConn: withConn);
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<User> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade, withConn: withConn));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upsertser.addAll(data);
      await adapter.upsertMany(upsert, withConn: withConn);
      return;
    }
  }

  Future<int> update(User model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Update update = updater.where(this.id.eq(model.id)).setMany(
        toSetColumns(model,
            only: only, onlyNonNull: onlyNonNull, update: true));
    final ret = adapter.update(update, withConn: withConn);
    if (cascade) {
      User newModel;
      if (model.address != null) {
        if (associate) {
          newModel ??= await find(model.id, withConn: withConn);
          addressBean.associateUser(model.address, newModel);
        }
        await addressBean.update(model.address,
            cascade: cascade, associate: associate, withConn: withConn);
      }
    }
    return ret;
  }

  Future<void> updateMany(List<User> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade, withConn: withConn));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(toSetColumns(model,
                only: only, onlyNonNull: onlyNonNull, update: true)
            .toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updateser.addAll(data, where);
      await adapter.updateMany(update, withConn: withConn);
      return;
    }
  }

  Future<User> find(String id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    final User model = await findOne(find, withConn: withConn);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade, withConn: withConn);
    }
    return model;
  }

  Future<int> remove(String id,
      {bool cascade = false, Connection withConn}) async {
    if (cascade) {
      final User newModel = await find(id, withConn: withConn);
      if (newModel != null) {
        await addressBean.removeByUser(newModel.id, withConn: withConn);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<User> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<User> preload(User model,
      {bool cascade = false, Connection withConn}) async {
    model.address = await addressBean.findByUser(model.id,
        preload: cascade, cascade: cascade, withConn: withConn);
    return model;
  }

  Future<List<User>> preloadAll(List<User> models,
      {bool cascade = false, Connection withConn}) async {
    await OneToXHelper.preloadAll<User, Address>(
        models,
        (User model) => [model.id],
        addressBean.findByUserList,
        (Address model) => [model.userId],
        (User model, Address child) => model.address = child,
        cascade: cascade,
        withConn: withConn);
    return models;
  }

  AddressBean get addressBean => beanRepo[AddressBean];
  BeanRepo get beanRepo;
}

abstract class _AddressBean implements Bean<Address> {
  final id = StrField('id');
  final street = StrField('street');
  final userId = StrField('user_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        street.name: street,
        userId.name: userId,
      };
  Address fromMap(Map map) {
    Address model = Address();
    model.id = adapter.parseValue(map['id']);
    model.street = adapter.parseValue(map['street']);
    model.userId = adapter.parseValue(map['user_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Address model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(street.set(model.street));
      ret.add(userId.set(model.userId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(street.name)) ret.add(street.set(model.street));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.street != null) {
        ret.add(street.set(model.street));
      }
      if (model.userId != null) {
        ret.add(userId.set(model.userId));
      }
    }

    return ret;
  }

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      Str(length: 50),
      isPrimary: true,
    );
    st.addByType(
      street.name,
      Str(length: 150),
    );
    st.addByType(
      userId.name,
      Str(),
      foreign: References(userBean.tableName, "id"),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(Address model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert, withConn: withConn);
  }

  Future<void> insertMany(List<Address> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = insertser.addAll(data);
    await adapter.insertMany(insert, withConn: withConn);
    return;
  }

  Future<dynamic> upsert(Address model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert, withConn: withConn);
  }

  Future<void> upsertMany(List<Address> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upsertser.addAll(data);
    await adapter.upsertMany(upsert, withConn: withConn);
    return;
  }

  Future<int> update(Address model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Update update = updater.where(this.id.eq(model.id)).setMany(
        toSetColumns(model,
            only: only, onlyNonNull: onlyNonNull, update: true));
    return adapter.update(update, withConn: withConn);
  }

  Future<void> updateMany(List<Address> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model,
              only: only, onlyNonNull: onlyNonNull, update: true)
          .toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updateser.addAll(data, where);
    await adapter.updateMany(update, withConn: withConn);
    return;
  }

  Future<Address> find(String id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find, withConn: withConn);
  }

  Future<int> remove(String id, {Connection withConn}) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<Address> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<Address> findByUser(String userId,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.userId.eq(userId));
    return findOne(find, withConn: withConn);
  }

  Future<List<Address>> findByUserList(List<User> models,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (User model in models) {
      find.or(this.userId.eq(model.id));
    }
    return findMany(find, withConn: withConn);
  }

  Future<int> removeByUser(String userId, {Connection withConn}) async {
    final Remove rm = remover.where(this.userId.eq(userId));
    return await adapter.remove(rm, withConn: withConn);
  }

  void associateUser(Address child, User parent) {
    child.userId = parent.id;
  }

  Future<User> fetchUser(Address model, {Connection withConn}) async {
    return userBean.findOneWhere(userBean.id.eq(model.userId),
        withConn: withConn);
  }

  UserBean get userBean => beanRepo[UserBean];
  BeanRepo get beanRepo;
}
