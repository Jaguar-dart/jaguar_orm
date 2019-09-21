import 'package:jaguar_query/jaguar_query.dart';

class Array<T> implements DataType<T> {
  final bool auto = false;

  final DataType<T> type;

  const Array(this.type);
}

class A extends Expression implements ToDialect {
  final Expression expr;

  A(this.expr);

  factory A.from(items) => A(Expression.toExpression(items));

  String toDialect(String dialect, Composer composer) {
    return 'ARRAY[${composer.expression(expr)}]';
  }
}

class ArrayField<T> extends Field<List<T>> {
  ArrayField(String name) : super(name);

  Expression length({int dim: 1}) => array_length(this, dim: dim);
}

Func array_length(/* Expression */ array, {int dim: 1}) {
  final args = [Expression.toExpression(array)];
  if (dim != null) args.add(IntL(dim));
  return Func('array_length', args: args);
}

class HStore implements DataType {
  final bool auto = false;

  const HStore();
}

class HStoreField extends Field<Map<String, String>> {
  const HStoreField(String name) : super(name);
}

class Json implements DataType {
  final bool auto = false;

  Json();
}

class JsonField extends Field<dynamic> {
  JsonField(String name) : super(name);
}
