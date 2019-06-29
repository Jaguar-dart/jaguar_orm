part of 'expression.dart';

/// A relational conditional expression
class Cond extends Expression {
  /// The left hand side of the condition
  final Expression lhs;

  /// The operator of the relational expression
  final Op op;

  /// Right hand side of the condition
  final Expression rhs;

  const Cond(this.lhs, this.op, this.rhs);

  /*
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
   */
}
