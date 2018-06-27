part of query;

class Update implements Statement {
  String _tableName;

  final Map<String, dynamic> _values = {};

  Expression _where = new And();

  Update() {
    _info = new QueryUpdateInfo(this);
  }

  Update into(String tableName) {
    if (_tableName != null) {
      throw new Exception("Name already assigend!");
    }
    _tableName = tableName;
    return this;
  }

  Update set<ValType>(Field<ValType> field, ValType value) {
    setValue(field.name, value);
    return this;
  }

  Update setMany(List<SetColumn> columns) {
    columns.forEach((SetColumn column) {
      setValue(column._column, column._value);
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

  Update or(Expression exp) {
    _where = _where.or(exp);
    return this;
  }

  Update and(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Update orMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.or(exp);
    });
    return this;
  }

  Update andMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.and(exp);
    });
    return this;
  }

  Update where(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Update eq<T>(String column, T val) => and(q.eq<T>(column, val));

  Update ne<T>(String column, T val) => and(q.ne<T>(column, val));

  Update gt<T>(String column, T val) => and(q.gt<T>(column, val));

  Update gtEq<T>(String column, T val) => and(q.gtEq<T>(column, val));

  Update ltEq<T>(String column, T val) => and(q.ltEq<T>(column, val));

  Update lt<T>(String column, T val) => and(q.lt<T>(column, val));

  Update like(String column, String val) => and(q.like(column, val));

  Update eqCol<T>(String column, T val) => and(q.eq<T>(column, val));

  Update between<T>(String column, T low, T high) =>
      and(q.between<T>(column, low, high));

  Future<int> exec(Adapter adapter) => adapter.update(this);

  QueryUpdateInfo _info;

  QueryUpdateInfo get info => _info;
}

class QueryUpdateInfo {
  final Update _inner;

  QueryUpdateInfo(this._inner)
      : values = new UnmodifiableMapView<String, dynamic>(_inner._values);

  String get tableName => _inner._tableName;

  final UnmodifiableMapView<String, dynamic> values;

  //TODO immutable
  Expression get where => _inner._where;
}
