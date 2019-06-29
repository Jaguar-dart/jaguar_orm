/// This example showcases building fluent SQL expressions using Dart operators
/// on jaguar_query [Field]s
library example.expression.field.dart_operators;

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  final name = StrField('name');

  final age = IntField('age');

  final likes = IntField('likes');

  final exp = ((age > 20) & (age < 35)) &
      ((likes.eq(0)) | (likes > 50)) &
      (name % 'Ho%' | name % '%Who') &
      ((likes >= 100) & (age <= 1000)) &
      (age.between(20, 35));

  print(composeExpression(exp));
}
