import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:jaguar_query/jaguar_query.dart';

class Author {
  Author();

  int id;

  String name;

  String penName;

  static String tableName = 'author';
}

class Post {
  int id;

  int authorId;

  String message;

  int likes;

  int replies;

  static String tableName = 'post';
}

main() async {
  final PgAdapter adapter =
      new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');
  await adapter.connect();

  await adapter.remove(Sql.remove(Post.tableName));
  await adapter.remove(Sql.remove(Author.tableName));

  {
    final ins = new Insert();
    ins.into(Author.tableName).setValues(<String, dynamic>{
      "_id": '1',
      "name": "Ho",
    });
    await adapter.insert(ins);
  }

  {
    final ins = new Insert();
    ins.into(Post.tableName).setValues(<String, dynamic>{
      "_id": 9,
      "authorid": 1,
      "message": "Message 9 from 3!",
      "likes": 13,
    });
    await adapter.insert(ins);
  }

  {
    final st = Sql
        .find(Post.tableName)
        .fullJoin(Author.tableName)
        .joinOn(eq('author._id', 1))
        .where(eqCol('post.authorid', col('_id', 'author')));

    List<Map> res = await (await adapter.find(st)).toList();
    print(res);
  }

  exit(0);
}
