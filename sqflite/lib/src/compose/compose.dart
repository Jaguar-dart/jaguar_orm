library query.compose;

import 'dart:ffi' as prefix0;

import 'package:jaguar_query/jaguar_query.dart';

part 'alter.dart';
part 'create.dart';
part 'create_db.dart';
part 'delete.dart';
part 'expression.dart';
part 'find.dart';
part 'insert.dart';
part 'insert_many.dart';
part 'row_source.dart';
part 'update.dart';
part 'update_many.dart';
part 'upsert.dart';
part 'upsert_many.dart';

final postgresDialect = 'sqflite';

class SqfComposer implements Composer {
  String find(Find st) => composeFind(st);

  String expression(Expression expr) => composeExpression(expr);
}

final composer = SqfComposer();
