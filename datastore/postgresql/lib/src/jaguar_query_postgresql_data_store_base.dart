// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library mongo_data_store.resource;

import 'dart:async';
import 'package:jaguar/jaguar.dart' as j;
import 'package:jaguar_postgresql/jaguar_postgresql.dart';
import 'package:postgresql/postgresql.dart' as pg;
import 'package:jaguar_serializer/serializer.dart';
import 'package:jaguar_data_store/jaguar_data_store.dart';
import 'package:jaguar_query_data_store/jaguar_query_data_store.dart';
import 'package:jaguar_query_postgresql/jaguar_query_postgresql.dart';
import 'package:jaguar_json/jaguar_json.dart';

typedef IdType StringToId<IdType>(String idStr);

@j.Api()
@j.Wrap(const [#postgreWrapper])
class PostgreResource<IdType, ModelType extends Idied<IdType>> {
  /// Url for DB
  final String postgreUrl;

  /// Name of the table in database
  final String tableName;

  /// View serializer
  final Serializer<ModelType> jsonSerializer;

  /// Db serializer
  final Serializer<ModelType> pgSerializer;

  final IdMaker<IdType> idMaker;

  final StringToId<IdType> stringToId;

  final String idKey;

  QueryDataStore<IdType, ModelType, pg.Connection> createStore(
      pg.Connection db) {
    final adapter = new PgAdapter.FromConnection(db);
    return new QueryDataStore<IdType, ModelType, pg.Connection>(
        pgSerializer, tableName, adapter, idMaker,
        idKey: idKey);
  }

  PostgreResource(this.postgreUrl, this.tableName, this.jsonSerializer,
      this.pgSerializer, this.idMaker,
      {this.stringToId, this.idKey: '_id'});

  IdType _getId(j.Context ctx) {
    final String idStr = ctx.pathParams.get('id');
    if (stringToId == null) {
      if (IdType == String) {
        return idStr as IdType;
      }
      throw new Exception("stringToId converter must be specified!");
    }
    return stringToId(idStr);
  }

  @j.Get()
  Future<j.Response<String>> getAll(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final Stream<ModelType> stream = await createStore(db).getAll();
    final List<ModelType> models = await stream.toList();
    return serialize(jsonSerializer, models);
  }

  @j.Get(path: '/:id')
  Future<j.Response<String>> getById(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final ModelType model = await createStore(db).getById(_getId(ctx));
    return serialize(jsonSerializer, model);
  }

  @j.Post()
  Future<j.Response<String>> create(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final Map data = await ctx.req.bodyAsJsonMap();
    final ModelType model = jsonSerializer.fromMap(data);
    //TODO validate
    final IdType ret = await createStore(db).insert(model);
    return j.Response.json(ret);
  }

  @j.Put()
  Future<j.Response<String>> update(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final Map data = await ctx.req.bodyAsJsonMap();
    final ModelType m = jsonSerializer.fromMap(data);
    //TODO validate
    final int ret = await createStore(db).updateById(m.id, m);
    return j.Response.json(ret);
  }

  @j.Delete(path: '/:id')
  Future<j.Response<String>> deleteById(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final int ret = await createStore(db).removeById(_getId(ctx));
    return j.Response.json(ret);
  }

  @j.Delete()
  Future<j.Response<String>> deleteAll(j.Context ctx) async {
    final pg.Connection db = ctx.getInput(PostgresDb);
    final int ret = await createStore(db).removeAll();
    return j.Response.json(ret);
  }

  PostgresDb postgreWrapper(_) => new PostgresDb(postgreUrl);
}
