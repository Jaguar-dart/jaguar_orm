// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'composite.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _TodoListBean implements Bean<TodoList> {
  final id = StrField('id');
  final description = StrField('description');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        description.name: description,
      };
  TodoList fromMap(Map map) {
    TodoList model = TodoList();
    model.id = adapter.parseValue(map['id']);
    model.description = adapter.parseValue(map['description']);

    return model;
  }

  List<SetColumn> toSetColumns(TodoList model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(description.set(model.description));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(description.name))
        ret.add(description.set(model.description));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.description != null) {
        ret.add(description.set(model.description));
      }
    }

    return ret;
  }

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      Str(),
      isPrimary: true,
    );
    st.addByType(
      description.name,
      Str(),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(TodoList model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      TodoList newModel;
      if (model.categories != null) {
        newModel ??= await find(model.id, withConn: withConn);
        for (final child in model.categories) {
          await categoryBean.insert(child,
              cascade: cascade, withConn: withConn);
          await pivotBean.attach(newModel, child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<TodoList> models,
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

  Future<dynamic> upsert(TodoList model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      TodoList newModel;
      if (model.categories != null) {
        newModel ??= await find(model.id, withConn: withConn);
        for (final child in model.categories) {
          await categoryBean.upsert(child,
              cascade: cascade, withConn: withConn);
          await pivotBean.attach(newModel, child,
              upsert: true, withConn: withConn);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<TodoList> models,
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

  Future<int> update(TodoList model,
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
      TodoList newModel;
      if (model.categories != null) {
        for (final child in model.categories) {
          await categoryBean.update(child,
              cascade: cascade, associate: associate, withConn: withConn);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<TodoList> models,
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

  Future<TodoList> find(String id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    final TodoList model = await findOne(find, withConn: withConn);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade, withConn: withConn);
    }
    return model;
  }

  Future<int> remove(String id,
      {bool cascade = false,
      Connection withConn,
      bool removeOrphans = false}) async {
    if (cascade) {
      final TodoList newModel = await find(id, withConn: withConn);
      if (newModel != null) {
        await pivotBean.detachTodoList(newModel,
            withConn: withConn, removeOrphans: removeOrphans);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<TodoList> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<TodoList> preload(TodoList model,
      {bool cascade = false, Connection withConn}) async {
    model.categories =
        await pivotBean.fetchByTodoList(model, withConn: withConn);
    return model;
  }

  Future<List<TodoList>> preloadAll(List<TodoList> models,
      {bool cascade = false, Connection withConn}) async {
    for (TodoList model in models) {
      var temp = await pivotBean.fetchByTodoList(model, withConn: withConn);
      if (model.categories == null)
        model.categories = temp;
      else {
        model.categories.clear();
        model.categories.addAll(temp);
      }
    }
    return models;
  }

  PivotBean get pivotBean => beanRepo[PivotBean];

  CategoryBean get categoryBean => beanRepo[CategoryBean];
  BeanRepo get beanRepo;
}

abstract class _CategoryBean implements Bean<Category> {
  final id = StrField('id');
  final id2 = StrField('id2');
  final name = StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        id2.name: id2,
        name.name: name,
      };
  Category fromMap(Map map) {
    Category model = Category();
    model.id = adapter.parseValue(map['id']);
    model.id2 = adapter.parseValue(map['id2']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(Category model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(id.set(model.id));
      ret.add(id2.set(model.id2));
      ret.add(name.set(model.name));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(id2.name)) ret.add(id2.set(model.id2));
      if (only.contains(name.name)) ret.add(name.set(model.name));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.id2 != null) {
        ret.add(id2.set(model.id2));
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
      Str(),
      isPrimary: true,
    );
    st.addByType(
      id2.name,
      Str(),
      isPrimary: true,
    );
    st.addByType(
      name.name,
      Str(),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(Category model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      Category newModel;
      if (model.todolists != null) {
        newModel ??= await find(model.id, model.id2, withConn: withConn);
        for (final child in model.todolists) {
          await todoListBean.insert(child,
              cascade: cascade, withConn: withConn);
          await pivotBean.attach(child, newModel, withConn: withConn);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Category> models,
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

  Future<dynamic> upsert(Category model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      Category newModel;
      if (model.todolists != null) {
        newModel ??= await find(model.id, model.id2, withConn: withConn);
        for (final child in model.todolists) {
          await todoListBean.upsert(child,
              cascade: cascade, withConn: withConn);
          await pivotBean.attach(child, newModel,
              upsert: true, withConn: withConn);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Category> models,
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

  Future<int> update(Category model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .where(this.id2.eq(model.id2))
        .setMany(toSetColumns(model,
            only: only, onlyNonNull: onlyNonNull, update: true));
    final ret = adapter.update(update, withConn: withConn);
    if (cascade) {
      Category newModel;
      if (model.todolists != null) {
        for (final child in model.todolists) {
          await todoListBean.update(child,
              cascade: cascade, associate: associate, withConn: withConn);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Category> models,
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
        where.add(this.id.eq(model.id).and(this.id2.eq(model.id2)));
      }
      final UpdateMany update = updateser.addAll(data, where);
      await adapter.updateMany(update, withConn: withConn);
      return;
    }
  }

  Future<Category> find(String id, String id2,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id)).where(this.id2.eq(id2));
    final Category model = await findOne(find, withConn: withConn);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade, withConn: withConn);
    }
    return model;
  }

  Future<int> remove(String id, String id2,
      {bool cascade = false,
      Connection withConn,
      bool removeOrphans = false}) async {
    if (cascade) {
      final Category newModel = await find(id, id2, withConn: withConn);
      if (newModel != null) {
        await pivotBean.detachCategory(newModel,
            withConn: withConn, removeOrphans: removeOrphans);
      }
    }
    final Remove remove = remover.where(this.id.eq(id)).where(this.id2.eq(id2));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<Category> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id) | this.id2.eq(model.id2));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<Category> preload(Category model,
      {bool cascade = false, Connection withConn}) async {
    model.todolists =
        await pivotBean.fetchByCategory(model, withConn: withConn);
    return model;
  }

  Future<List<Category>> preloadAll(List<Category> models,
      {bool cascade = false, Connection withConn}) async {
    for (Category model in models) {
      var temp = await pivotBean.fetchByCategory(model, withConn: withConn);
      if (model.todolists == null)
        model.todolists = temp;
      else {
        model.todolists.clear();
        model.todolists.addAll(temp);
      }
    }
    return models;
  }

  PivotBean get pivotBean => beanRepo[PivotBean];

  TodoListBean get todoListBean => beanRepo[TodoListBean];
  BeanRepo get beanRepo;
}

abstract class _PivotBean implements Bean<Pivot> {
  final todolistId = StrField('todolist_id');
  final categoryId = StrField('category_id');
  final categoryId2 = StrField('category_id2');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        todolistId.name: todolistId,
        categoryId.name: categoryId,
        categoryId2.name: categoryId2,
      };
  Pivot fromMap(Map map) {
    Pivot model = Pivot();
    model.todolistId = adapter.parseValue(map['todolist_id']);
    model.categoryId = adapter.parseValue(map['category_id']);
    model.categoryId2 = adapter.parseValue(map['category_id2']);

    return model;
  }

  List<SetColumn> toSetColumns(Pivot model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      ret.add(todolistId.set(model.todolistId));
      ret.add(categoryId.set(model.categoryId));
      ret.add(categoryId2.set(model.categoryId2));
    } else if (only != null) {
      if (only.contains(todolistId.name))
        ret.add(todolistId.set(model.todolistId));
      if (only.contains(categoryId.name))
        ret.add(categoryId.set(model.categoryId));
      if (only.contains(categoryId2.name))
        ret.add(categoryId2.set(model.categoryId2));
    } else /* if (onlyNonNull) */ {
      if (model.todolistId != null) {
        ret.add(todolistId.set(model.todolistId));
      }
      if (model.categoryId != null) {
        ret.add(categoryId.set(model.categoryId));
      }
      if (model.categoryId2 != null) {
        ret.add(categoryId2.set(model.categoryId2));
      }
    }

    return ret;
  }

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      todolistId.name,
      Str(),
      foreign: References(todoListBean.tableName, "id"),
    );
    st.addByType(
      categoryId.name,
      Str(),
      foreign: References(categoryBean.tableName, "id"),
    );
    st.addByType(
      categoryId2.name,
      Str(),
      foreign: References(categoryBean.tableName, "id2"),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(Pivot model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert, withConn: withConn);
  }

  Future<void> insertMany(List<Pivot> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = insertser.addAll(data);
    await adapter.insertMany(insert, withConn: withConn);
    return;
  }

  Future<dynamic> upsert(Pivot model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert, withConn: withConn);
  }

  Future<void> upsertMany(List<Pivot> models,
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

  Future<void> updateMany(List<Pivot> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model,
              only: only, onlyNonNull: onlyNonNull, update: true)
          .toList());
      where.add(null);
    }
    final UpdateMany update = updateser.addAll(data, where);
    await adapter.updateMany(update, withConn: withConn);
    return;
  }

  Future<List<Pivot>> findByTodoList(String todolistId,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.todolistId.eq(todolistId));
    return findMany(find, withConn: withConn);
  }

  Future<List<Pivot>> findByTodoListList(List<TodoList> models,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (TodoList model in models) {
      find.or(this.todolistId.eq(model.id));
    }
    return findMany(find, withConn: withConn);
  }

  Future<int> removeByTodoList(String todolistId, {Connection withConn}) async {
    final Remove rm = remover.where(this.todolistId.eq(todolistId));
    return await adapter.remove(rm, withConn: withConn);
  }

  void associateTodoList(Pivot child, TodoList parent) {
    child.todolistId = parent.id;
  }

  Future<int> detachTodoList(TodoList model,
      {Connection withConn, bool removeOrphans = false}) async {
    int ret = 0;
    final dels = await findByTodoList(model.id, withConn: withConn);
    if (dels.isNotEmpty) {
      ret = await removeByTodoList(model.id, withConn: withConn);
      if (removeOrphans) {
        final exp = Or();
        for (final t in dels) {
          exp.or((categoryBean.id.eq(t.categoryId) &
                  categoryBean.id2.eq(t.categoryId2)) &
              ~exists(finder.sel(nil).where(categoryId.eq(t.categoryId) &
                  categoryId2.eq(t.categoryId2))));
        }
        await categoryBean.removeWhere(exp, withConn: withConn);
      }
    }
    return ret;
  }

  Future<List<Category>> fetchByTodoList(TodoList model,
      {Connection withConn}) async {
    final pivots = await findByTodoList(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];

    final duplicates = <Tuple, int>{};

    final exp = Or();
    for (final t in pivots) {
      final tup = Tuple([t.categoryId, t.categoryId2]);
      if (duplicates[tup] == null) {
        exp.or(categoryBean.id.eq(t.categoryId) &
            categoryBean.id2.eq(t.categoryId2));
        duplicates[tup] = 1;
      } else {
        duplicates[tup] += 1;
      }
    }

    final returnList = await categoryBean.findWhere(exp, withConn: withConn);

    if (duplicates.length != pivots.length) {
      for (Tuple tup in duplicates.keys) {
        int n = duplicates[tup] - 1;
        for (int i = 0; i < n; i++) {
          returnList
              .add(await categoryBean.find(tup[0], tup[1], withConn: withConn));
        }
      }
    }

    return returnList;
  }

  Future<List<Pivot>> findByCategory(String categoryId, String categoryId2,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder
        .where(this.categoryId.eq(categoryId))
        .where(this.categoryId2.eq(categoryId2));
    return findMany(find, withConn: withConn);
  }

  Future<List<Pivot>> findByCategoryList(List<Category> models,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Category model in models) {
      find.or(this.categoryId.eq(model.id) & this.categoryId2.eq(model.id2));
    }
    return findMany(find, withConn: withConn);
  }

  Future<int> removeByCategory(String categoryId, String categoryId2,
      {Connection withConn}) async {
    final Remove rm = remover
        .where(this.categoryId.eq(categoryId))
        .where(this.categoryId2.eq(categoryId2));
    return await adapter.remove(rm, withConn: withConn);
  }

  void associateCategory(Pivot child, Category parent) {
    child.categoryId = parent.id;
    child.categoryId2 = parent.id2;
  }

  Future<int> detachCategory(Category model,
      {Connection withConn, bool removeOrphans = false}) async {
    int ret = 0;
    final dels = await findByCategory(model.id, model.id2, withConn: withConn);
    if (dels.isNotEmpty) {
      ret = await removeByCategory(model.id, model.id2, withConn: withConn);
      if (removeOrphans) {
        final exp = Or();
        for (final t in dels) {
          exp.or((todoListBean.id.eq(t.todolistId)) &
              ~exists(finder.sel(nil).where(todolistId.eq(t.todolistId))));
        }
        await todoListBean.removeWhere(exp, withConn: withConn);
      }
    }
    return ret;
  }

  Future<List<TodoList>> fetchByCategory(Category model,
      {Connection withConn}) async {
    final pivots = await findByCategory(model.id, model.id2);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];

    final duplicates = <Tuple, int>{};

    final exp = Or();
    for (final t in pivots) {
      final tup = Tuple([t.todolistId]);
      if (duplicates[tup] == null) {
        exp.or(todoListBean.id.eq(t.todolistId));
        duplicates[tup] = 1;
      } else {
        duplicates[tup] += 1;
      }
    }

    final returnList = await todoListBean.findWhere(exp, withConn: withConn);

    if (duplicates.length != pivots.length) {
      for (Tuple tup in duplicates.keys) {
        int n = duplicates[tup] - 1;
        for (int i = 0; i < n; i++) {
          returnList.add(await todoListBean.find(tup[0], withConn: withConn));
        }
      }
    }

    return returnList;
  }

  Future<dynamic> attach(TodoList one, Category two,
      {bool upsert = false, Connection withConn}) async {
    final ret = Pivot();
    ret.todolistId = one.id;
    ret.categoryId = two.id;
    ret.categoryId2 = two.id2;
    if (!upsert) {
      return insert(ret, withConn: withConn);
    } else {
      return this.upsert(ret, withConn: withConn);
    }
  }

  TodoListBean get todoListBean => beanRepo[TodoListBean];
  CategoryBean get categoryBean => beanRepo[CategoryBean];
  BeanRepo get beanRepo;
}
