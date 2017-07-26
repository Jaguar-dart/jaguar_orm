// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.basic;

// **************************************************************************
// Generator: BeanGenerator
// **************************************************************************

abstract class _PostsBean implements Bean<Post> {
  String get tableName => Post.tableName;

  StrField get id => new StrField('id');

  StrField get author => new StrField('author');

  StrField get message => new StrField('message');

  IntField get likes => new IntField('likes');

  IntField get replies => new IntField('replies');

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

  Future<dynamic> create(Post model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return execInsert(insert);
  }

  Future<int> update(Post model) async {
    final Update update =
        updater.where(id.eq(model.id)).setMany(toSetColumns(model));
    return execUpdate(update);
  }

  Future<Post> find(String id) async {
    final Find find = finder.where(this.id.eq(id));
    return await execFindOne(find);
  }

  Future<int> remove(String id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return execRemove(remove);
  }
}
