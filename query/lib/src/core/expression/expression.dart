library jaguar.query.expression;

import 'dart:collection';
import 'package:jaguar_query/jaguar_query.dart';

part 'and.dart';
part 'biexpr.dart';
part 'condition.dart';
part 'field.dart';
part 'func.dart';
part 'in_between.dart';
part 'literal.dart';
part 'operator.dart';
part 'or.dart';

abstract class Expression {
  const Expression();

  static Expression toExpression(/* literal | Expression */ value) {
    if (value is Expression) return value;
    {
      final lit = Literal.tryToLiteral(value);
      if (lit != null) return lit;
    }
    throw ArgumentError.value(value, 'value', 'Must be Expression | literal');
  }

  /// Returns an "is equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> author = Field<int>('age');
  ///     find.where(age.eq(20));
  Cond eq(/* ValType | Expression */ value) =>
      Cond(this, Op.Eq, toExpression(value));

  /// Returns an "IS" condition, i.e. 'where var IS null'
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> phone = Field<String>('phone');
  ///     find.where(phone.iss(null));
  Cond iss(/* ValType | Expression */ value) =>
      Cond(this, Op.Is, toExpression(value));

  /// Returns an "IS NOT" condition, i.e. 'where var IS NOT null'
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> phone = Field<String>('phone');
  ///     find.where(phone.isNot(null));
  Cond isNot(/* ValType | Expression */ value) =>
      Cond(this, Op.IsNot, toExpression(value));

  /// Returns a "not equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ne(20));
  Cond ne(/* ValType | Expression */ value) =>
      Cond(this, Op.Ne, toExpression(value));

  /// Returns a "greater than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gt(20));
  Cond gt(/* ValType | Expression */ value) =>
      Cond(this, Op.Gt, toExpression(value));

  /// Returns a "greater than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtEq(20));
  Cond gtEq(/* ValType | Expression */ value) =>
      Cond(this, Op.GtEq, toExpression(value));

  /// Returns a "less than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltEq(20));
  Cond ltEq(/* ValType | Expression */ value) =>
      Cond(this, Op.LtEq, toExpression(value));

  /// Returns a "less than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.lt(20));
  Cond lt(/* ValType | Expression */ value) =>
      Cond(this, Op.Lt, toExpression(value));

  /// Returns an "in between" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.between(20, 30));
  Between between(
          /* ValType | Expression */ low,
          /* ValType | Expression */ high) =>
      Between(this, toExpression(low), toExpression(high));

  /// This is actually 'like' operator
  Cond operator %(/* String | Expression */ other) => like(other);

  /// Returns a "like" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> author = Field<String>('author');
  ///     find.where(author.like('%Mark%'));
  Cond like(/* String | Expression */ value) =>
      Cond(this, Op.Like, toExpression(value));

  Cond operator <(/* ValType | Expression */ other) {
    return lt(other);
  }

  Cond operator >(/* ValType | Expression */ other) {
    return gt(other);
  }

  Cond operator <=(/* ValType | Expression */ other) {
    return ltEq(other);
  }

  Cond operator >=(/* ValType | Expression */ other) {
    return gtEq(other);
  }

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

  /// Creates a 'logical and' expression of this expression and the [other]
  And operator&(Expression exp) {
    And ret = And();
    return ret.and(this).and(exp);
  }

  /// Creates a 'logical or' expression of this expression and the [other]
  Or operator|(Expression exp) {
    Or ret = Or();
    return ret.or(this).or(exp);
  }
}

class E extends Expression {
  final String expr;

  E(this.expr);
}

/// [I] represents an identifier.
class I extends Expression {
  final String name;

  I(this.name);

  static I make(/* String | Field | I */ value) {
    if (value is I) return value;
    if (value is Field) return value;
    if (value is String) return I(value);

    throw ArgumentError.value(value, 'value', 'Not an identifier');
  }
}

I col(String name) => I(name);
