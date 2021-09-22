part of query;

/// An SQL expression
abstract class Expression {
  const Expression();

  /// Returns the number of sub-expressions this expression has if this expression
  /// is a composite expression
  int get length;

  /// Creates a 'logical and' expression of this expression and the [other]
  And operator &(Expression other) => and(other);

  /// Creates a 'logical and' expression of this expression and the [other]
  And and(Expression exp);

  /// Creates a 'logical or' expression of this expression and the [other]
  Or operator |(Expression other) => or(other);

  /// Creates a 'logical or' expression of this expression and the [other]
  Or or(Expression exp);
}
