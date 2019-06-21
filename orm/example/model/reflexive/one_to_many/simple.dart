library example.has_one;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'simple.jorm.dart';

class Directory {
  @primaryKey
  @Str(length: 50)
  String id;

  @Str(length: 50)
  String name;

  @HasMany(DirectoryBean)
  List<Directory> child;

  @Column(notNull: true)
  @BelongsTo(DirectoryBean, references: 'id')
  String parentId;

  Directory({this.id, this.name, this.parentId});

  String toString() =>
      {"id": id, "name": name, "parentId": parentId, "child": child}.toString();
}

@GenBean()
class DirectoryBean extends Bean<Directory> with _DirectoryBean {
  DirectoryBean get directoryBean => this;
  DirectoryBean(Adapter adapter) : super(adapter);

  String get tableName => 'directory';
}
