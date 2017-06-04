library jaguar_orm.bean;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';

/// Interface for bean class for a model
abstract class Bean<ModelType> {
  /// The adapter for a particular database
  final Adapter adapter;

  Bean(this.adapter);

  /// The name of the table in database
  String get tableName;

  /// Creates a 'find' query
  FindStatement get finderQ => Sql.find.from(tableName);

  /// Creates a 'delete' query
  DeleteStatement get deleterQ => Sql.delete.from(tableName);

  /// Creates a 'update' query
  UpdateStatement get updaterQ => Sql.update.into(tableName);

  /// Creates a 'insert' query
  InsertStatement get inserterQ => Sql.insert.into(tableName);

  /// Returns a list of rows found by executing [statement]
  Future<ModelType> execFindOne(FindStatement statement) async {
    Map row = await adapter.findOne(statement);
    return fromMap(row);
  }

  /// Returns a list of rows found by executing [statement]
  Future<Stream<ModelType>> execFind(FindStatement statement) async {
    StreamTransformer<Map, ModelType> transformer =
        new StreamTransformer.fromHandlers(
            handleData: (Map row, EventSink<ModelType> sink) {
      sink.add(fromMap(row));
    });
    return (await adapter.find(statement)).transform(transformer);
  }

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<dynamic> execInsert(InsertStatement statement) async {
    return await adapter.insert(statement);
  }

  /// Updates the row and returns the number of rows updated
  Future<int> execUpdate(UpdateStatement statement) async {
    return await adapter.update(statement);
  }

  /// Deletes the requested row
  Future<int> execDelete(DeleteStatement statement) async {
    return await adapter.delete(statement);
  }

  /// Creates the table
  Future<Null> execCreateTable(CreateStatement statement) async {
    return await adapter.createTable(statement);
  }

  Future<Null> execCreateDatabase(CreateDbStatement st) async {
    return await adapter.createDatabase(st);
  }

  /// Creates a model from the map
  ModelType fromMap(Map map);

  /// Creates list of 'set' column from model to be used in update or insert query
  List<SetColumn> toSetColumns(ModelType model);
}
