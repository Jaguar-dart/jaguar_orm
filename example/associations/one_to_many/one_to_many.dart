// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet

/* TODO
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

class Author {
  @PrimaryKey()
  int id;

  String name;

  @HasMany()
  List<Post> posts;

  static const String tableName = 'authors';

  String toString() => "Author($id, $name, $posts)";
}

class Post {
  @PrimaryKey()
  int id;

  @ForeignKey(AuthorBean, #id)
  int authorId;

  String message;

  @BelongsTo()
  Author author;

  static String tableName = 'post';

  String toString() => "Post($id, $authorId, $author, $message)";
}

abstract class _AuthorBean implements Bean<Author> {
  String get tableName => Author.tableName;

  IntField get id => new IntField('id');

  StrField get name => new StrField('name');

  /// Creates a model from the map
  Author fromMap(Map map) => new Author()
    ..id = map['_id']
    ..name = map['name'];

  /// Creates list of 'set' column from model to be used in update or insert query
  List<SetColumn> toSetColumns(Author model) => <SetColumn>[
    id.set(model.id),
    name.set(model.name),
  ];

  Future<Author> findById(int id) async {
    final st = finder.where(this.id.eq(id));
    return await execFindOne(st);
  }
}

class AuthorBean extends Bean<Author> with _AuthorBean {
  AuthorBean(Adapter adapter): super(adapter);
}

abstract class _PostBean implements Bean<Post> {
  String get tableName => Post.tableName;

  IntField get id => new IntField('id');

  IntField get authorId => new IntField('authorId');

  StrField get message => new StrField('message');

  /// Creates a model from the map
  Post fromMap(Map map) => new Post()
    ..id = map['_id']
    ..authorId = map['authorid']
    ..message = map['message'];

  /// Creates list of 'set' column from model to be used in update or insert query
  List<SetColumn> toSetColumns(Post model) => <SetColumn>[
    id.set(model.id),
    authorId.set(model.authorId),
    message.set(model.message),
  ];

  Future<Post> findById(int id) async {
    final st = finder.where(this.id.eq(id));
    return await execFindOne(st);
  }
}

class PostsBean extends Bean<Post> with _PostBean {
  PostsBean(Adapter adapter): super(adapter);

  Find findByAuthor(Author author) =>
      finder.where(authorId.eq(author.id));
}

main() {}

*/