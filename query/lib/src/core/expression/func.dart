part of 'expression.dart';

class Func extends Expression {
  final String name;

  final List<Expression> args;

  const Func(this.name, {this.args = const []});
}

Func count(Expression arg) => Func('COUNT', args: [arg]);

Func max(Expression arg) => Func('MAX', args: [arg]);

Func sum(Expression arg) => Func('SUM', args: [arg]);

Func avg(Expression arg) => Func('AVG', args: [arg]);

Func distinct(/* List<Expression> | Expression */ arg) {
  if (arg is Expression) return Func('DISTINCT', args: [arg]);
  if (arg is List<Expression>) Func('DISTINCT', args: arg);

  throw UnsupportedError("$arg not supported!");
}