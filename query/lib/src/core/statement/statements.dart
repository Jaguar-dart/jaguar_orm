part of query.core;

class SelClause {
  final Expression expr;

  final String alias;

  SelClause(this.expr, {this.alias});
}

/// name:value pair used to set a column named [name] to [value]. Used during
/// inserts and updates.
class SetColumn {
  /// Name of the column to set
  final String name;

  /// Value of the column
  final Expression value;

  SetColumn(this.name, this.value);

  /// Returns a [SetColumn] that sets the current column to new [value].
  SetColumn setTo(/* literal | Expression */ value) =>
      SetColumn(name, Expression.toExpression(value));
}

abstract class Statement {}

abstract class Settable implements Statement {
  Settable set(/* String | I */ field, /* literal | Expression */ value);

  Settable setValues(Map<String, dynamic> values);

  Settable setOne(SetColumn col);

  Settable setMany(List<SetColumn> columns);

  /// Convenience method to set the [value] of int [column].
  Settable setInt(/* String | I */ column, int value);

  /// Convenience method to set the [value] of string [column].
  Settable setString(/* String | I */ column, String value);

  /// Convenience method to set the [value] of bool [column].
  Settable setBool(/* String | I */ column, bool value);

  /// Convenience method to set the [value] of date time [column].
  Settable setTimestamp(
      /* String | I */ column,
      DateTime value);

  Settable setDuration(
      /* String | I */ column,
      Duration value);
}

abstract class Whereable implements Statement {
  Whereable or(Expression exp);

  Whereable and(Expression exp);

  Whereable where(Expression exp);

  Whereable eq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable ne(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable gt(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable gtEq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable ltEq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable lt(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable like(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs);

  Whereable between(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ low,
      /* Literal | Expression */ high);
}
