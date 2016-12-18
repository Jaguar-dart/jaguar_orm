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
}
