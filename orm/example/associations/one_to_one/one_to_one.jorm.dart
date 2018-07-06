// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.has_one;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  String get tableName => User.tableName;

  final StrField id = new StrField('id');

  final StrField name = new StrField('name');

  User fromMap(Map map) {
    User model = new User();

    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(User model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(name.set(model.name));

    return ret;
  }

  Future createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(name.name, length: 50);
    return execCreateTable(st);
  }

  Future<dynamic> insert(User model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    var retId = await execInsert(insert);
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

  Future<int> update(User model,
      {bool cascade: false, bool associate: false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    final ret = execUpdate(update);
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

  Future<User> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final User model = await execFindOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<User>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final User newModel = await find(id);
      await addressBean.removeByUser(newModel.id);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<User> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future preload(User model, {bool cascade: false}) async {
    model.address = await addressBean.findByUser(model.id,
        preload: cascade, cascade: cascade);
  }

  Future preloadAll(List<User> models, {bool cascade: false}) async {
    await PreloadHelper.preload<User, Address>(
        models,
        (User model) => [model.id],
        addressBean.findByUserList,
        (Address model) => [model.userId],
        (User model, Address child) => model.address = child,
        cascade: cascade);
  }

  AddressBean get addressBean;
}

abstract class _AddressBean implements Bean<Address> {
  String get tableName => Address.tableName;

  final StrField id = new StrField('id');

  final StrField street = new StrField('street');

  final StrField userId = new StrField('user_id');

  Address fromMap(Map map) {
    Address model = new Address();

    model.id = adapter.parseValue(map['id']);
    model.street = adapter.parseValue(map['street']);
    model.userId = adapter.parseValue(map['user_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Address model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(street.set(model.street));
    ret.add(userId.set(model.userId));

    return ret;
  }

  Future createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(street.name, length: 150);
    st.addStr(userId.name, foreignTable: User.tableName, foreignCol: 'id');
    return execCreateTable(st);
  }

  Future<dynamic> insert(Address model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return execInsert(insert);
  }

  Future<int> update(Address model) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    return execUpdate(update);
  }

  Future<Address> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await execFindOne(find);
  }

  Future<List<Address>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<Address> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future<Address> findByUser(String userId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.userId.eq(userId));
    return await execFindOne(find);
  }

  Future<int> removeByUser(String userId) async {
    final Remove rm = remover.where(this.userId.eq(userId));
    return await execRemove(rm);
  }

  Future<List<Address>> findByUserList(List<User> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (User model in models) {
      find.or(this.userId.eq(model.id));
    }
    return await (await execFind(find)).toList();
  }

  void associateUser(Address child, User parent) {
    child.userId = parent.id;
  }
}
