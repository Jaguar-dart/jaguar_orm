// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

class Post {
  @PrimaryKey()
  String id;

  String author;

  String message;

  int likes;

  int replies;

  static String tableName = 'posts';
}

/// This must be generated from [PostsBean] and [Post]
class _$PostsBean extends Bean<Post, String> {
  _$PostsBean(Adapter<String> adapter) : super(adapter);

  String get tableName => 'posts';

  Future<Post> find(String id) async {
    FindStatement find =
        finderQ.from(Post.tableName).where(C.eq('id', V.Str(id)));
    return await execFindOne(find);
  }

  StrField get author => new StrField('author');

  Future<Stream<Post>> _findByAuthor(String auth) async {
    FindStatement find = finderQ.where(author.eq(auth));
    return await execFind(find);
  }

  Post fromMap(Map map) {
    Post post = new Post();

    post.id = map['id'];
    post.id = map['author'];
    post.id = map['message'];
    post.id = map['likes'];
    post.id = map['replies'];

    return post;
  }
}

class PostsBean extends _$PostsBean {
  PostsBean(Adapter<String> adapter) : super(adapter);

  @Find()
  Future<Stream<Post>> findByAuthor(@WhereEq(#author) String auth) =>
      _findByAuthor(auth);
}

main() {}
