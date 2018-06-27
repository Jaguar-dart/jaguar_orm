/// This example showcases building fluent SQL expressions using condition
/// methods and functions
library example.expression.field.dart_operators;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  final exp = (gt('age', 20) & lt('age', 35)) &
      (eq('likes', 0) | gt('likes', 50)) &
      (like('name', 'Ho') | like('name', 'Who')) &
      (gtEq('likes', 100) & ltEq('likes', 1000)) &
      (between('age', 20, 35));

  print(composeExpression(exp));
}
