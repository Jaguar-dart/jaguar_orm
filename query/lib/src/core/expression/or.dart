part of query;

/// A 'logical or' expression of two or more expressions
class Or extends Expression {
  /// List of expressions composing this 'logical and' expression
  final _expressions = <Expression>[];

  Or() {
    _expOut = UnmodifiableListView<Expression>(_expressions);
  }

  late UnmodifiableListView<Expression> _expOut;

  /// List of expressions composing this 'logical or' expression
  UnmodifiableListView<Expression> get expressions => _expOut;

  /// Number of expressions composing this 'logical or' expression
  int get length => _expressions.length;

  /// Creates a 'logical and' expression of this expression and the [other]
  And and(Expression exp) {
    And ret = And();

    if (this.length != 0) {
      ret = ret.and(this);
    }

    return ret.and(exp);
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  Or or(Expression exp) {
    if (exp is Or) {
      _expressions.addAll(exp._expressions);
    } else {
      _expressions.add(exp);
    }

    return this;
  }
}
