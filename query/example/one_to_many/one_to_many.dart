// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet
import 'package:jaguar_query/jaguar_query.dart';

class ToOne {
  const ToOne();
}

class Author {
  String id;

  String name;

  @ToOne()
  List<Post> posts;

  static String tableName = 'authors';
}

class Post {
  String id;

  @Foreign('author', 'id')
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

  Find get finder => Sql.find(tableName);

  Find find(String id) => Sql.find(Post.tableName).where(this.id.eq(id));
}

class PostsBean {
  static String get tableName => 'posts';

  PostsBean();

  StrField get id => new StrField('id');

  StrField get authorId => new StrField('authorId');

  StrField get message => new StrField('message');

  IntField get likes => new IntField('likes');

  IntField get replies => new IntField('replies');

  Find get finder => Sql.find(tableName);

  Find find(String id) => Sql.find(Post.tableName).where(this.id.eq(id));

  Find findByAuthor(Author author) => finder.where(authorId.eq(author.id));
}

main() {}
