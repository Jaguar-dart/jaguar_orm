// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'ignore_column.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = new StrField('id');
  final name = new StrField('name');
  final age = new IntField('age');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        age.name: age,
      };
  User fromMap(Map map) {
    User model = new User();

    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.age = adapter.parseValue(map['age']);

    return model;
  }

  List<SetColumn> toSetColumns(User model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(age.set(model.age));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(age.name)) ret.add(age.set(model.age));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, isNullable: false);
    st.addStr(name.name, isNullable: false);
    st.addInt(age.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(User model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<User> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<int> update(User model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<User> models) async {
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

  Future<User> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
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
}
