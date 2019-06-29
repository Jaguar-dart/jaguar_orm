/// This example showcases building fluent SQL expressions using condition
/// methods and functions
library example.expression.field.dart_operators;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  final exp = (gt(col('age'), 20) & lt(col('age'), 35)) &
      (eq(col('likes'), 0) | gt(col('likes'), 50)) &
      (like(col('name'), 'Ho') | like(col('name'), 'Who%')) &
      (gtEq(col('likes'), 100) & ltEq(col('likes'), 1000)) &
      (between(col('age'), 20, 35));

  print(composeExpression(exp));
}
