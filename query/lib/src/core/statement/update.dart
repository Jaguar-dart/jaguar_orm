part of query.core;

class Update implements Statement, Settable, Whereable {
  final String name;

  final Map<String, Expression> _values = {};

  Expression _where;

  Update(this.name, {Expression where}) {
    _where = where;
    _immutable = ImUpdate(this);
  }

  /// Set the the [value] of given column ([field]).
  Update set(/* String | I */ column, /* literal | Expression */ value) {
    if (column is I) column = column.name;
    _values[column] = Expression.toExpression(value);
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Update setValues(Map<String, /* literal | Expression */ dynamic> values) {
    values.forEach(set);
    return this;
  }

  Update setOne(SetColumn col) {
    _values[col.name] = col.value;
    return this;
  }

  /// Sets many [columns] with a single call.
  Update setMany(Iterable<SetColumn> columns) {
    for (SetColumn c in columns) _values[c.name] = c.value;
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Update setInt(/* String | I */ column, int value) {
    return set(column, IntLiteral(value));
  }

  /// Convenience method to set the [value] of string [column].
  Update setString(/* String | I */ column, String value) {
    return set(column, StrLiteral(value));
  }

  /// Convenience method to set the [value] of bool [column].
  Update setBool(/* String | I */ column, bool value) {
    return set(column, BoolLiteral(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Update setTimestamp(/* String | I */ column, DateTime value) {
    return set(column, TimestampLiteral(value));
  }

  /// Convenience method to set the [value] of date time [column].
  Update setDuration(/* String | I */ column, Duration value) {
    return set(column, DurationLiteral(value));
  }

  /// Adds an to 'where' [expression] clause.
  Update where(Expression expression) {
    _where = expression;
    return this;
  }

  /// Adds an 'AND' [expression] to 'where' clause.
  Update and(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.and(exp);
    }
    return this;
  }

  /// Adds an 'OR' [expression] to 'where' clause.
  Update or(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.or(exp);
    }
    return this;
  }

  /// Adds an '=' [expression] to 'where' clause.
  Update eq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).eq(rhs));

  /// Adds an '<>' [expression] to 'where' clause.
  Update ne(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ne(rhs));

  /// Adds an 'IS' [expression] to 'where' clause.
  Update iss(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).iss(rhs));

  /// Adds an 'IS NOT' [expression] to 'where' clause.
  Update isNot(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).isNot(rhs));

  /// Adds an '>' [expression] to 'where' clause.
  Update gt(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gt(rhs));

  /// Adds an '>=' [expression] to 'where' clause.
  Update gtEq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gtEq(rhs));

  /// Adds an '<=' [expression] to 'where' clause.
  Update ltEq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ltEq(rhs));

  /// Adds an '<' [expression] to 'where' clause.
  Update lt(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).lt(rhs));

  /// Adds an '%' [expression] to 'where' clause.
  Update like(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).like(rhs));

  /// Adds an 'between' [expression] to 'where' clause.
  Update between(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ low,
          /* Literal | Expression */ high) =>
      and(I.make(lhs).between(low, high));

  Future<int> exec(Connection connection) => connection.update(this);

  ImUpdate _immutable;

  ImUpdate get asImmutable => _immutable;
}

class ImUpdate {
  final Update _inner;

  ImUpdate(this._inner)
      : values = UnmodifiableMapView<String, Expression>(_inner._values);

  String get tableName => _inner.name;

  final UnmodifiableMapView<String, Expression> values;

  //TODO immutable
  Expression get where => _inner._where;
}
