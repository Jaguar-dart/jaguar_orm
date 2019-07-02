// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'simple.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _UserBean implements Bean<User> {
  final id = IntField('id');
  final name = StrField('name');
  final scores = ArrayField<int>('scores');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        scores.name: scores,
      };
  User fromMap(Map map) {
    User model = User();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.scores = adapter.parseValue(map['scores']);

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
      ret.add(scores.set(model.scores));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(scores.name)) ret.add(scores.set(model.scores));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.scores != null) {
        ret.add(scores.set(model.scores));
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
      notNull: true,
    );
    st.addByType(
      name.name,
      Str(),
    );
    st.addByType(
      scores.name,
      intArray,
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
