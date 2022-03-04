part of query;

/// A 'logical and' expression of two or more expressions
class And extends Expression {
  /// List of expressions composing this 'logical and' expression
  final _expressions = <Expression>[];

  UnmodifiableListView<Expression> get expressions => UnmodifiableListView<Expression>(_expressions);

  And();

  /// Number of expressions composing this 'logical and' expression
  int get length => _expressions.length;

  /// Creates a 'logical and' expression of this expression and the [other]
  And and(Expression exp) {
    if (exp is And) {
      _expressions.addAll(exp._expressions);
    } else {
      _expressions.add(exp);
    }

    return this;
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  Or or(Expression exp) {
    Or ret = new Or();

    if (this.length != 0) {
      ret = ret.or(this);
    }

    return ret.or(exp);
  }
}
