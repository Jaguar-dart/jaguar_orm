// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library mongo_data_store.adapter;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_data_store/jaguar_data_store.dart';
import 'package:jaguar_serializer/serializer.dart';

typedef IdType IdMaker<IdType>();

class QueryDataStore<IdType, ModelType extends Idied<IdType>, ConnType>
    extends DataStore<IdType, ModelType> {
  final String tableName;

  final Serializer<ModelType> serializer;

  final Adapter<ConnType> adapter;

  final String idKey;

  final IdMaker idMaker;

  QueryDataStore(this.serializer, this.tableName, this.adapter, this.idMaker,
      {this.idKey: "_id"});

  /// Returns a stream of all records
  Future<Stream<ModelType>> getAll() async {
    final st = Sql.find(tableName);
    final Stream<Map> stream = await adapter.find(st);
    return stream.map((Map doc) => serializer.fromMap(doc));
  }

  /// Returns a single record by id [id]
  Future<ModelType> getById(IdType id) async {
    final st = Sql.find(tableName).where(eq<IdType>(idKey, id));

    final Map map = await adapter.findOne(st);

    return serializer.fromMap(map);
  }

  /// Inserts a new record [object]
  Future<IdType> insert(ModelType object) async {
    final Map map = serializer.toMap(object);

    final Insert st = Sql.insert(tableName).id(idKey);
    map.forEach((String key, dynamic value) {
      if (value != null) {
        st.setValue(key, value);
      }
    });
    final id = idMaker();
    st.setValue(idKey, id);

    await adapter.insert(st);
    return id;
  }

  Future<int> updateById(IdType id, ModelType object) {
    final Map map = serializer.toMap(object);

    final Update st = Sql.update(tableName);
    map.forEach((String key, dynamic value) {
      st.setValue(key, value);
    });

    st.where(eq<IdType>(idKey, id));

    return adapter.update(st);
  }

  FutureOr<int> updateMapById(IdType id, Map map) {
    final Update st = Sql.update(tableName);
    map.forEach((String key, dynamic value) {
      st.setValue(key, value);
    });

    st.where(eq<IdType>(idKey, id));

    return adapter.update(st);
  }

  Future<int> removeById(IdType id) {
    final st = Sql.remove(tableName).where(eq<IdType>(idKey, id));
    return adapter.remove(st);
  }

  Future<int> removeAll() {
    final st = Sql.remove(tableName);
    return adapter.remove(st);
  }
}
