import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'simple.jorm.dart';

class Author {
  @primaryKey
  @Str(length: 50)
  String id;

  @Str(length: 50)
  String name;

  @HasMany(PostBean)
  List<Post> posts;

  String toString() => "Author($id, $name, $posts)";
}

class Post {
  @primaryKey
  @Str(length: 50)
  String id;

  @Str(length: 150)
  String message;

  @BelongsTo.many(AuthorBean, references: 'id')
  @Str(length: 50)
  String authorId;

  String toString() => "Post($id, $authorId, $message)";
}

@GenBean()
class AuthorBean extends Bean<Author> with _AuthorBean {
  final PostBean postBean;

  AuthorBean(Adapter adapter)
      : postBean = PostBean(adapter),
        super(adapter);

  Future createTable({bool ifNotExists = false}) {
    final st = Sql.create(tableName)
        .addStr('id', isPrimary: true, length: 50)
        .addStr('name', length: 50);
    return adapter.createTable(st);
  }

  String get tableName => 'otm_simple_author';
}

@GenBean()
class PostBean extends Bean<Post> with _PostBean {
  AuthorBean _authorBean;
  AuthorBean get authorBean => _authorBean ??= AuthorBean(adapter);

  PostBean(Adapter adapter) : super(adapter);

  Future createTable({bool ifNotExists = false}) {
    final st = Sql.create(tableName)
        .addStr('id', isPrimary: true, length: 50)
        .addStr('message', length: 150)
        .addStr('author_id',
            length: 50, foreign: References(authorBean.tableName, 'id'));
    return adapter.createTable(st);
  }

  String get tableName => 'otm_simple_post';
}
