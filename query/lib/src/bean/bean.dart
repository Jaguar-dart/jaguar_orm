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

  /// Creates a 'updateMany' query
  UpdateMany get updaters => Sql.updateMany(tableName);

  /// Creates a 'upsert' query
  Upsert get upserter => Sql.upsert(tableName);

  /// Creates a 'upsertMany' query
  UpsertMany get upserters => Sql.upsertMany(tableName);

  /// Creates a 'insert' query
  Insert get inserter => Sql.insert(tableName);

  /// Creates a 'insertMany' query
  InsertMany get inserters => Sql.insertMany(tableName);

  /// Returns one row found by executing [statement]
  Future<ModelType?> findOne(Find statement) async {
    Map<String, dynamic>? row = await adapter.findOne(statement);
    if (row != null) return fromMap(row);
    return null;
  }

  /// Returns a list of rows found by executing [statement]
  Future<List<ModelType>> findMany(Find statement) async {
    return (await adapter.find(statement)).map(fromMap).toList();
  }

  /// Drops the table if it already exists
  Future<void> drop() {
    final st = Sql.drop(tableName, onlyIfExists: true);
    return adapter.dropTable(st);
  }

  /// Fetches all rows in the table/document
  Future<List<ModelType>> getAll() => findMany(finder);

  /// Removes all rows in table/document
  Future<int> removeAll() => adapter.remove(remover);

  Future<ModelType?> findOneWhere(
      /* Expression | ExpressionMaker<ModelType> */ exp) async {
    final Find find = finder.where(exp);
    return findOne(find);
  }

  Future<List<ModelType>> findWhere(
      /* Expression | ExpressionMaker<ModelType> */ where) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    return await findMany(finder.where(where));
  }

  Future<int> removeWhere(
      /* Expression | ExpressionMaker<ModelType> */ where) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    return adapter.remove(remover.where(where));
  }

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
    return adapter.update(st);
  }

  //>>    Implement these  <<//

  /// Map of fields in the table
  Map<String, Field> get fields;

  /// Creates a model from the map
  ModelType fromMap(Map map);

  /// Creates list of 'set' column from model to be used in update or insert
  /// query
  List<SetColumn> toSetColumns(ModelType model,
      {bool update = false, Set<String> only});
}
