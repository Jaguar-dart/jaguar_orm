import 'package:jaguar_query/jaguar_query.dart';

class Array<T> implements DataType<T> {
  final bool auto = false;

  final DataType<T> type;

  const Array(this.type);
}

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

class ArrayField<T> extends Field<List<T>> {
  ArrayField(String name) : super(name);
}

Func array_length(/* TODO */ array, [int dim]) {
  final args = [array];
  if (dim != null) args.add(dim);
  return Func('array_length', args: args);
}

class HStore implements DataType {
  const HStore();
  bool get auto => false;
}

// TODO JSON
