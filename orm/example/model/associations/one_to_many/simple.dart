import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'simple.jorm.dart';

class Author {
  @primaryKey
  @VarChar(50)
  String id;

  @VarChar(50)
  String name;

  List<Post> posts;

  String toString() => "Author($id, $name, $posts)";
}

class Post {
  @primaryKey
  @VarChar(50)
  String id;

  @VarChar(150)
  String message;

  @BelongsTo(AuthorBean, references: 'id')
  @VarChar(50)
  String authorId;

  String toString() => "Post($id, $authorId, $message)";
}

@GenBean(
  /* TODO
  columns: const {
    'id': const PrimaryKey(length: 50),
    'name': const Column(length: 50)
  },
  */
  relations: const {
    'posts': const HasMany(PostBean),
  },
)
class AuthorBean extends Bean<Author> with _AuthorBean {
  final PostBean postBean;

  AuthorBean(Adapter adapter)
      : postBean = PostBean(adapter),
        super(adapter);

  Future createTable({bool ifNotExists = false}) {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('name', length: 50);
    return adapter.createTable(st);
  }

  String get tableName => 'otm_simple_author';
}

@GenBean(
  /*
  columns: const {
    'id': const PrimaryKey(length: 50),
    'authorId': const ForeignKeyBelongsTo(AuthorBean, length: 50),
    'message': const Column(length: 150),
  },
   */
)
class PostBean extends Bean<Post> with _PostBean {
  AuthorBean _authorBean;
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);

  PostBean(Adapter adapter) : super(adapter);

  Future createTable({bool ifNotExists = false}) {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('message', length: 150)
        .addStr('author_id',
        length: 50, foreignTable: authorBean.tableName, foreignCol: 'id');
    return adapter.createTable(st);
  }

  String get tableName => 'otm_simple_post';
}