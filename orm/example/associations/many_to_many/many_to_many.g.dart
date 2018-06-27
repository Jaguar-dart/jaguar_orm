// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.many_to_many;

// **************************************************************************
// Generator: BeanGenerator
// **************************************************************************

abstract class _TodoListBean implements Bean<TodoList> {
  String get tableName => TodoList.tableName;

  final StrField id = new StrField('id');

  final StrField description = new StrField('description');

  TodoList fromMap(Map map) {
    TodoList model = new TodoList();

    model.id = map['id'];
    model.description = map['description'];

    return model;
  }

  List<SetColumn> toSetColumns(TodoList model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(description.set(model.description));

    return ret;
  }

  Future createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(description.name, length: 50);
    return execCreateTable(st);
  }

  Future<Null> insert(TodoList model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    await execInsert(insert);
    if (cascade) {
      TodoList newModel;
      if (model.categories != null) {
        newModel ??= await find(model.id);
        for (final child in model.categories) {
          await categoryBean.insert(child);
          await pivotBean.attach(model, child);
        }
      }
    }
  }

  Future<int> update(TodoList model,
      {bool cascade: false, bool associate: false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    final ret = execUpdate(update);
    if (cascade) {
      TodoList newModel;
      if (model.categories != null) {
        for (final child in model.categories) {
          await await categoryBean.update(child);
        }
      }
    }
    return ret;
  }

  Future<TodoList> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final TodoList model = await execFindOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<TodoList>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final TodoList newModel = await find(id);
      await pivotBean.detachTodoList(newModel);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<TodoList> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future preload(TodoList model, {bool cascade: false}) async {
    model.categories = await pivotBean.fetchByTodoList(model);
  }

  Future preloadAll(List<TodoList> models, {bool cascade: false}) async {}
  PivotBean get pivotBean;

  CategoryBean get categoryBean;
}

abstract class _CategoryBean implements Bean<Category> {
  String get tableName => Category.tableName;

  final StrField id = new StrField('id');

  final StrField name = new StrField('name');

  Category fromMap(Map map) {
    Category model = new Category();

    model.id = map['id'];
    model.name = map['name'];

    return model;
  }

  List<SetColumn> toSetColumns(Category model, [bool update = false]) {
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

  Future<Null> insert(Category model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    await execInsert(insert);
    if (cascade) {
      Category newModel;
      if (model.todolists != null) {
        newModel ??= await find(model.id);
        for (final child in model.todolists) {
          await todoListBean.insert(child);
          await pivotBean.attach(child, model);
        }
      }
    }
  }

  Future<int> update(Category model,
      {bool cascade: false, bool associate: false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    final ret = execUpdate(update);
    if (cascade) {
      Category newModel;
      if (model.todolists != null) {
        for (final child in model.todolists) {
          await await todoListBean.update(child);
        }
      }
    }
    return ret;
  }

  Future<Category> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Category model = await execFindOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<Category>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final Category newModel = await find(id);
      await pivotBean.detachCategory(newModel);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<Category> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future preload(Category model, {bool cascade: false}) async {
    model.todolists = await pivotBean.fetchByCategory(model);
  }

  Future preloadAll(List<Category> models, {bool cascade: false}) async {}
  PivotBean get pivotBean;

  TodoListBean get todoListBean;
}

abstract class _PivotBean implements Bean<Pivot> {
  String get tableName => Pivot.tableName;

  final StrField todolistId = new StrField('todolist_id');

  final StrField categoryId = new StrField('category_id');

  Pivot fromMap(Map map) {
    Pivot model = new Pivot();

    model.todolistId = map['todolist_id'];
    model.categoryId = map['category_id'];

    return model;
  }

  List<SetColumn> toSetColumns(Pivot model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(todolistId.set(model.todolistId));
    ret.add(categoryId.set(model.categoryId));

    return ret;
  }

  Future createTable() async {
    final st = Sql.create(tableName);
    st.addStr(todolistId.name,
        foreignTable: TodoList.tableName, foreignCol: 'id', length: 50);
    st.addStr(categoryId.name,
        foreignTable: Category.tableName, foreignCol: 'id', length: 50);
    return execCreateTable(st);
  }

  Future<dynamic> insert(Pivot model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return execInsert(insert);
  }

  Future<List<Pivot>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future<List<Pivot>> findByTodoList(String todolistId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.todolistId.eq(todolistId));
    return await (await execFind(find)).toList();
  }

  Future<List<Pivot>> findByCategory(String categoryId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.categoryId.eq(categoryId));
    return await (await execFind(find)).toList();
  }

  Future<int> removeByTodoList(String todolistId) async {
    final Remove rm = remover.where(this.todolistId.eq(todolistId));
    return await execRemove(rm);
  }

  Future<int> removeByCategory(String categoryId) async {
    final Remove rm = remover.where(this.categoryId.eq(categoryId));
    return await execRemove(rm);
  }

  Future<List<Pivot>> findByTodoListList(List<TodoList> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (TodoList model in models) {
      find.or(this.todolistId.eq(model.id));
    }
    return await (await execFind(find)).toList();
  }

  Future<List<Pivot>> findByCategoryList(List<Category> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (Category model in models) {
      find.or(this.categoryId.eq(model.id));
    }
    return await (await execFind(find)).toList();
  }

  void associateTodoList(Pivot child, TodoList parent) {
    child.todolistId = parent.id;
  }

  void associateCategory(Pivot child, Category parent) {
    child.categoryId = parent.id;
  }

  Future<int> detachTodoList(TodoList model) async {
    final dels = await findByTodoList(model.id);
    await removeByTodoList(model.id);
    final exp = new Or();
    for (final t in dels) {
      exp.or(categoryBean.id.eq(t.categoryId));
    }
    return await categoryBean.removeWhere(exp);
  }

  Future<int> detachCategory(Category model) async {
    final dels = await findByCategory(model.id);
    await removeByCategory(model.id);
    final exp = new Or();
    for (final t in dels) {
      exp.or(todoListBean.id.eq(t.todolistId));
    }
    return await todoListBean.removeWhere(exp);
  }

  Future<List<Category>> fetchByTodoList(TodoList model) async {
    final pivots = await findByTodoList(model.id);
    final exp = new Or();
    for (final t in pivots) {
      exp.or(categoryBean.id.eq(t.categoryId));
    }
    return await categoryBean.findWhere(exp);
  }

  Future<List<TodoList>> fetchByCategory(Category model) async {
    final pivots = await findByCategory(model.id);
    final exp = new Or();
    for (final t in pivots) {
      exp.or(todoListBean.id.eq(t.todolistId));
    }
    return await todoListBean.findWhere(exp);
  }

  Future<dynamic> attach(TodoList one, Category two) async {
    final ret = new Pivot();
    ret.todolistId = one.id;
    ret.categoryId = two.id;
    return insert(ret);
  }

  TodoListBean get todoListBean;
  CategoryBean get categoryBean;
}
