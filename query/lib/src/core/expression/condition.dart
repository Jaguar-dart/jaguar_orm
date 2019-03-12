part of query;

/// A relational conditional expression
class Cond<ValType> extends Expression {
  /// The field/column of the condition
  final Field<ValType> lhs;

  /// The operator of the relational expression
  final Op op;

  /// The value of the relational expression the [field] is being compared against
  final ValType rhs;

  const Cond(this.lhs, this.op, this.rhs);

  /// Always returns 1 because relational condition is not a composite expressions
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

  /// DSL to create 'is equal to' relational condition
  static Cond<ValType> eq<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.Eq, value);

  /// DSL to create 'IS' relational condition
  static Cond<ValType> iss<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.Is, value);

  /// DSL to create 'IS NOT' relational condition
  static Cond<ValType> isNot<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.IsNot, value);

  /// DSL to create 'is not equal to' relational condition
  static Cond<ValType> ne<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.Ne, value);

  /// DSL to create 'is greater than' relational condition
  static Cond<ValType> gt<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.Gt, value);

  /// DSL to create 'is greater than or equal to' relational condition
  static Cond<ValType> gtEq<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.GtEq, value);

  /// DSL to create 'is less than or equal to' relational condition
  static Cond<ValType> ltEq<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.LtEq, value);

  /// DSL to create 'is less than' relational condition
  static Cond<ValType> lt<ValType>(Field<ValType> field, ValType value) =>
      Cond<ValType>(field, Op.Lt, value);

  /// DSL to create 'is like' relational condition
  static Cond<String> like(Field<String> field, String value) =>
      Cond<String>(field, Op.Like, value);

  /// DSL to create 'in-between' relational condition
  static Between<ValType> between<ValType>(
          Field<ValType> field, ValType low, ValType high) =>
      Between<ValType>(field, low, high);
}

/// A relational conditional expression
class CondCol<ValType> extends Expression {
  /// The field/column of the condition
  final Field<ValType> lhs;

  /// The operator of the relational expression
  final Op op;

  /// The value of the relational expression the [field] is being compared against
  final Field<ValType> rhs;

  const CondCol(this.lhs, this.op, this.rhs);

  /// Always returns 1 because relational condition is not a composite expressions
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

  /// DSL to create 'is equal to' relational condition
  static CondCol<ValType> eq<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.Eq, value);

  /// DSL to create 'IS' relational condition
  static CondCol<ValType> iss<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.Is, value);

  /// DSL to create 'IS NOT' relational condition
  static CondCol<ValType> isNot<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.IsNot, value);

  /// DSL to create 'is not equal to' relational condition
  static CondCol<ValType> ne<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.Ne, value);

  /// DSL to create 'is greater than' relational condition
  static CondCol<ValType> gt<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.Gt, value);

  /// DSL to create 'is greater than or equal to' relational condition
  static CondCol<ValType> gtEq<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.GtEq, value);

  /// DSL to create 'is less than or equal to' relational condition
  static CondCol<ValType> ltEq<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.LtEq, value);

  /// DSL to create 'is less than' relational condition
  static CondCol<ValType> lt<ValType>(
          Field<ValType> field, Field<ValType> value) =>
      CondCol<ValType>(field, Op.Lt, value);

  /// DSL to create 'is like' relational condition
  static CondCol<String> like(Field<String> field, Field<String> value) =>
      CondCol<String>(field, Op.Like, value);

  /// DSL to create 'in-between' relational condition
  static InBetweenCol<ValType> between<ValType>(
          Field<ValType> field, Field<ValType> low, Field<ValType> high) =>
      InBetweenCol<ValType>(field, low, high);
}
