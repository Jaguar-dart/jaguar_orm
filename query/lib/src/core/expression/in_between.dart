part of 'expression.dart';

/// An in-between conditional expression
class Between extends Expression {
  /// The field/column of the condition
  final Expression lhs;

  /// The low value of the in-between condition
  final Expression low;

  /// The high value of the in-between condition
  final Expression high;

  const Between(this.lhs, this.low, this.high);

  /// Creates a 'logical and' expression of this expression and the [other]
  And and(Expression exp) {
    And ret = And();
    return ret.and(this).and(exp);
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  Or or(Expression exp) {
    Or ret = Or();
    return ret.or(this).or(exp);
  }
}
