library example.data_store.simple;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_query_sqljocky_data_store/jaguar_query_sqljocky_data_store.dart';
import '../common/post/post.dart';
import 'package:jaguar/jaguar.dart' hide Post;
import 'package:jaguar_data_store/client.dart';
import 'package:http/http.dart' as http;
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_sqljocky/jaguar_query_sqljocky.dart';
import 'package:ulid/ulid.dart';

const DbConnectionInfo connInfo =
    const DbConnectionInfo('testing', 'root', 'dart_jaguar');

Future<Null> createDb() async {
  final adapter =
      new SqlJockyAdapter('testing', username: 'root', password: 'dart_jaguar');
  await adapter.connect();

  {
    final Drop st = Sql.drop('posts');
    await adapter.dropTable(st);
  }

  {
    final Create st = Sql
        .create('posts')
        .addStr('id', primary: true, length: 50)
        .addStr('title', length: 100)
        .addStr('message', length: 1000)
        .addInt('likes');
    await adapter.createTable(st);
  }
}

@Api(path: '/api')
class ExampleApi {
  @IncludeApi(path: '/post')
  final SqlJockyResource s = new SqlJockyResource<String, Post>(
      connInfo, 'posts', serializer, serializer, () => new Ulid().toUuid(),
      idKey: 'id');
}

Future<Null> server() async {
  await createDb();
  Jaguar server = new Jaguar();
  server.addApiReflected(new ExampleApi());
  await server.serve();
}

const String authority = 'http://localhost:8080';

Future<Null> client() async {
  final client = new http.Client();
  final ResourceClient<String, Post> rC = new ResourceClient<String, Post>(
      client, serializer,
      authority: authority, path: '/api/post');

  // Start fresh by deleting all previous documents
  await rC.removeAll();

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await rC.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await rC.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await rC.getAll();
  print(posts);

  // Get a post by ID
  final post1 = await rC.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await rC.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await rC.update(post1);

  // Get a changed a post
  final post1Changed = await rC.getById(post1Id);
  print(post1Changed);

  // Delete a post
  await rC.removeById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await rC.getAll();
  print(postsAfterDelete);
}

main() async {
  await server();
  await client();
  exit(0);
}
