library example.expression.field.dart_operators;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  final find = Sql.find('score');
  find.where(eq(col('plId'), 5) & eq(col('plId2'), 10));
  find.or(eq(col('plId'), 8) & eq(col('plId2'), 13));
  find.or(eq(col('plId'), 10) & eq(col('plId2'), 15));

  print(composeFind(find));
}
