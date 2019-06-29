library jaguar_query.bean;

import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';

typedef ExpressionMaker<MT> = Expression Function(Bean<MT> bean);

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
  UpdateMany get updateser => Sql.updateMany(tableName);

  /// Creates a 'upsert' query
  Upsert get upserter => Sql.upsert(tableName);

  /// Creates a 'upsertMany' query
  UpsertMany get upsertser => Sql.upsertMany(tableName);

  /// Creates a 'insert' query
  Insert get inserter => Sql.insert(tableName);

  /// Creates a 'insertMany' query
  InsertMany get insertser => Sql.insertMany(tableName);

  /// Returns one row found by executing [statement]
  Future<ModelType> findOne(Find statement, {Connection withConn}) async {
    Map row = await adapter.findOne(statement, withConn: withConn);
    if (row != null) return fromMap(row);
    return null;
  }

  /// Returns a list of rows found by executing [statement]
  Future<List<ModelType>> findMany(Find statement,
      {Connection withConn}) async {
    return (await adapter.find(statement, withConn: withConn))
        .map(fromMap)
        .toList();
  }

  /// Drops the table if it already exists
  Future<void> drop({Connection withConn}) {
    final st = Sql.drop(tableName, onlyIfExists: true);
    return adapter.dropTable(st, withConn: withConn);
  }

  /// Fetches all rows in the table/document
  Future<List<ModelType>> getAll({Connection withConn}) =>
      findMany(finder, withConn: withConn);

  /// Removes all rows in table/document
  Future<int> removeAll({Connection withConn}) =>
      adapter.remove(remover, withConn: withConn);

  Future<ModelType> findOneWhere(
      /* Expression | ExpressionMaker<ModelType> */ exp,
      {Connection withConn}) async {
    final Find find = finder.where(exp);
    return findOne(find, withConn: withConn);
  }

  Future<List<ModelType>> findWhere(
      /* Expression | ExpressionMaker<ModelType> */ where,
      {Connection withConn}) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    return await findMany(finder.where(where), withConn: withConn);
  }

  Future<int> removeWhere(
      /* Expression | ExpressionMaker<ModelType> */ where,
      {Connection withConn}) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    return adapter.remove(remover.where(where), withConn: withConn);
  }

  Future<int> updateFields(
      /* Expression | ExpressionMaker<ModelType> */ where,
      Map<String, dynamic> values,
      {Connection withConn}) async {
    if (where is ExpressionMaker<ModelType>) where = where(this);
    final st = updater.where(where);
    for (String key in values.keys) {
      final f = fields[key];
      if (f == null) throw Exception('Unknown field!');
      st.set(f, values[key]);
    }
    return adapter.update(st, withConn: withConn);
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

class BeanRepo {
  final _beans = <Type, Bean>{};

  BeanRepo({List<Bean> beans: const []}) {
    addAll(beans);
  }

  void add(Bean bean) {
    _beans[bean.runtimeType] = bean;
  }

  void addAll(List<Bean> beans) {
    beans.forEach(add);
  }

  Bean operator [](Type beanType) {
    return _beans[beanType];
  }
}
