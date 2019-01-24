part of query;

class Remove implements Statement, Whereable {
  final String name;

  Expression _where = And();

  Remove(this.name) {
    _info = QueryRemoveInfo(this);
  }

  Remove or(Expression exp) {
    _where = _where.or(exp);
    return this;
  }

  Remove and(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Remove orMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.or(exp);
    });
    return this;
  }

  Remove andMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.and(exp);
    });
    return this;
  }

  Remove where(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Remove eq<T>(String column, T val) => and(q.eq<T>(column, val));

  Remove ne<T>(String column, T val) => and(q.ne<T>(column, val));

  Remove gt<T>(String column, T val) => and(q.gt<T>(column, val));

  Remove gtEq<T>(String column, T val) => and(q.gtEq<T>(column, val));

  Remove ltEq<T>(String column, T val) => and(q.ltEq<T>(column, val));

  Remove lt<T>(String column, T val) => and(q.lt<T>(column, val));

  Remove like(String column, String val) => and(q.like(column, val));

  Remove eqCol<T>(String column, T val) => and(q.eq<T>(column, val));

  Remove between<T>(String column, T low, T high) =>
      and(q.between<T>(column, low, high));

  Future<int> exec(Adapter adapter) => adapter.remove(this);

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
