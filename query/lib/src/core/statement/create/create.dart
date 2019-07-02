library query.statement.create;

import 'dart:collection';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query/jaguar_query.dart' as prefix0;
import 'package:jaguar_query/src/core/core.dart';
import 'package:jaguar_query/src/core/datatype/property.dart';
import 'package:jaguar_query/src/core/expression/expression.dart';

part 'column.dart';

class Create implements Statement {
  final String name;

  final bool ifNotExists;

  final Map<String, CreateCol> _columns = {};

  Create(this.name, {this.ifNotExists = false}) {
    _immutable = ImCreate(this);
  }

  Create addByType(String name, DataType type,
      {bool notNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, type,
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addInt(String name,
      {bool notNull = false,
      bool auto = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Int(auto: auto),
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addDouble(String name,
      {bool notNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Double(),
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addBool(String name,
      {bool notNull = false, List<Constraint> constraints = const []}) {
    _columns[name] =
        CreateCol(name, Bool(), notNull: notNull, constraints: constraints);
    return this;
  }

  Create addTimestamp(String name,
      {bool notNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Timestamp(),
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addStr(String name,
      {bool notNull = false,
      int length,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Str(length: length),
        notNull: notNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create add(CreateCol column) {
    _columns[column.name] = column;
    return this;
  }

  Create addAll(List<CreateCol> columns) {
    for (CreateCol col in columns) {
      _columns[col.name] = col;
    }
    return this;
  }

  Future<void> exec(/* Connection | Adapter */ connection) =>
      connection.createTable(this);

  ImCreate _immutable;

  ImCreate get asImmutable => _immutable;
}

class ImCreate {
  final Create _inner;

  ImCreate(this._inner)
      : columns = UnmodifiableMapView<String, CreateCol>(_inner._columns);

  String get name => _inner.name;

  final UnmodifiableMapView<String, CreateCol> columns;

  bool get ifNotExists => _inner.ifNotExists;
}
