import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:jaguar_query/jaguar_query.dart';

class Author {
  Author();

  int id;

  String name;

  static String tableName = 'author';
}

class Post {
  int id;

  int authorId;

  String message;

  int likes;

  static String tableName = 'post';
}

main() async {
  final PgAdapter adapter =
      new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');
  await adapter.connect();

  await Sql.drop(Post.tableName).exec(adapter);
  await Sql.drop(Author.tableName).exec(adapter);

  await Sql.create(Author.tableName)
      .addPrimaryInt('id')
      .addStr('name', length: 50)
      .exec(adapter);

  await Sql.create(Post.tableName)
      .addPrimaryInt('id')
      .addInt('authorId', foreignTable: 'author', foreignCol: 'id')
      .addStr('message', length: 150)
      .addInt('likes')
      .exec(adapter);

  await Sql.insert(Author.tableName).setValues(<String, dynamic>{
    "id": '1',
    "name": "Ho",
  }).exec(adapter);

  await Sql.insert(Post.tableName).setValues(<String, dynamic>{
    "id": 9,
    "authorid": 1,
    "message": "Message 9 from 3!",
    "likes": 13,
  }).exec(adapter);

  final data = await Sql.find(Post.tableName)
      .innerJoin(Author.tableName)
      .joinOn(Field.inTable('post', 'authorid').eqF('id', table: 'author'))
      .where(eq('author.id', 1))
      .exec(adapter)
      .one();
  print(data);

  exit(0);
}
