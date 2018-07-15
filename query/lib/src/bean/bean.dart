library jaguar_query.bean;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';

typedef Expression ExpressionMaker<MT>(Bean<MT> bean);

/// Interface for bean class for a model
abstract class Bean<ModelType> {
  /// The adapter for a particular database
  final Adapter adapter;

  Bean(this.adapter);

  /// The name of the table in database
  String get tableName;

  /// Creates a 'find' query
  Find get finder => Sql.find(tableName);

  /// Creates a 'delete' query
  Remove get remover => Sql.remove(tableName);

  /// Creates a 'update' query
  Update get updater => Sql.update(tableName);

  /// Creates a 'insert' query
  Insert get inserter => Sql.insert(tableName);

  /// Returns a list of rows found by executing [statement]
  Future<ModelType> execFindOne(Find statement) async {
    Map row = await adapter.findOne(statement);
    return fromMap(row);
  }

  /// Returns a list of rows found by executing [statement]
  Future<Stream<ModelType>> execFind(Find statement) async {
    StreamTransformer<Map, ModelType> transformer =
        new StreamTransformer.fromHandlers(
            handleData: (Map row, EventSink<ModelType> sink) {
      sink.add(fromMap(row));
    });
    return (await adapter.find(statement)).transform(transformer);
  }

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<dynamic> execInsert(Insert statement) => adapter.insert(statement);

  /// Updates the row and returns the number of rows updated
  Future<int> execUpdate(Update statement) => adapter.update(statement);

  /// Deletes the requested row
  Future<int> execRemove(Remove statement) => adapter.remove(statement);

  /// Creates the table
  Future<void> execCreateTable(Create statement) =>
      adapter.createTable(statement);

  /// Drops the table if it already exists
  Future<void> drop() {
    final st = Sql.drop(tableName).onlyIfExists();
    return adapter.dropTable(st);
  }

  /// Creates database
  Future<void> execCreateDatabase(CreateDb st) => adapter.createDatabase(st);

  /// Fetches all rows in the table/document
  Future<List<ModelType>> getAll() async {
    final stream = await execFind(finder);
    return stream.toList();
  }

  /// Removes all rows in table/document
  Future<int> removeAll() async {
    return await adapter.remove(remover);
  }

  /// Creates a model from the map
  ModelType fromMap(Map map);

  /// Creates list of 'set' column from model to be used in update or insert
  /// query
  List<SetColumn> toSetColumns(ModelType model,
      {bool update = false, Set<String> only});

  Future<ModelType> findOneWhere(
      /* Expression | ExpressionMaker<ModelType> */ exp) async {
    final Find find = finder.where(exp);
    return execFindOne(find);
  }

  Future<List<ModelType>> findWhere(
      /* Expression | ExpressionMaker<ModelType> */ where) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    final Find find = finder.where(where);
    return await (await execFind(find)).toList();
  }

  Future<int> removeWhere(
      /* Expression | ExpressionMaker<ModelType> */ where) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    return execRemove(remover.where(where));
  }

  Map<String, Field> get fields;

  Future<int> updateFields(
      /* Expression | ExpressionMaker<ModelType> */ where,
      Map<String, dynamic> values) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    final st = updater.where(where);
    for (String key in values.keys) {
      final f = fields[key];
      if (f == null) throw Exception('Unknown field!');
      st.set(f, values[key]);
    }
    return execUpdate(st);
  }
}
