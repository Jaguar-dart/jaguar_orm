part of query.core;

class Remove implements Statement, Whereable {
  final String name;

  Expression _where;

  Remove(this.name, {Expression where}) {
    _where = where;
    _info = QueryRemoveInfo(this);
  }

  /// Adds an to 'where' [expression] clause.
  Remove where(Expression expression) {
    _where = expression;
    return this;
  }

  /// Adds an 'AND' [expression] to 'where' clause.
  Remove and(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.and(exp);
    }
    return this;
  }

  /// Adds an 'OR' [expression] to 'where' clause.
  Remove or(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.or(exp);
    }
    return this;
  }

  /// Adds an '=' [expression] to 'where' clause.
  Remove eq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).eq(rhs));

  /// Adds an '<>' [expression] to 'where' clause.
  Remove ne(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ne(rhs));

  /// Adds an 'IS' [expression] to 'where' clause.
  Remove iss(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).iss(rhs));

  /// Adds an 'IS NOT' [expression] to 'where' clause.
  Remove isNot(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).isNot(rhs));

  /// Adds an '>' [expression] to 'where' clause.
  Remove gt(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gt(rhs));

  /// Adds an '>=' [expression] to 'where' clause.
  Remove gtEq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gtEq(rhs));

  /// Adds an '<=' [expression] to 'where' clause.
  Remove ltEq(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ltEq(rhs));

  /// Adds an '<' [expression] to 'where' clause.
  Remove lt(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).lt(rhs));

  /// Adds an '%' [expression] to 'where' clause.
  Remove like(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ rhs) =>
      and(I.make(lhs).like(rhs));

  /// Adds an 'between' [expression] to 'where' clause.
  Remove between(
      /* String | Field | I */ lhs,
      /* Literal | Expression */ low,
      /* Literal | Expression */ high) =>
      and(I.make(lhs).between(low, high));

  Future<int> exec(Connection connection) => connection.remove(this);

  QueryRemoveInfo _info;

  QueryRemoveInfo get info => _info;
}

class QueryRemoveInfo {
  final Remove _inner;

  QueryRemoveInfo(this._inner);

  String get tableName => _inner.name;

  // TODO immutable copy
  Expression get where => _inner._where;
}
