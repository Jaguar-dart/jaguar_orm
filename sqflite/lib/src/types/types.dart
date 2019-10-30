import 'package:jaguar_query/jaguar_query.dart';

class A extends Expression implements ToDialect {
  final List<Expression> items;

  A(this.items);

  factory A.from(List items) {
    return A(items.map(Expression.toExpression).toList());
  }

  String toDialect(String dialect, Composer composer) {
    return 'ARRAY[${items.map(composer.expression).join(',')}]';
  }
}

class HStore implements DataType {
  const HStore();
  bool get auto => false;
}

// TODO JSON
