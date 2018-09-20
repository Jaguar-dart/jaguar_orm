// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.has_one;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = new StrField('id');
  final name = new StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  User fromMap(Map map) {
    User model = new User();

    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50, isNullable: false);
    st.addStr(name.name, length: 50, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    var retId = await adapter.insert(insert);
    if (cascade) {
      User newModel;
      if (model.address != null) {
        newModel ??= await find(model.id);
        addressBean.associateUser(model.address, newModel);
        await addressBean.insert(model.address);
      }
    }
    return retId;
  }

  Future<void> insertMany(List<User> models, {bool cascade: false}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data =
          models.map((model) => toSetColumns(model)).toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<int> update(User model,
      {bool cascade: false, bool associate: false, Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    final ret = adapter.update(update);
    if (cascade) {
      User newModel;
      if (model.address != null) {
        if (associate) {
          newModel ??= await find(model.id);
          addressBean.associateUser(model.address, newModel);
        }
        await addressBean.update(model.address);
      }
    }
    return ret;
  }

  Future<void> updateMany(List<User> models, {bool cascade: false}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(toSetColumns(model).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<User> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final User model = await findOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final User newModel = await find(id);
      await addressBean.removeByUser(newModel.id);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<User> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<User> preload(User model, {bool cascade: false}) async {
    model.address = await addressBean.findByUser(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<User>> preloadAll(List<User> models,
      {bool cascade: false}) async {
    await OneToXHelper.preloadAll<User, Address>(
        models,
        (User model) => [model.id],
        addressBean.findByUserList,
        (Address model) => [model.userId],
        (User model, Address child) => model.address = child,
        cascade: cascade);
    return models;
  }

  AddressBean get addressBean;
}

abstract class _AddressBean implements Bean<Address> {
  final id = new StrField('id');
  final street = new StrField('street');
  final userId = new StrField('user_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        street.name: street,
        userId.name: userId,
      };
  Address fromMap(Map map) {
    Address model = new Address();

    model.id = adapter.parseValue(map['id']);
    model.street = adapter.parseValue(map['street']);
    model.userId = adapter.parseValue(map['user_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Address model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(street.set(model.street));
      ret.add(userId.set(model.userId));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(street.name)) ret.add(street.set(model.street));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50, isNullable: false);
    st.addStr(street.name, length: 150, isNullable: false);
    st.addStr(userId.name,
        foreignTable: userBean.tableName, foreignCol: 'id', isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Address model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Address> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<int> update(Address model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Address> models) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<Address> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Address> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Address> findByUser(String userId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.userId.eq(userId));
    return findOne(find);
  }

  Future<List<Address>> findByUserList(List<User> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (User model in models) {
      find.or(this.userId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByUser(String userId) async {
    final Remove rm = remover.where(this.userId.eq(userId));
    return await adapter.remove(rm);
  }

  void associateUser(Address child, User parent) {
    child.userId = parent.id;
  }

  UserBean get userBean;
}
