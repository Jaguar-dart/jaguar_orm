// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Example of writing ORM beans by hand. For source generated ORM beans
/// try 'jaguar_orm' package
import 'package:jaguar_query/jaguar_query.dart';

class Post {
  String id;

  String author;

  String message;

  int likes;

  int replies;

  static String tableName = 'posts';
}

class PostsBean {
  static String get tableName => Post.tableName;

  PostsBean();

  Find get finder => Sql.find(tableName);

  StrField get id => new StrField('id');

  StrField get author => new StrField('author');

  Find findById(String id) => Sql.find(Post.tableName).where(this.id.eq(id));

  Find findByAuthor(String auth) => finder.where(author.eq(auth));
}

main() {}
