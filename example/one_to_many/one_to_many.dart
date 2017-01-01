// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

class Author {
  @PrimaryKey()
  String id;

  String name;

  List<Post> posts;

  static String tableName = 'authors';
}

class Post {
  @PrimaryKey()
  String id;

  @ForeignKey(AuthorBean, #id)
  String authorId;

  String message;

  int likes;

  int replies;

  static String tableName = 'posts';
}

class AuthorBean {
  String get tableName => Author.tableName;

  AuthorBean();

  StrField get id => new StrField('id');

  StrField get name => new StrField('name');

  FindStatement get finder => Sql.find.from(tableName);

  FindStatement find(String id) =>
      Sql.find.from(Post.tableName).where(this.id.eq(id));
}

class PostsBean {
  static String get tableName => 'posts';

  PostsBean();

  StrField get id => new StrField('id');

  StrField get authorId => new StrField('authorId');

  FindStatement get finder => Sql.find.from(tableName);

  FindStatement find(String id) =>
      Sql.find.from(Post.tableName).where(this.id.eq(id));

  FindStatement findByAuthor(Author author) =>
      finder.where(authorId.eq(author.id));
}

main() {}
