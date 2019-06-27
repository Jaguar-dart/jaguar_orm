import 'package:jaguar_query/jaguar_query.dart';

abstract class Connection<ConnType> {
  Logger get logger;

  ConnType get connection;

  Future<void> release();

  Future<dynamic> query(String sql);

  Future<dynamic> exec(String sql);

  /// Returns a row found by executing [statement]
  Future<Map> findOne(Find statement);

  /// Returns a list of rows found by executing [statement]
  Future<List<Map>> find(Find statement);

  /// Executes the insert or update statement and returns the primary key of
  /// inserted row
  Future<T> upsert<T>(Upsert statement);

  /// Executes bulk insert or update statement
  Future<void> upsertMany<T>(UpsertMany statement);

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<T> insert<T>(Insert statement);

  /// Executes the insert statement for many element
  Future<void> insertMany<T>(InsertMany statement);

  /// Updates the row and returns the number of rows updated
  Future<int> update(Update statement);

  /// Updates many rows
  Future<void> updateMany(UpdateMany statement);

  /// Deletes the requested row
  Future<int> remove(Remove statement);

  Future<void> alter(Alter statement);

  /// Creates the table
  Future<void> createTable(Create statement);

  /// Create the database
  Future<void> createDatabase(CreateDb statement);

  /// Drops tables from database
  Future<void> dropTable(Drop st);

  /// Drops tables from database
  Future<void> dropDb(DropDb st);

  /// Parses values coming from database into Dart values
  T parseValue<T>(dynamic v);

  Future<void> startTx();

  Future<void> commit();

  Future<void> rollback({String savepoint});

  Future<T> transaction<T>(
      Future<T> Function(Connection<ConnType> conn) task) async {
    await startTx();
    dynamic ret;
    try {
      ret = await task(this);
    } catch (e) {
      await rollback();
      rethrow;
    }
    await commit();
    return ret;
  }
}
