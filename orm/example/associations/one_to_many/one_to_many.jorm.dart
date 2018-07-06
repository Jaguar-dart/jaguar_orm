// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.one_to_many;

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _AuthorBean implements Bean<Author> {
  String get tableName => Author.tableName;

  final StrField id = new StrField('id');

  final StrField name = new StrField('name');

  Author fromMap(Map map) {
    Author model = new Author();

    model.id = adapter.parseValue(map['id']);
    model.name = adapter.parseValue(map['name']);

    return model;
  }

  List<SetColumn> toSetColumns(Author model, [bool update = false]) {
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

  Future<dynamic> insert(Author model, {bool cascade: false}) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    var retId = await execInsert(insert);
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

  Future<int> update(Author model,
      {bool cascade: false, bool associate: false}) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    final ret = execUpdate(update);
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

  Future<Author> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Author model = await execFindOne(find);
    if (preload) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<List<Author>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id, [bool cascade = false]) async {
    if (cascade) {
      final Author newModel = await find(id);
      await postBean.removeByAuthor(newModel.id);
    }
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<Author> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future preload(Author model, {bool cascade: false}) async {
    model.posts = await postBean.findByAuthor(model.id,
        preload: cascade, cascade: cascade);
  }

  Future preloadAll(List<Author> models, {bool cascade: false}) async {
    models.forEach((Author model) => model.posts ??= []);
    await PreloadHelper.preload<Author, Post>(
        models,
        (Author model) => [model.id],
        postBean.findByAuthorList,
        (Post model) => [model.authorId],
        (Author model, Post child) => model.posts.add(child),
        cascade: cascade);
  }

  PostBean get postBean;
}

abstract class _PostBean implements Bean<Post> {
  String get tableName => Post.tableName;

  final StrField id = new StrField('id');

  final StrField authorId = new StrField('author_id');

  final StrField message = new StrField('message');

  Post fromMap(Map map) {
    Post model = new Post();

    model.id = adapter.parseValue(map['id']);
    model.authorId = adapter.parseValue(map['author_id']);
    model.message = adapter.parseValue(map['message']);

    return model;
  }

  List<SetColumn> toSetColumns(Post model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(authorId.set(model.authorId));
    ret.add(message.set(model.message));

    return ret;
  }

  Future createTable() async {
    final st = Sql.create(tableName);
    st.addStr(id.name, primary: true, length: 50);
    st.addStr(authorId.name,
        foreignTable: Author.tableName, foreignCol: 'id', length: 50);
    st.addStr(message.name, length: 150);
    return execCreateTable(st);
  }

  Future<dynamic> insert(Post model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return execInsert(insert);
  }

  Future<int> update(Post model) async {
    final Update update =
        updater.where(this.id.eq(model.id)).setMany(toSetColumns(model));
    return execUpdate(update);
  }

  Future<Post> find(String id,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await execFindOne(find);
  }

  Future<List<Post>> findWhere(Expression exp) async {
    final Find find = finder.where(exp);
    return await (await execFind(find)).toList();
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }

  Future<int> removeMany(List<Post> models) async {
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return execRemove(remove);
  }

  Future<int> removeWhere(Expression exp) async {
    return execRemove(remover.where(exp));
  }

  Future<List<Post>> findByAuthor(String authorId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.authorId.eq(authorId));
    return await (await execFind(find)).toList();
  }

  Future<int> removeByAuthor(String authorId) async {
    final Remove rm = remover.where(this.authorId.eq(authorId));
    return await execRemove(rm);
  }

  Future<List<Post>> findByAuthorList(List<Author> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (Author model in models) {
      find.or(this.authorId.eq(model.id));
    }
    return await (await execFind(find)).toList();
  }

  void associateAuthor(Post child, Author parent) {
    child.authorId = parent.id;
  }
}
