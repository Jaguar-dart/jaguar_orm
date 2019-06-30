import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Create author = Sql.create('author')
      .addInt('id', auto: true, isPrimary: true)
      .addStr('name');

  print(composeCreate(author));

  Create post = Sql.create('post')
      .addInt('id', auto: true, isPrimary: true)
      .addInt('authorId', foreign: References('author', 'id'))
      .addStr('message', length: 100)
      .addInt('likes')
      .addInt('dislikes');

  print(composeCreate(post));
}
