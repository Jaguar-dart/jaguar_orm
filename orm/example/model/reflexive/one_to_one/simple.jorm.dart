// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.has_one;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _DirectoryBean implements Bean<Directory> {
  final id = StrField('id');
  final name = StrField('name');
  final parentId = StrField('parent_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
        parentId.name: parentId,
      };
  Directory fromMap(Map map) {
    Directory model = Directory();
    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);
    model.parentId = adapter.parseValue(map['parent_id']);

    return model;
  }

  List<SetColumn> toSetColumns(Directory model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(name.set(model.name));
      ret.add(parentId.set(model.parentId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(name.name)) ret.add(name.set(model.name));
      if (only.contains(parentId.name)) ret.add(parentId.set(model.parentId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.name != null) {
        ret.add(name.set(model.name));
      }
      if (model.parentId != null) {
        ret.add(parentId.set(model.parentId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addStr(id.name, primary: true, length: 50, isNullable: false);
    st.addStr(name.name, length: 50, isNullable: false);
    st.addStr(parentId.name,
        foreignTable: directoryBean.tableName,
        foreignCol: 'id',
        isNullable: true);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Directory model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Directory newModel;
      if (model.child != null) {
        newModel ??= await find(model.id);
        directoryBean.associateDirectory(model.child, newModel);
        await directoryBean.insert(model.child, cascade: cascade);
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Directory> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Directory model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Directory newModel;
      if (model.child != null) {
        newModel ??= await find(model.id);
        directoryBean.associateDirectory(model.child, newModel);
        await directoryBean.upsert(model.child, cascade: cascade);
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Directory> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade));
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
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Directory model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Directory newModel;
      if (model.child != null) {
        if (associate) {
          newModel ??= await find(model.id);
          directoryBean.associateDirectory(model.child, newModel);
        }
        await directoryBean.update(model.child,
            cascade: cascade, associate: associate);
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Directory> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
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
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Directory> find(String id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Directory model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(String id, {bool cascade = false}) async {
    if (cascade) {
      final Directory newModel = await find(id);
      if (newModel != null) {
        await directoryBean.removeByDirectory(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Directory> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Directory> findByDirectory(String parentId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.parentId.eq(parentId));
    final Directory model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<Directory>> findByDirectoryList(List<Directory> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Directory model in models) {
      find.or(this.parentId.eq(model.id));
    }
    final List<Directory> retModels = await findMany(find);
    if (preload) {
      await this.preloadAll(retModels, cascade: cascade);
    }
    return retModels;
  }

  Future<int> removeByDirectory(String parentId) async {
    final Remove rm = remover.where(this.parentId.eq(parentId));
    return await adapter.remove(rm);
  }

  void associateDirectory(Directory child, Directory parent) {
    child.parentId = parent.id;
  }

  Future<Directory> preload(Directory model, {bool cascade = false}) async {
    model.child = await directoryBean.findByDirectory(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Directory>> preloadAll(List<Directory> models,
      {bool cascade = false}) async {
    await OneToXHelper.preloadAll<Directory, Directory>(
        models,
        (Directory model) => [model.id],
        directoryBean.findByDirectoryList,
        (Directory model) => [model.parentId],
        (Directory model, Directory child) => model.child = child,
        cascade: cascade);
    return models;
  }

  DirectoryBean get directoryBean;
}
