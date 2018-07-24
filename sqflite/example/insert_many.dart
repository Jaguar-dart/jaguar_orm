// Copyright (c) 2016, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'dart:async';

import 'package:jaguar_query_sqflite/jaguar_query_sqflite.dart';
import 'package:sqflite/sqflite.dart';

/// The adapter
SqfliteAdapter _adapter;

// The model
class Post {
  Post();

  Post.make(this.id, this.msg, this.author);

  int id;

  String msg;

  String author;

  String toString() => '$id $msg $author';
}

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
    final st = new Create().named(tableName).ifNotExists().addInt('_id', primary: true, autoIncrement: true).addNullStr('msg').addNullStr('author');

    await _adapter.createTable(st);
  }

  List<SetColumn> toSetColumns(Post model, {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(id.set(model.id));
      ret.add(msg.set(model.msg));
      ret.add(author.set(model.author));
    } else {
      if (only.contains(id.name)) ret.add(id.set(model.id));
      if (only.contains(msg.name)) ret.add(msg.set(model.msg));
      if (only.contains(author.name)) ret.add(author.set(model.author));
    }
  }

  /// Inserts many posts into table
  Future insertMany(List<Post> posts) async {
    InsertMany inserter = Sql.insertMany(tableName).bulk(posts.map((post) => toSetColumns(post)));

    return await _adapter.insertMany(inserter);
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
  Future<int> delete(int id) async {
    Remove deleter = new Remove()..from(tableName);

    deleter.where(this.id.eq(id));

    return await _adapter.remove(deleter);
  }

  /// Deletes all posts
  Future<int> deleteAll() async {
    Remove deleter = new Remove()..from(tableName);

    return await _adapter.remove(deleter);
  }
}

main() async {
  _adapter = new SqfliteAdapter(await getDatabasesPath());

  // Connect
  await _adapter.connect();

  final bean = new PostBean();

  await _adapter.dropTable(Sql.drop(bean.tableName).onlyIfExists());

  await bean.createTable();

  // Delete all
  await bean.deleteAll();

  // Insert some posts
  await bean.insertMany([
    new Post.make(1, 'Whatever 1', 'mark'),
    new Post.make(2, 'Whatever 2', 'bob'),
  ]);

  // Find
  print('Fetching all:');
  print('-------------');
  List<Post> post = await bean.findAll();
  print(post);

  // Close connection
  await _adapter.close();
}
