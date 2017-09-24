// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.basic;

// **************************************************************************
// Generator: BeanGenerator
// **************************************************************************

abstract class _PostsBean implements Bean<Post> {
  String get tableName => Post.tableName;

  final StrField id = new StrField('id');

  final StrField author = new StrField('author');

  final StrField message = new StrField('message');

  final IntField likes = new IntField('likes');

  final IntField replies = new IntField('replies');

  Post fromMap(Map map) {
    Post model = new Post();

    model.id = map['id'];
    model.author = map['author'];
    model.message = map['message'];
    model.likes = map['likes'];
    model.replies = map['replies'];

    return model;
  }

  List<SetColumn> toSetColumns(Post model, [bool update = false]) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(author.set(model.author));
    ret.add(message.set(model.message));
    ret.add(likes.set(model.likes));
    ret.add(replies.set(model.replies));

    return ret;
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
}
