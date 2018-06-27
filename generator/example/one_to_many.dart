library example.one_to_many;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'one_to_many.jorm.dart';

class Author {
  String id;

  String name;

  List<Post> posts;

  static const String tableName = 'author';

  String toString() => "Author($id, $name, $posts)";
}

class Post {
  @PrimaryKey()
  String id;

  String message;

  @BelongsTo(AuthorBean)
  String authorId;

  static String tableName = 'post';

  String toString() => "Post($id, $authorId, $message)";
}

@GenBean(
  columns: const {
    'id': const PrimaryKey(),
  },
  relations: const {
    'posts': const HasMany(PostBean),
  },
)
class AuthorBean extends Bean<Author> with _AuthorBean {
  final PostBean postBean;

  AuthorBean(Adapter adapter)
      : postBean = new PostBean(adapter),
        super(adapter);

  Future createTable() {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('name', length: 50);
    return execCreateTable(st);
  }
}

@GenBean()
class PostBean extends Bean<Post> with _PostBean {
  PostBean(Adapter adapter) : super(adapter);

  Future createTable() {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('message', length: 150)
        .addStr('author_id',
            length: 50, foreignTable: Author.tableName, foreignCol: 'id');
    return execCreateTable(st);
  }
}
