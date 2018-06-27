part of query;

typedef MappedExpression<T> = Expression Function(T value);

class OrderBy {
  final String columnName;

  final bool ascending;

  const OrderBy(this.columnName, [this.ascending = false]);
}

class Find implements Statement {
  final _column = <SelColumn>[];

  TableName _from;

  final _joins = <JoinedTable>[];

  JoinedTable _curJoin;

  Expression _where = new And();

  final List<OrderBy> _orderBy = [];

  final List<String> _groupBy = [];

  int _limit;

  int _offset;

  QueryFindInfo _info;

  QueryFindInfo get info => _info;

  Find() {
    _info = new QueryFindInfo(this);
  }

  Find from(String tableName, [String alias]) {
    if (_from != null) {
      throw new Exception('From table already specified!');
    }
    _from = new TableName(tableName, alias);
    return this;
  }

  Find join(JoinedTable join) {
    if (join == null) {
      throw new Exception('Join cannot be null!');
    }
    _curJoin = join;
    _joins.add(_curJoin);
    return this;
  }

  Find innerJoin(String tableName, [String alias]) {
    _curJoin = new JoinedTable.innerJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  Find leftJoin(String tableName, [String alias]) {
    _curJoin = new JoinedTable.leftJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  Find rightJoin(String tableName, [String alias]) {
    _curJoin = new JoinedTable.rightJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  Find fullJoin(String tableName, [String alias]) {
    _curJoin = new JoinedTable.fullJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  Find crossJoin(String tableName, [String alias]) {
    _curJoin = new JoinedTable.crossJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  Find joinOn(Expression exp) {
    if (_curJoin == null) {
      throw new Exception('No joins in the join stack!');
    }
    _curJoin.joinOn(exp);
    return this;
  }

  Find sel(String columnName, [String alias]) {
    _column.add(new SelColumn(columnName, alias));
    return this;
  }

  Find selPrefixed(String prefix, String columnName) {
    final String name = prefix + '.' + columnName;
    _column.add(new SelColumn(name, name));
    return this;
  }

  Find selManyPrefixed(String prefix, List<String> columnNames) {
    for (String columnName in columnNames) {
      final String name = prefix + '.' + columnName;
      _column.add(new SelColumn(name, name));
    }
    return this;
  }

  Find count(String columnName, {String alias, bool isDistinct: false}) {
    _column.add(
        new CountSelColumn(columnName, alias: alias, isDistinct: isDistinct));
    return this;
  }

  Find or(Expression exp) {
    _where = _where.or(exp);
    return this;
  }

  Find and(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Find orMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.or(exp);
    });
    return this;
  }

  Find andMap<T>(Iterable<T> iterable, MappedExpression<T> func) {
    iterable.forEach((T v) {
      final Expression exp = func(v);
      if (exp != null) _where = _where.and(exp);
    });
    return this;
  }

  Find where(Expression exp) {
    _where = _where.and(exp);
    return this;
  }

  Find eq<T>(String column, T val) => and(q.eq<T>(column, val));

  Find ne<T>(String column, T val) => and(q.ne<T>(column, val));

  Find gt<T>(String column, T val) => and(q.gt<T>(column, val));

  Find gtEq<T>(String column, T val) => and(q.gtEq<T>(column, val));

  Find ltEq<T>(String column, T val) => and(q.ltEq<T>(column, val));

  Find lt<T>(String column, T val) => and(q.lt<T>(column, val));

  Find like(String column, String val) => and(q.like(column, val));

  Find eqCol<T>(String column, T val) => and(q.eq<T>(column, val));

  Find between<T>(String column, T low, T high) =>
      and(q.between<T>(column, low, high));

  Find orderBy(String column, [bool ascending = false]) {
    _orderBy.add(new OrderBy(column, ascending));
    return this;
  }

  Find orderByMany(List<String> columns, [bool ascending = false]) {
    columns.forEach((String column) {
      _orderBy.add(new OrderBy(column, ascending));
    });
    return this;
  }

  Find limit(int val) {
    if (_limit != null) {
      throw new Exception('Already limited!');
    }
    _limit = val;
    return this;
  }

  Find offset(int val) {
    if (_offset != null) {
      throw new Exception('Cant use more than one offset!');
    }
    _offset = val;
    return this;
  }

  Find groupBy(String val) {
    _groupBy.add(val);
    return this;
  }

  Find groupByMany(List<String> columns) {
    _groupBy.addAll(columns);
    return this;
  }

  FindExecutor<ConnType> exec<ConnType>(Adapter<ConnType> adapter) =>
      new FindExecutor<ConnType>(adapter, this);
}

class QueryFindInfo {
  Find _find;

  QueryFindInfo(this._find)
      : selects = new UnmodifiableListView<SelColumn>(_find._column),
        joins = new UnmodifiableListView<JoinedTable>(_find._joins),
        orderBy = new UnmodifiableListView<OrderBy>(_find._orderBy),
        groupBy = new UnmodifiableListView<String>(_find._groupBy);

  TableName get from => _find._from;

  final UnmodifiableListView<SelColumn> selects;

  final UnmodifiableListView<JoinedTable> joins;

  // TODO return immutable
  Expression get where => _find._where;

  final UnmodifiableListView<OrderBy> orderBy;

  final UnmodifiableListView<String> groupBy;

  int get limit => _find._limit;

  int get offset => _find._offset;
}
