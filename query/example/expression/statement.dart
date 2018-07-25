library example.expression.field.dart_operators;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  final find = Sql.find('score');
  find.where(eq('plId', 5) & eq('plId2', 10));
  find.or(eq('plId', 8) & eq('plId2', 13));
  find.or(eq('plId', 10) & eq('plId2', 15));

  print(composeFind(find));
}
