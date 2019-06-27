// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'model.dart';

/// The adapter
PgAdapter adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  final bean = PostBean(adapter);

  await bean.drop();

  await bean.createTable();

  // Insert some posts
  final id1 = await bean.insert(Post.make(msg: 'Whatever 1', author: 'mark'));
  final id2 = await bean.insert(Post.make(msg: 'Whatever 2', author: 'bob'));

  // Find one post
  Post post = await bean.findById(id1);
  print(post);

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
  post = await bean.findById(id1);
  print(post);

  exit(0);
}
