library query.compose;

import 'dart:ffi' as prefix0;

import 'package:jaguar_query/jaguar_query.dart';

import 'package:jaguar_query_postgres/src/types/types.dart';

part 'alter.dart';
part 'create.dart';
part 'create_db.dart';
part 'delete.dart';
part 'expression.dart';
part 'find.dart';
part 'insert.dart';
part 'row_source.dart';
part 'update.dart';

final postgresDialect = 'postgres';

class PgComposer implements Composer {
  String find(Find st) => composeFind(st);

  String expression(Expression expr) => composeExpression(expr);
}

final composer = PgComposer();