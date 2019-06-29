import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

class Post {
  String id;

  String authorId;

  String author;

  String message;

  int likes;

  DateTime publishedOn; // TODO

  bool public;
}

main() {
  Create st = Sql.create('post')
      .addStr('_id', isPrimary: true)
      .addStr('authorId', foreign: References('author', '_id'))
      .addStr('author')
      .addStr('message', length: 100)
      .addInt('likes');

  print(composeCreate(st));
}
