// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'model.dart';

/// The adapter
PgAdapter adapter =
    new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

/// The bean
class PostBean1 extends PostBean {
  PostBean1(Adapter adapter) : super(adapter);

  Future<void> createTable() async {
    final st = new Create()
        .named(tableName)
        .ifNotExists()
        .addInt('_id', primary: true, autoIncrement: true)
        .addStr('msg')
        .addStr('author');

    await adapter.createTable(st);
  }

  @override
  List<SetColumn> toSetColumns(Post model,
      {bool update = false, Set<String> only}) {
    final ret = <SetColumn>[];

    ret.add(msg.set(model.msg));
    ret.add(author.set(model.author));

    return ret;
  }

  /// Inserts a new post into table
  Future<dynamic> insert(Post post) async {
    Insert st = inserter.setMany(toSetColumns(post));
    st.id('_id');
    return adapter.insert(st);
  }
}

main() async {
  // Connect
  await adapter.connect();

  final bean = PostBean1(adapter);

  await adapter.dropTable(Sql.drop(bean.tableName).onlyIfExists());

  await bean.createTable();

  // Insert some posts
  final id1 = await bean.insert(Post.make(msg: 'Whatever 1', author: 'mark'));
  final id2 = await bean.insert(Post.make(msg: 'Whatever 2', author: 'bob'));

  // Find one post
  Post post = await bean.findById(id1);
  print(post);

  print('Fetching all:');
  print('-------------');

  // Find all posts
  List<Post> posts = await bean.getAll();
  print(posts);

  // Update a post
  await bean.updateAuthor(id1, 'rowling');

  // Check that the post is updated
  post = await bean.findById(id1);
  print(post);

  // Delete some posts
  await bean.remove(id1);
  await bean.remove(id2);

  // Find a post when none exists
  post = await bean.findById(1);
  print(post);

  // Close connection
  await adapter.close();
}
