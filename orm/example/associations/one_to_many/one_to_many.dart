// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.one_to_many;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../model/associations/one_to_many/simple.dart';

/// The adapter
final _adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await _adapter.connect();

  // Create beans
  final authorBean = AuthorBean(_adapter);
  final postBean = PostBean(_adapter);

  // Drop old tables
  await postBean.drop();
  await authorBean.drop();

  // Create new tables
  await authorBean.createTable();
  await postBean.createTable();

  // Cascaded One-To-One insert
  {
    final author = Author()
      ..id = '1'
      ..name = 'Teja'
      ..posts = <Post>[
        Post()
          ..id = '10'
          ..message = 'Message 10',
        Post()
          ..id = '11'
          ..message = 'Message11'
      ];
    await authorBean.insert(author, cascade: true);
  }

  // Fetch One-To-One preloaded
  {
    final author = await authorBean.find('1', preload: true);
    print(author);
  }

  // Manual One-To-One insert
  {
    Author author = Author()
      ..id = '2'
      ..name = 'Kleak';
    await authorBean.insert(author, cascade: true);

    author = await authorBean.find('2');

    final post1 = Post()
      ..id = '20'
      ..message = 'Message 20';
    postBean.associateAuthor(post1, author);
    await postBean.insert(post1);

    final post2 = Post()
      ..id = '21'
      ..message = 'Message 21';
    postBean.associateAuthor(post2, author);
    await postBean.insert(post2);
  }

  // Manual One-To-One preload
  {
    final author = await authorBean.find('2');
    print(author);
    author.posts = await postBean.findByAuthor(author.id);
    print(author);
  }

  // Preload many
  {
    final authors = await authorBean.getAll();
    print(authors);
    await authorBean.preloadAll(authors);
    print(authors);
  }

  // Cascaded One-To-One update
  {
    Author author = await authorBean.find('1', preload: true);
    author.name = 'Teja Hackborn';
    author.posts[0].message += '!';
    author.posts[1].message += '!';
    await authorBean.update(author, cascade: true);
  }

  // Fetch One-To-One relationship preloaded
  {
    final user = await authorBean.find('1', preload: true);
    print(user);
  }

  // Cascaded removal of One-To-One relation
  await authorBean.remove('1', cascade: true);

  // Preload many
  {
    final authors = await authorBean.getAll();
    print(authors);
    await authorBean.preloadAll(authors);
    print(authors);
  }
  print(await postBean.getAll());

  // Remove addresses belonging to a User
  await postBean.removeByAuthor('2');

  print(await postBean.getAll());

  exit(0);
}
