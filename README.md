# jaguar_orm

Source generated ORM for SQL/NoSQL

# Example

```dart
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'basic_main.g.dart';

class Post {
  @PrimaryKey()
  String id;

  String author;

  String message;

  int likes;

  int replies;

  static String tableName = 'posts';
}

@GenBean()
class PostsBean extends _PostsBean implements Bean<Post> {
  PostsBean(Adapter adapter) : super(adapter);

  @Find()
  Future<Stream<Post>> findByAuthor(@WhereEq() String author) =>
      super.findByAuthor(author);

  @Update()
  Future updateByAuthor(@WhereEq() String author, @SetField() int replies) =>
      super.updateByAuthor(author, replies);

  @Delete()
  Future deleteByAuthor(@WhereEq() String author) =>
      super.deleteByAuthor(author);
}
```