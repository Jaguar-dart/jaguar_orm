part of query.core;

class Update implements Statement, Settable, Whereable {
  final String name;

  final Map<String, dynamic> _values = {};

  Expression _where;

  Update(this.name, {Expression where}) {
    _where = where;
    _immutable = ImmutableUpdateStatement(this);
  }

  Update set<ValType>(Field<ValType> field, ValType value) {
    setValue(field.name, value);
    return this;
  }

  Update setMany(List<SetColumn> columns) {
    columns.forEach((SetColumn column) {
      setValue(column.name, column.value);
    });
    return this;
  }

  Update setValue<ValType>(String column, ValType value) {
    _values[column] = value;
    return this;
  }

  Update setValues(Map<String, dynamic> values) {
    _values.addAll(values);
    return this;
  }

  /// Convenience method to set the [value] of int [column].
  Update setInt(String column, int value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of string [column].
  Update setString(String column, String value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of bool [column].
  Update setBool(String column, bool value) {
    _values[column] = value;
    return this;
  }

  /// Convenience method to set the [value] of date time [column].
  Update setDateTime(String column, DateTime value) {
    _values[column] = value;
    return this;
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

  ImmutableUpdateStatement _immutable;

  ImmutableUpdateStatement get asImmutable => _immutable;
}

class ImmutableUpdateStatement {
  final Update _inner;

  ImmutableUpdateStatement(this._inner)
      : values = UnmodifiableMapView<String, dynamic>(_inner._values);

  String get tableName => _inner.name;

  final UnmodifiableMapView<String, dynamic> values;

  //TODO immutable
  Expression get where => _inner._where;
}
