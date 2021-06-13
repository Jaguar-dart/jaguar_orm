part of query;

/// An in expression
class InOperation<ValType> extends Expression {
  /// The field/column of the condition
  final Field<ValType> field;

  /// The values
  final Set<ValType> values;

  const InOperation(this.field, this.values);

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
