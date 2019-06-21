library query.statement.create;

import 'dart:collection';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query/src/core/datatype/property.dart';

part 'column.dart';

class Create implements Statement {
  final String name;

  final bool ifNotExists;

  final Map<String, CreateCol> _columns = {};

  Create(this.name, {this.ifNotExists = false}) {
    _immutable = ImmutableCreateStatement(this);
  }

  Create addInt(String name,
      {bool nonNull = false,
      bool autoIncrement = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Int(autoIncrement: autoIncrement),
        nonNull: nonNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addDouble(String name,
      {bool nonNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Double(),
        nonNull: nonNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addBool(String name,
      {bool nonNull = false, List<Constraint> constraints = const []}) {
    _columns[name] =
        CreateCol(name, Bool(), nonNull: nonNull, constraints: constraints);
    return this;
  }

  Create addTimestamp(String name,
      {bool nonNull = false,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Timestamp(),
        nonNull: nonNull,
        isPrimary: isPrimary,
        foreign: foreign,
        constraints: constraints);
    return this;
  }

  Create addStr(String name,
      {bool nonNull = false,
      int length,
      bool isPrimary = false,
      References foreign,
      List<Constraint> constraints = const []}) {
    _columns[name] = CreateCol(name, Str(length: length),
        nonNull: nonNull,
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

  Future<void> exec(Adapter adapter) => adapter.createTable(this);

  ImmutableCreateStatement _immutable;

  ImmutableCreateStatement get asImmutable => _immutable;
}

class ImmutableCreateStatement {
  final Create _inner;

  ImmutableCreateStatement(this._inner)
      : columns = UnmodifiableMapView<String, CreateCol>(_inner._columns);

  String get name => _inner.name;

  final UnmodifiableMapView<String, CreateCol> columns;

  bool get ifNotExists => _inner.ifNotExists;
}
