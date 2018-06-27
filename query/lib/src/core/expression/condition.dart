part of query;

/// A relational conditional expression
class Cond<ValType> extends Expression {
  /// The field/column of the condition
  final Col<ValType> lhs;

  /// The operator of the relational expression
  final Op op;

  /// The value of the relational expression the [field] is being compared against
  final ValType rhs;

  const Cond(this.lhs, this.op, this.rhs);

  /// Always returns 1 because relational condition is not a composite expressions
  int get length => 1;

  /// Creates a 'logical and' expression of this expression and the [other]
  @checked
  And and(Expression exp) {
    And ret = new And();
    return ret.and(this).and(exp);
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  @checked
  Or or(Expression exp) {
    Or ret = new Or();
    return ret.or(this).or(exp);
  }

  /// DSL to create 'is equal to' relational condition
  static Cond<ValType> eq<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.Eq, value);

  /// DSL to create 'is not equal to' relational condition
  static Cond<ValType> ne<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.Ne, value);

  /// DSL to create 'is greater than' relational condition
  static Cond<ValType> gt<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.Gt, value);

  /// DSL to create 'is greater than or equal to' relational condition
  static Cond<ValType> gtEq<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.GtEq, value);

  /// DSL to create 'is less than or equal to' relational condition
  static Cond<ValType> ltEq<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.LtEq, value);

  /// DSL to create 'is less than' relational condition
  static Cond<ValType> lt<ValType>(Col<ValType> field, ValType value) =>
      new Cond<ValType>(field, Op.Lt, value);

  /// DSL to create 'is like' relational condition
  static Cond<String> like(Col<String> field, String value) =>
      new Cond<String>(field, Op.Like, value);

  /// DSL to create 'in-between' relational condition
  static Between<ValType> between<ValType>(
          Col<ValType> field, ValType low, ValType high) =>
      new Between<ValType>(field, low, high);
}

/// A relational conditional expression
class CondCol<ValType> extends Expression {
  /// The field/column of the condition
  final Col<ValType> lhs;

  /// The operator of the relational expression
  final Op op;

  /// The value of the relational expression the [field] is being compared against
  final Col<ValType> rhs;

  const CondCol(this.lhs, this.op, this.rhs);

  /// Always returns 1 because relational condition is not a composite expressions
  int get length => 1;

  /// Creates a 'logical and' expression of this expression and the [other]
  @checked
  And and(Expression exp) {
    And ret = new And();
    return ret.and(this).and(exp);
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  @checked
  Or or(Expression exp) {
    Or ret = new Or();
    return ret.or(this).or(exp);
  }

  /// DSL to create 'is equal to' relational condition
  static CondCol<ValType> eq<ValType>(Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.Eq, value);

  /// DSL to create 'is not equal to' relational condition
  static CondCol<ValType> ne<ValType>(Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.Ne, value);

  /// DSL to create 'is greater than' relational condition
  static CondCol<ValType> gt<ValType>(Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.Gt, value);

  /// DSL to create 'is greater than or equal to' relational condition
  static CondCol<ValType> gtEq<ValType>(
          Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.GtEq, value);

  /// DSL to create 'is less than or equal to' relational condition
  static CondCol<ValType> ltEq<ValType>(
          Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.LtEq, value);

  /// DSL to create 'is less than' relational condition
  static CondCol<ValType> lt<ValType>(Col<ValType> field, Col<ValType> value) =>
      new CondCol<ValType>(field, Op.Lt, value);

  /// DSL to create 'is like' relational condition
  static CondCol<String> like(Col<String> field, Col<String> value) =>
      new CondCol<String>(field, Op.Like, value);

  /// DSL to create 'in-between' relational condition
  static InBetweenCol<ValType> between<ValType>(
          Col<ValType> field, Col<ValType> low, Col<ValType> high) =>
      new InBetweenCol<ValType>(field, low, high);
}
