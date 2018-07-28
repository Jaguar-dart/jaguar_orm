# jaguar_query_sqflite

[`sqflite`](https://pub.dartlang.org/packages/sqflite) adapter for `jaguar_query`
and `jaguar_orm`.

## Usage

A simple usage example:

```dart
import 'dart:io';
import 'dart:async';
import 'package:sqflite/sqflite.dart';
import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';

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
SqfliteAdapter _adapter;

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

  Future<Null> createTable() async {
    final st = new Create()
        .named(tableName)
        .ifNotExists()
        .addNullInt('_id', primary: true)
        .addNullStr('msg')
        .addNullStr('author');

    await _adapter.createTable(st);
  }

  /// Inserts a new post into table
  Future insert(Post post) async {
    Insert inserter = new Insert()..into(tableName);

    inserter.set(id, post.id);
    inserter.set(msg, post.msg);
    inserter.set(author, post.author);

    return await _adapter.insert(inserter);
  }

  /// Updates a post
  Future<int> update(int id, String author) async {
    Update updater = new Update()..into(tableName);
    updater.where(this.id.eq(id));

    updater.set(this.author, author);

    return await _adapter.update(updater);
  }

  /// Finds one post by [id]
  Future<Post> findOne(int id) async {
    Find updater = new Find()..from(tableName);

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
    Find finder = new Find()..from(tableName);

    List<Map> maps = await (await _adapter.find(finder)).toList();

    List<Post> posts = new List<Post>();

    for (Map map in maps) {
      Post post = new Post();

      post.id = map['_id'];
      post.msg = map['msg'];
      post.author = map['author'];

      posts.add(post);
    }

    return posts;
  }

  /// Deletes a post by [id]
  Future<int> remove(int id) async {
    Remove deleter = new Remove()..from(tableName);

    deleter.where(this.id.eq(id));

    return await _adapter.remove(deleter);
  }

  /// Deletes all posts
  Future<int> removeAll() async {
    Remove deleter = new Remove()..from(tableName);

    return await _adapter.remove(deleter);
  }
}

main() async {
  _adapter = new SqfliteAdapter(await getDatabasesPath());

  // Connect
  await _adapter.connect();

  final bean = new PostBean();

  await bean.createTable();

  // Delete all
  await bean.removeAll();

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
  await bean.remove(1);
  await bean.remove(2);

  // Find a post when none exists
  try {
    post = await bean.findOne(1);
    print(post);
  } on JaguarOrmException catch (e) {
    print(e);
  }

  // Close connection
  await _adapter.close();

  exit(0);
}
```

For more usage don't hesitate to check this example https://github.com/jaguar-orm/sqflite 
