library jaguar_orm.bean;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';

abstract class Adapter<PrimaryKeyType> {
  Future connect();

  /// Returns a list of rows found by executing [statement]
  Future<Map> findOne(FindStatement statement);

  /// Returns a list of rows found by executing [statement]
  Future<List<Map>> find(FindStatement statement);

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<PrimaryKeyType> insert(InsertStatement statement);

  /// Updates the row and returns the number of rows updated
  Future<int> update(UpdateStatement statement);

  /// Deletes the requested row
  Future<int> delete(DeleteStatement statement);

  /// Creates the table
  Future<Null> createTable(CreateTableStatement statement);
}

abstract class Bean<ModelType, PrimaryKeyType> {
  final Adapter<PrimaryKeyType> adapter;

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
  Future<List<ModelType>> execFind(FindStatement statement) async {
    List<Map> rows = await adapter.find(statement);
    return rows.map((Map map) => fromMap(map)).toList();
  }

  /// Executes the insert statement and returns the primary key of
  /// inserted row
  Future<PrimaryKeyType> execInsert(InsertStatement statement) async {
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
}