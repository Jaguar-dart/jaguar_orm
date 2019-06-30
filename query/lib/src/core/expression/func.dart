part of 'expression.dart';

class Func extends Expression {
  final String name;

  final List<Expression> args;

  const Func(this.name, {this.args = const []});

  static Func make(String name,
          {List< /* literal | Expression */ dynamic> args = const []}) =>
      Func(name, args: args.map(Expression.toExpression).toList());
}

Func count(/* literal | Expression */ arg) => Func.make('COUNT', args: [arg]);

Func max(/* literal | Expression */ arg) => Func.make('MAX', args: [arg]);

Func sum(/* literal | Expression */ arg) => Func.make('SUM', args: [arg]);

Func avg(/* literal | Expression */ arg) => Func.make('AVG', args: [arg]);

Func distinct(/* List<Expression> | Expression */ arg) {
  if (arg is List) Func.make('DISTINCT', args: arg);
  return Func.make('DISTINCT', args: [arg]);
}
