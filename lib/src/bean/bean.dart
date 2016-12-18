library jaguar_orm.bean;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';

import 'package:jaguar_orm/src/adapter/adapter.dart';

abstract class Bean<ModelType> {
  final Adapter adapter;

  Bean(this.adapter);

  String get tableName;

  FindStatement get finderQ => Sql.find.from(tableName);

  DeleteStatement get deleterQ => Sql.delete.from(tableName);

  UpdateStatement get updaterQ => Sql.update.into(tableName);

  InsertStatement get inserterQ => Sql.insert.into(tableName);

  /// Returns a list of rows found by executing [statement]
  Future<ModelType> execFindOne(FindStatement statement) async {
    Map row = await adapter.findOne(statement);
    return fromMap(row);
  }

  /// Returns a list of rows found by executing [statement]
  Future<Stream<ModelType>> execFind(FindStatement statement) async {
    StreamTransformer transformer = new StreamTransformer.fromHandlers(
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
  Future<Null> execCreateTable(CreateTableStatement statement) async {
    return await adapter.createTable(statement);
  }

  ModelType fromMap(Map map);

  List<SetColumn> toSetColumns(ModelType model);
}
