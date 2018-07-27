import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

class Post {
  String id;

  String authorId;

  String author;

  String message;

  int likes;

  //TODO DateTime publishedOn;

  bool public;
}

main() {
  Create st = Sql.create('post')
      .addStr('_id', primary: true)
      .addStr('authorId', foreignTable: 'author', foreignCol: '_id')
      .addStr('author')
      .addStr('message', length: 100)
      .addInt('likes');

  print(composeCreate(st));
}
