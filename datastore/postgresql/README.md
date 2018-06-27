# jaguar_query_postgresql_data_store

Data store implementation for PostgreSQL

# Examples

## Data store

```dart
final String postgreUrl = 'postgres://postgres:dart_jaguar@localhost/example';

main() async {
  // Create and open a connection to mongo
  final adapter = new PgAdapter(postgreUrl);
  await adapter.connect();

  final st = new Create()
      .named('posts')
      .ifNotExists()
      .addInt('_id', primary: true, autoIncrement: true)
      .addStr('title')
      .addStr('message')
      .addInt('likes');

  await adapter.createTable(st);

  // Create a mongo store
  final store = new QueryDataStore<String, Post, pg.Connection>(
      serializer, "posts", adapter, () => new Ulid().toUuid(),
      idKey: 'id');

  // Start fresh by deleting all previous documents
  await store.deleteAll();

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await store.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await store.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await (await store.getAll()).toList();
  print(posts);

  // Get a post by ID
  final post1 = await store.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await store.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await store.updateById(post1Id, post1);

  // Get a changed a post
  final post1Changed = await store.getById(post1Id);
  print(post1Changed);

  // Delete a post
  await store.deleteById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await (await store.getAll()).toList();
  print(postsAfterDelete);

  exit(0);
}
```

## Resource

```dart
final String postgreUrl = 'postgres://postgres:dart_jaguar@localhost/example';

Future<Null> createDb() async {
  PgAdapter adapter = new PgAdapter(postgreUrl);
  await adapter.connect();

  {
    final Drop st = Sql.drop('posts');
    await adapter.dropTable(st);
  }

  {
    final Create st = Sql
        .create('posts')
        .addStr('id', primary: true, length: 50)
        .addStr('title', length: 100)
        .addStr('message', length: 1000)
        .addInt('likes');
    await adapter.createTable(st);
  }
}

@Api(path: '/api')
class ExampleApi {
  @IncludeApi(path: '/post')
  final PostgreResource s = new PostgreResource<String, Post>(
      postgreUrl, 'posts', serializer, serializer, () => new Ulid().toUuid(),
      idKey: 'id');
}

Future<Null> server() async {
  //TODO await createDb();
  Jaguar server = new Jaguar();
  server.addApiReflected(new ExampleApi());
  await server.serve();
}

const String authority = 'http://localhost:8080';

Future<Null> client() async {
  final client = new http.Client();
  final ResourceClient<String, Post> rC = new ResourceClient<String, Post>(
      client, serializer,
      authority: authority, path: '/api/post');

  // Start fresh by deleting all previous documents
  await rC.deleteAll();

  // Insert a post and receive the ID of the inserted document
  final String post1Id =
      await rC.insert(new Post.buildNoId("title1", "message1", 5));
  print(post1Id);

  // Insert another post and receive the ID of the inserted document
  final String post2Id =
      await rC.insert(new Post.buildNoId("title2", "message2", 10));
  print(post2Id);

  // Get all posts in collection
  final List<Post> posts = await rC.getAll();
  print(posts);

  // Get a post by ID
  final post1 = await rC.getById(post1Id);
  print(post1);

  // Get another post by ID
  final post2 = await rC.getById(post2Id);
  print(post2);

  // Update a post
  post1.likes = 25;
  await rC.update(post1);

  // Get a changed a post
  final post1Changed = await rC.getById(post1Id);
  print(post1Changed);

  // Delete a post
  await rC.deleteById(post2Id);

  //Posts after delete
  final List<Post> postsAfterDelete = await rC.getAll();
  print(postsAfterDelete);
}

main() async {
  await server();
  await client();
  exit(0);
}
```