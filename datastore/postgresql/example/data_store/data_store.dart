library example.data_store.simple;

import 'dart:io';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar_query_data_store/jaguar_query_data_store.dart';
import '../common/post/post.dart';
import 'package:jaguar_query_postgresql/jaguar_query_postgresql.dart';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:ulid/ulid.dart';

final String postgreUrl = 'postgres://postgres:dart_jaguar@localhost/example';

main() async {
  // Create and open a connection to mongo
  final adapter = new PgAdapter(postgreUrl);
  await adapter.connect();

  await adapter.dropTable(Sql.drop('posts').onlyIfExists());

  final st = new Create()
      .named('posts')
      .ifNotExists()
      .addStr('id', primary: true, length: 50)
      .addStr('title')
      .addStr('message')
      .addInt('likes');

  await adapter.createTable(st);

  // Create a mongo store
  final store = new QueryDataStore<String, Post, pg.Connection>(
      serializer, "posts", adapter, () => new Ulid().toUuid(),
      idKey: 'id');

  // Start fresh by deleting all previous documents
  await store.removeAll();

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await store.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await store.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await (await store.getAll()).toList();
  print(posts);

  // Get a post by ID
  final post1 = await store.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await store.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await store.updateById(post1Id, post1);

  // Get a changed a post
  final post1Changed = await store.getById(post1Id);
  print(post1Changed);

  // Delete a post
  await store.removeById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await (await store.getAll()).toList();
  print(postsAfterDelete);

  exit(0);
}
