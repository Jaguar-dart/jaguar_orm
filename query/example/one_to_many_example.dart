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

  static Post fromMap(Map map) => Post()
    ..id = map['_id']
    ..authorId = map['authorid']
    ..message = map['message']
    ..likes = map['likes'];
}

PgConn conn;

Future<void> dropTables() async {
  final st = Drop(['post', 'author'], onlyIfExists: true);
  print(composeDrop(st));
  await conn.dropTable(st);
}

Future<void> createTables() async {
  {
    await Sql.create('author', ifNotExists: true)
        .addInt('_id', isPrimary: true, auto: true)
        .addStr('name', length: 100)
        .exec(conn);
  }

  {
    await Sql.create('post', ifNotExists: true)
        .addInt('_id', isPrimary: true, auto: true)
        .addInt('authorId', foreign: References('author', '_id'))
        .addStr('message', length: 100)
        .addInt('likes')
        .exec(conn);
  }
}

Future<int> insertAuthor(String name) =>
    Sql.insert('author').id('_id').setString('name', 'teja').exec<int>(conn);

Future<List<Author>> getAuthors() async =>
    (await Sql.find('author').exec(conn).many())
        .map((Map map) => Author()
          ..id = map['_id']
          ..name = map['name'])
        .toList();

Future<Author> getAuthorId(int id) async {
  Find st = Sql.find('author').where(Field('_id').eq(id));
  Map map = await conn.findOne(st);
  return Author()
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
  await conn.remove(st);
}

Future<int> insertPost(int authorId, String message, int likes) =>
    Sql.insert('post')
        .id('_id')
        .setInt('authorId', authorId)
        .setString('message', message)
        .setInt('likes', likes)
        .exec(conn);

Future<List<Post>> getPosts() =>
    Sql.find('post').exec(conn).manyTo(Post.fromMap);

Future<Post> getPostById(int id) =>
    Sql.find('post').where(Field('_id').eq(id)).exec(conn).oneTo(Post.fromMap);

Future<Post> getPostByIdRelated(int id) async {
  Find st = Sql.find('post')
      .sel('post.*')
      .selMany(['_id', 'name'], table: 'author')
      .innerJoin('author', 'author')
      .joinOn(col('post.authorId').eq(col('author._id')))
      .where(col('post._id').eq(id));
  Map map = await conn.findOne(st);

  final post = Post()
    ..id = map['_id']
    ..authorId = map['authorId']
    ..message = map['message']
    ..likes = map['likes']
    ..author = (Author()
      ..id = map['authorid']
      ..name = map['name']);
  return post;
}

Future<List<Post>> getPostsByAuthorId(int authorId) => Sql.find('post')
    .where(Field('authorId').eq(authorId))
    .exec(conn)
    .manyTo(Post.fromMap);

Future<void> removePosts() async {
  Remove st = Sql.remove('post');
  await conn.remove(st);
}

Future<void> getRelatedPost(Post post) async {
  post.author = await getAuthorId(post.authorId);
}

main() async {
  conn = await PgConn.open('postgres',
      username: 'postgres', password: 'dart_jaguar');
  ;

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
