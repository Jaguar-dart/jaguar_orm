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

class _$Dummy extends Bean<Post> {
  _$Dummy(Adapter adapter) : super(adapter);

  String get tableName => Post.tableName;

  StrField get author => new StrField('author');

  Future<Post> find(String id) async {
    FindStatement find =
        finderQ.from(Post.tableName).where(C.eq('id', V.Str(id)));
    return await execFindOne(find);
  }

  Future<Stream<Post>> _findByAuthor(String auth) async {
    FindStatement find = finderQ.where(author.eq(auth));
    return await execFind(find);
  }

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

    ret.add(author.set(model.author));

    return ret;
  }
}

@GenBean()
class PostsBean extends _$PostsBean implements Bean<Post> {
  PostsBean(Adapter adapter) : super(adapter);

  /*
  @Find()
  Future<Stream<Post>> findByAuthor(@WhereEq(#author) String auth) =>
      _findByAuthor(auth);
      */
}

main() {}
