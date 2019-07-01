part of 'expression.dart';

/// Relational comparision operator
class Op {
  /// Identification code for this comparision operator
  final int id;

  /// String representation of this comparision operator
  final String string;

  const Op._(this.id, this.string);

  Cond make(
          /* Literal | Expression */ lhs,
          /* Literal | Expression */ rhs) =>
      Cond(Expression.toExpression(lhs), this, Expression.toExpression(rhs));

  /// 'is equal to' relational comparision operator
  static const Op Eq = const Op._(0, '=');

  /// 'is not equal to' relational comparision operator
  static const Op Ne = const Op._(1, '<>');

  /// 'is greater than' relational comparision operator
  static const Op Gt = const Op._(2, '>');

  /// 'is greater than or equal to' relational comparision operator
  static const Op GtEq = const Op._(3, '>=');

  /// 'is less than or equal to' relational comparision operator
  static const Op LtEq = const Op._(4, '<=');

  /// 'is less than' relational comparision operator
  static const Op Lt = const Op._(5, '<');

  /// 'is like' relational comparision operator
  static const Op Like = const Op._(6, 'LIKE');

  /// 'IS' relational comparision operator
  static const Op Is = const Op._(7, 'IS');

  /// 'IS NOT' relational comparision operator
  static const Op IsNot = const Op._(8, 'IS NOT');
}

/// DSL to create 'is equal to' relational condition
Cond eq(
        /* Literal | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.Eq.make(lhs, rhs);

/// DSL to create 'is not equal to' relational condition
Cond ne(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.Ne.make(lhs, rhs);

/// DSL to create 'is greater than' relational condition
Cond gt(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.Gt.make(lhs, rhs);

/// DSL to create 'is greater than or equal to' relational condition
Cond gtEq(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.GtEq.make(lhs, rhs);

/// DSL to create 'is less than or equal to' relational condition
Cond ltEq(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.LtEq.make(lhs, rhs);

/// DSL to create 'is less than' relational condition
Cond lt(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.Lt.make(lhs, rhs);

/// DSL to create 'is like' relational condition
Cond like(
        /* String | Expression */ lhs,
        /* Literal | Expression */ rhs) =>
    Op.Like.make(lhs, rhs);

/// DSL to create 'in-between' relational condition
Between between(
        /* Literal | Expression */ lhs,
        /* Literal | Expression */ low,
        /* Literal | Expression */ high) =>
    Between(Expression.toExpression(lhs), Expression.toExpression(low),
        Expression.toExpression(high));
