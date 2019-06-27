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
  final connection = await PgConn.open('example',
      username: 'dart_jaguar', password: 'dart_jaguar');

  await Sql.drop(Post.tableName).exec(connection);
  await Sql.drop(Author.tableName).exec(connection);

  await Sql.create(Author.tableName)
      .addInt('id', isPrimary: true)
      .addStr('name', length: 50)
      .exec(connection);

  await Sql.create(Post.tableName)
      .addInt('id', isPrimary: true)
      .addInt('authorId', foreign: References('author', 'id'))
      .addStr('message', length: 150)
      .addInt('likes')
      .exec(connection);

  await Sql.insert(Author.tableName).setValues(<String, dynamic>{
    "id": '1',
    "name": "Ho",
  }).exec(connection);

  await Sql.insert(Post.tableName).setValues(<String, dynamic>{
    "id": 9,
    "authorid": 1,
    "message": "Message 9 from 3!",
    "likes": 13,
  }).exec(connection);

  final data = await Sql.find(Post.tableName)
      .innerJoin(Author.tableName)
      .joinOn(Field.inTable('post', 'authorid').eqF('id', table: 'author'))
      .where(eq('author.id', 1))
      .exec(connection)
      .one();
  print(data);

  exit(0);
}
