// GENERATED CODE - DO NOT MODIFY BY HAND

part of example.basic;

// **************************************************************************
// Generator: BeanGenerator
// Target: class PostsBean
// **************************************************************************

abstract class _$PostsBean extends Bean<Post> {
  _$PostsBean(Adapter adapter) : super(adapter);

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

  List<SetColumn> toSetColumns(Post model) {
    List<SetColumn> ret = [];

    ret.add(id.set(model.id));
    ret.add(author.set(model.author));
    ret.add(message.set(model.message));
    ret.add(likes.set(model.likes));
    ret.add(replies.set(model.replies));

    return ret;
  }

  Future<dynamic> create(Post model) async {
    InsertStatement insert = inserterQ.setMany(toSetColumns(model));
    return execInsert(insert);
  }

  Future<int> update(Post model) async {
    UpdateStatement update =
        updaterQ.where(id.eq(model.id)).setMany(toSetColumns(model));
    return execUpdate(update);
  }

  Future<Post> find(String id) async {
    FindStatement find = finderQ.where(this.id.eq(id));
    return await execFindOne(find);
  }

  Future<int> delete(String id) async {
    DeleteStatement delete = deleterQ.where(this.id.eq(id));
    return execDelete(delete);
  }
}
