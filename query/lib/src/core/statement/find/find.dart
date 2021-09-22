part of query;

/// Select SQL statement builder.
class Find implements Statement, Whereable {
  final _column = <SelColumn>[];

  final TableName from;

  final _joins = <JoinedTable>[];

  late JoinedTable _curJoin;

  Expression _where = And();

  final List<OrderBy> _orderBy = [];

  final List<String> _groupBy = [];

  int? _limit;

  int? _offset;

  Find(String tableName, {String? alias, Expression? where})
      : from = TableName(tableName, alias) {
    if (where != null) this.where(where);
    _immutable = ImmutableFindStatement(this);
  }

  /// Adds a 'join' clause to the select statement
  Find addJoin(JoinedTable join) {
    if (join == null) throw Exception('Join cannot be null!');

    _curJoin = join;
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'inner join' clause to the select statement.
  Find innerJoin(String tableName, [String? alias]) {
    _curJoin = JoinedTable.innerJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'left join' clause to the select statement.
  Find leftJoin(String tableName, [String? alias]) {
    _curJoin = JoinedTable.leftJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'right join' clause to the select statement.
  Find rightJoin(String tableName, [String? alias]) {
    _curJoin = JoinedTable.rightJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'full join' clause to the select statement.
  Find fullJoin(String tableName, [String? alias]) {
    _curJoin = JoinedTable.fullJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds 'cross join' clause to the select statement.
  Find crossJoin(String tableName, [String? alias]) {
    _curJoin = JoinedTable.crossJoin(tableName, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds the condition with which to perform joins.
  Find joinOn(Expression exp) {
    if (_curJoin == null) throw Exception('No joins in the join stack!');

    _curJoin.joinOn(exp);
    return this;
  }

  /// Selects a [column] to be fetched from the [table]. Use [alias] to alias
  /// the column name.
  Find sel(String column, {String? alias, String? table}) {
    String col = (table == null ? '' : table + '.') + column;
    _column.add(SelColumn(col, alias));
    return this;
  }

  /// Selects a [column] to be fetched. Use [alias] to alias the column name.
  Find selAll([String? table]) {
    String col = (table == null ? '' : table + '.') + '*';
    _column.add(SelColumn(col));
    return this;
  }

  /// Selects many [columns] to be fetched in the given [table]. Use [alias] to
  /// alias the column name.
  Find selMany(Iterable<String> columns, {String? table}) {
    if (table == null) {
      for (String columnName in columns) {
        final String name = columnName;
        _column.add(SelColumn(name));
      }
    } else {
      for (String columnName in columns) {
        final String name = table + '.' + columnName;
        _column.add(SelColumn(name));
      }
    }
    return this;
  }

  Find count(String column, {String? alias, bool isDistinct = false}) {
    _column.add(CountSelColumn(column, alias: alias, isDistinct: isDistinct));
    return this;
  }

  /// Adds an 'or' [expression] to 'where' clause.
  Find or(Expression expression) {
    _where = _where.or(expression);
    return this;
  }

  /// Adds an 'and' [expression] to 'where' clause.
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

  /// Adds an to 'where' [expression] clause.
  Find where(Expression expression) {
    _where = _where.and(expression);
    return this;
  }

  /// Adds an '=' [expression] to 'where' clause.
  Find eq<T>(String column, T val) => and(q.eq<T>(column, val));

  /// Adds an '<>' [expression] to 'where' clause.
  Find ne<T>(String column, T val) => and(q.ne<T>(column, val));

  /// Adds an '>' [expression] to 'where' clause.
  Find gt<T>(String column, T val) => and(q.gt<T>(column, val));

  /// Adds an '>=' [expression] to 'where' clause.
  Find gtEq<T>(String column, T val) => and(q.gtEq<T>(column, val));

  /// Adds an '<=' [expression] to 'where' clause.
  Find ltEq<T>(String column, T val) => and(q.ltEq<T>(column, val));

  /// Adds an '<' [expression] to 'where' clause.
  Find lt<T>(String column, T val) => and(q.lt<T>(column, val));

  /// Adds an '%' [expression] to 'where' clause.
  Find like(String column, String val) => and(q.like(column, val));

  /// Adds an 'between' [expression] to 'where' clause.
  Find between<T>(String column, T low, T high) =>
      and(q.between<T>(column, low, high));

  Find orderBy(String column, [bool ascending = false]) {
    _orderBy.add(OrderBy(column, ascending));
    return this;
  }

  Find orderByMany(List<String> columns, [bool ascending = false]) {
    columns.forEach((String column) {
      _orderBy.add(OrderBy(column, ascending));
    });
    return this;
  }

  Find limit(int val) {
    if (_limit != null) throw Exception('Already limited!');

    _limit = val;
    return this;
  }

  Find offset(int val) {
    if (_offset != null) throw Exception('Cant use more than one offset!');

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
      FindExecutor<ConnType>(adapter, this);

  late ImmutableFindStatement _immutable;

  ImmutableFindStatement get asImmutable => _immutable;
}

class ImmutableFindStatement {
  Find _find;

  ImmutableFindStatement(this._find)
      : selects = UnmodifiableListView<SelColumn>(_find._column),
        joins = UnmodifiableListView<JoinedTable>(_find._joins),
        orderBy = UnmodifiableListView<OrderBy>(_find._orderBy),
        groupBy = UnmodifiableListView<String>(_find._groupBy);

  TableName get from => _find.from;

  final UnmodifiableListView<SelColumn> selects;

  final UnmodifiableListView<JoinedTable> joins;

  // TODO return immutable
  Expression get where => _find._where;

  final UnmodifiableListView<OrderBy> orderBy;

  final UnmodifiableListView<String> groupBy;

  int? get limit => _find._limit;

  int? get offset => _find._offset;
}

typedef MappedExpression<T> = Expression Function(T value);

class OrderBy {
  final String columnName;

  final bool ascending;

  const OrderBy(this.columnName, [this.ascending = false]);
}
