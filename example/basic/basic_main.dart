// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.basic;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'basic_main.g.dart';

class Post {
  @PrimaryKey()
  String id;

  String author;

  String message;

  int likes;

  int replies;

  static String tableName = 'posts';
}

@GenBean()
class PostsBean extends Bean<Post> with _PostsBean  {
  PostsBean(Adapter adapter) : super(adapter);

  @Finder()
  Future<Stream<Post>> findByAuthor(@WhereEq() String author) =>
      super.findByAuthor(author);

  @Updater()
  Future updateByAuthor(@WhereEq() String author, @SetField() int replies) =>
      super.updateByAuthor(author, replies);

  @Deleter()
  Future deleteByAuthor(@WhereEq() String author) =>
      super.deleteByAuthor(author);
}

main() {}
