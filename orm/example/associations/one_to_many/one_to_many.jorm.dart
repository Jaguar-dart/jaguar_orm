// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.one_to_many;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _AuthorBean implements Bean<Author> {
  final id = new StrField('id');
  final name = new StrField('name');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        name.name: name,
      };
  Author fromMap(Map map) {
    Author model = Author();

    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(Author model,
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

  Future<dynamic> insert(Author model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    var retId = await adapter.insert(insert);
    if (cascade) {
      Author newModel;
      if (model.posts != null) {
        newModel ??= await find(model.id);
        model.posts.forEach((x) => postBean.associateAuthor(x, newModel));
        for (final child in model.posts) {
          await postBean.insert(child);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Author> models, {bool cascade: false}) async {
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

  Future<int> update(Author model,
      {bool cascade: false, bool associate: false, Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    final ret = adapter.update(update);
    if (cascade) {
      Author newModel;
      if (model.posts != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.posts.forEach((x) => postBean.associateAuthor(x, newModel));
        }
        for (final child in model.posts) {
          await postBean.update(child);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Author> models, {bool cascade: false}) async {
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

  Future<Author> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Author model = await findOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final Author newModel = await find(id);
      await postBean.removeByAuthor(newModel.id);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Author> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Author> preload(Author model, {bool cascade: false}) async {
    model.posts = await postBean.findByAuthor(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Author>> preloadAll(List<Author> models,
      {bool cascade: false}) async {
    models.forEach((Author model) => model.posts ??= []);
    await OneToXHelper.preloadAll<Author, Post>(
        models,
        (Author model) => [model.id],
        postBean.findByAuthorList,
        (Post model) => [model.authorId],
        (Author model, Post child) => model.posts.add(child),
        cascade: cascade);
    return models;
  }

  PostBean get postBean;
}

abstract class _PostBean implements Bean<Post> {
  final id = new StrField('id');
  final authorId = new StrField('author_id');
  final message = new StrField('message');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        authorId.name: authorId,
        message.name: message,
      };
  Post fromMap(Map map) {
    Post model = Post();

    model.id = adapter.parseValue(map['id']);
    model.authorId = adapter.parseValue(map['author_id']);
    model.message = adapter.parseValue(map['message']);

    return model;
  }

  List<SetColumn> toSetColumns(Post model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(authorId.set(model.authorId));
      ret.add(message.set(model.message));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(authorId.name)) ret.add(authorId.set(model.authorId));
      if (only.contains(message.name)) ret.add(message.set(model.message));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50, isNullable: false);
    st.addStr(authorId.name,
        foreignTable: authorBean.tableName,
        foreignCol: 'id',
        length: 50,
        isNullable: false);
    st.addStr(message.name, length: 150, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Post model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<Post> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<int> update(Post model, {Set<String> only}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only));
    return adapter.update(update);
  }

  Future<void> updateMany(List<Post> models) async {
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

  Future<Post> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Post> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<Post>> findByAuthor(String authorId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.authorId.eq(authorId));
    return findMany(find);
  }

  Future<List<Post>> findByAuthorList(List<Author> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (Author model in models) {
      find.or(this.authorId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByAuthor(String authorId) async {
    final Remove rm = remover.where(this.authorId.eq(authorId));
    return await adapter.remove(rm);
  }

  void associateAuthor(Post child, Author parent) {
    child.authorId = parent.id;
  }

  AuthorBean get authorBean;
}
