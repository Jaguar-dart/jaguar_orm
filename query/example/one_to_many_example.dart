import 'dart:io';
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import 'package:jaguar_query_postgres/composer.dart';

class Author {
  int id;

  String name;

  List<Post> posts;

  static String tableName = 'authors';

  String toString() => "Author($id, $name, $posts)";
}

class Post {
  int id;

  int authorId;

  Author author;

  String message;

  int likes;

  String toString() => "Post($id, $authorId, $author, $message, $likes)";

  Map<String, dynamic> toMap(Post model) => {
        "_id": model.id,
        "authorId": model.authorId,
        "message": model.message,
        "likes": model.likes,
      };

  static Post fromMap(Map map) => new Post()
    ..id = map['_id']
    ..authorId = map['authorid']
    ..message = map['message']
    ..likes = map['likes'];
}

final PgAdapter adapter =
    new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

Future<void> dropTables() async {
  final st = new Drop(['post', 'author'], onlyIfExists: true);
  print(composeDrop(st));
  await adapter.dropTable(st);
}

Future<void> createTables() async {
  {
    await Sql.create('author', ifNotExists: true)
        .addInt('_id', primary: true, autoIncrement: true)
        .addStr('name', length: 100)
        .exec(adapter);
  }

  {
    await Sql.create('post', ifNotExists: true)
        .addInt('_id', primary: true, autoIncrement: true)
        .addInt('authorId', foreignTable: 'author', foreignCol: '_id')
        .addStr('message', length: 100)
        .addInt('likes')
        .exec(adapter);
  }
}

Future<int> insertAuthor(String name) =>
    Sql.insert('author').id('_id').setString('name', 'teja').exec<int>(adapter);

Future<List<Author>> getAuthors() async =>
    (await Sql.find('author').exec(adapter).many())
        .map((Map map) => new Author()
          ..id = map['_id']
          ..name = map['name'])
        .toList();

Future<Author> getAuthorId(int id) async {
  Find st = Sql.find('author').where(Field('_id').eq(id));
  Map map = await adapter.findOne(st);
  return new Author()
    ..id = map['_id']
    ..name = map['name'];
}

/* TODO
Future<Author> getAuthorIdWithRelated(int id) async {
  FindStatement st = Sql.find.from('author').where(col('_id').eq(id));
  Map map = await adapter.findOne(st);
  return new Author()
    ..id = map['_id']
    ..name = map['name'];
}
*/

Future<void> removeAuthors() async {
  Remove st = Sql.remove('author');
  await adapter.remove(st);
}

Future<int> insertPost(int authorId, String message, int likes) =>
    Sql.insert('post')
        .id('_id')
        .setInt('authorId', authorId)
        .setString('message', message)
        .setInt('likes', likes)
        .exec(adapter);

Future<List<Post>> getPosts() =>
    Sql.find('post').exec(adapter).manyTo(Post.fromMap);

Future<Post> getPostById(int id) => Sql.find('post')
    .where(Field('_id').eq(id))
    .exec(adapter)
    .oneTo(Post.fromMap);

Future<Post> getPostByIdRelated(int id) async {
  Find st = Sql.find('post')
      .sel('post.*')
      .selMany(['_id', 'name'], table: 'author')
      .innerJoin('author', 'author')
      .joinOn(Field.inTable('post', 'authorId')
          .eqField(Field.inTable('author', '_id')))
      .where(Field.inTable('post', '_id').eq(id));
  Map map = await adapter.findOne(st);

  final post = new Post()
    ..id = map['_id']
    ..authorId = map['authorId']
    ..message = map['message']
    ..likes = map['likes']
    ..author = (new Author()
      ..id = map['authorid']
      ..name = map['name']);
  return post;
}

Future<List<Post>> getPostsByAuthorId(int authorId) => Sql.find('post')
    .where(Field('authorId').eq(authorId))
    .exec(adapter)
    .manyTo(Post.fromMap);

Future<void> removePosts() async {
  Remove st = Sql.remove('post');
  await adapter.remove(st);
}

Future<void> getRelatedPost(Post post) async {
  post.author = await getAuthorId(post.authorId);
}

main() async {
  await adapter.connect();

  await dropTables();

  await createTables();

  await removePosts();
  await removeAuthors();

  final int author1Id = await insertAuthor('Teja');

  print(await getAuthors());

  final int post1Id = await insertPost(author1Id, 'Message 1', 10);
  await insertPost(author1Id, 'Message 2', 15);

  print(await getPosts());

  {
    Post post = await getPostByIdRelated(post1Id);
    print(post);
  }

  //Belongs to relationship
  {
    Post post = await getPostById(post1Id);
    await getRelatedPost(post);

    print(post);
  }

  //Has many relationship
  {
    Author author = await getAuthorId(author1Id);
    author.posts = await getPostsByAuthorId(author.id);
    print(author);
  }

  exit(0);
}
