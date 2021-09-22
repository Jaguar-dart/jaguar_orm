part of query;

/// An in-between conditional expression
class Between<ValType> extends Expression {
  /// The field/column of the condition
  final Field<ValType> field;

  /// The low value of the in-between condition
  final ValType low;

  /// The high value of the in-between condition
  final ValType high;

  const Between(this.field, this.low, this.high);

  /// Always returns 1 because in-between is not a composite expression
  int get length => 1;

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

/// An in-between conditional expression
class InBetweenCol<ValType> extends Expression {
  /// The field/column of the condition
  final Field<ValType> field;

  /// The low value of the in-between condition
  final Field<ValType> low;

  /// The high value of the in-between condition
  final Field<ValType> high;

  const InBetweenCol(this.field, this.low, this.high);

  /// Always returns 1 because in-between is not a composite expression
  int get length => 1;

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
