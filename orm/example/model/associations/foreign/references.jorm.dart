// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.has_one;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = IntField('id');
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
      if (!update && model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
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
      auto,
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
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      User newModel;
    }
    return retId;
  }

  Future<void> insertMany(List<User> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = insertser.addAll(data);
    await adapter.insertMany(insert, withConn: withConn);
    return;
  }

  Future<dynamic> upsert(User model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      User newModel;
    }
    return retId;
  }

  Future<void> upsertMany(List<User> models,
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

  Future<int> update(User model,
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

  Future<void> updateMany(List<User> models,
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

  Future<User> find(int id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find, withConn: withConn);
  }

  Future<int> remove(int id, {Connection withConn}) async {
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
}

abstract class _AddressBean implements Bean<Address> {
  final id = IntField('id');
  final street = StrField('street');
  final userId = IntField('user_id');
  final userName = StrField('user_name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        street.name: street,
        userId.name: userId,
        userName.name: userName,
      };
  Address fromMap(Map map) {
    Address model = Address();
    model.id = adapter.parseValue(map['id']);
    model.street = adapter.parseValue(map['street']);
    model.userId = adapter.parseValue(map['user_id']);
    model.userName = adapter.parseValue(map['user_name']);

    return model;
  }

  List<SetColumn> toSetColumns(Address model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (!update && model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(street.set(model.street));
      ret.add(userId.set(model.userId));
      ret.add(userName.set(model.userName));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(street.name)) ret.add(street.set(model.street));
      if (only.contains(userId.name)) ret.add(userId.set(model.userId));
      if (only.contains(userName.name)) ret.add(userName.set(model.userName));
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
      if (model.userName != null) {
        ret.add(userName.set(model.userName));
      }
    }

    return ret;
  }

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      auto,
      isPrimary: true,
    );
    st.addByType(
      street.name,
      Str(length: 150),
    );
    st.addByType(
      userId.name,
      Int(),
      foreign: References("oto_simple_user", "id"),
    );
    st.addByType(
      userName.name,
      Str(),
      foreign: References("oto_simple_user", "name"),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(Address model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      Address newModel;
    }
    return retId;
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
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      Address newModel;
    }
    return retId;
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

  Future<Address> find(int id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find, withConn: withConn);
  }

  Future<int> remove(int id, {Connection withConn}) async {
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
}
