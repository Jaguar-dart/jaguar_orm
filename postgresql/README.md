# jaguar_query_postgresql

postgresql adapter for jaguar_orm

## Usage

A simple usage example:

```dart
import 'dart:async';
import 'package:jaguar_orm_postgresql/jaguar_orm_postgresql.dart';

// The model
class Post {
  Post();

  Post.make(this.id, this.msg, this.author);

  int id;

  String msg;

  String author;

  String toString() => '$id $msg $author';
}

/// The adapter
PgAdapter _adapter =
    new PgAdapter('postgres://postgres:dart_jaguar@localhost/postgres');

/// The bean
class PostBean {
  /// Field DSL for id column
  final IntField id = new IntField('_id');

  /// Field DSL for msg column
  final StrField msg = new StrField('msg');

  /// Field DSL for author column
  final StrField author = new StrField('author');

  /// Table name for the model this bean manages
  String get tableName => 'posts';

  /// Inserts a new post into table
  Future insert(Post post) async {
    InsertStatement inserter = new InsertStatement()..into(tableName);

    inserter.set(id.set(post.id));
    inserter.set(msg.set(post.msg));
    inserter.set(author.set(post.author));

    await _adapter.insert(inserter);
  }

  /// Updates a post
  Future update(int id, String author) async {
    UpdateStatement updater = new UpdateStatement()..into(tableName);
    updater.where(this.id.eq(id));

    updater.set(this.author.set(author));

    await _adapter.update(updater);
  }

  /// Finds one post by [id]
  Future<Post> findOne(int id) async {
    FindStatement updater = new FindStatement()..from(tableName);

    updater.where(this.id.eq(id));

    Map map = await _adapter.findOne(updater);

    Post post = new Post();
    post.id = map['_id'];
    post.msg = map['msg'];
    post.author = map['author'];

    return post;
  }

  /// Finds all posts
  Future<List<Post>> findAll() async {
    FindStatement finder = new FindStatement()..from(tableName);

    List<Map> maps = await (await _adapter.find(finder)).toList();

    List<Post> posts = new List<Post>();

    for(Map map in maps) {
      Post post = new Post();

      post.id = map['_id'];
      post.msg = map['msg'];
      post.author = map['author'];

      posts.add(post);
    }

    return posts;
  }

  /// Deletes a post by [id]
  Future delete(int id) async {
    DeleteStatement deleter = new DeleteStatement()..from(tableName);

    deleter.where(this.id.eq(id));

    await _adapter.delete(deleter);
  }

  /// Deletes all posts
  Future deleteAll() async {
    DeleteStatement deleter = new DeleteStatement()..from(tableName);

    await _adapter.delete(deleter);
  }
}

main() async {
  // Connect
  await _adapter.connect();

  PostBean bean = new PostBean();

  // Delete all
  await bean.deleteAll();

  // Insert some posts
  await bean.insert(new Post.make(1, 'Whatever 1', 'mark'));
  await bean.insert(new Post.make(2, 'Whatever 2', 'bob'));

  // Find one post
  Post post = await bean.findOne(1);
  print(post);

  // Find all posts
  List<Post> posts = await bean.findAll();
  print(posts);

  // Update a post
  await bean.update(1, 'rowling');

  // Check that the post is updated
  post = await bean.findOne(1);
  print(post);

  // Delete some posts
  await bean.delete(1);
  await bean.delete(2);

  // Find a post when none exists
  try {
    post = await bean.findOne(1);
    print(post);
  } on JaguarOrmException catch(e) {
    print(e);
  }

  // Close connection
  await _adapter.close();
}
```
