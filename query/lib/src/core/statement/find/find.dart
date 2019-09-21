part of query.core;

/// Select SQL statement builder.
class Find implements Statement, Whereable, RowSource {
  final _column = <SelClause>[];

  AliasedRowSource _from;

  final _joins = <JoinedTable>[];

  JoinedTable _curJoin;

  Expression _where;

  final List<OrderBy> _orderBy = [];

  final List<Expression> _groupBy = [];

  Expression _limit;

  Expression _offset;

  Find(/* Symbol | RowSource */ from, {String alias, Expression where}) {
    if (from is Symbol) from = Table(from);

    if (from is! RowSource) {
      throw UnsupportedError('Unsupported from expression!');
    }

    _from = AliasedRowSource(from, alias: alias);

    _where = where;
    _immutable = ImFind(this);
  }

  AliasedRowSource get from => _from;

  /// Adds a 'join' clause to the select statement
  Find addJoin(JoinedTable join) {
    if (join == null) throw Exception('Join cannot be null!');

    _curJoin = join;
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'inner join' clause to the select statement.
  Find innerJoin(/* String | RowSource */ source, [String alias]) {
    _curJoin = JoinedTable.innerJoin(source, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'left join' clause to the select statement.
  Find leftJoin(/* String | RowSource */ source, [String alias]) {
    _curJoin = JoinedTable.leftJoin(source, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'right join' clause to the select statement.
  Find rightJoin(/* String | RowSource */ source, [String alias]) {
    _curJoin = JoinedTable.rightJoin(source, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds a 'full join' clause to the select statement.
  Find fullJoin(/* String | RowSource */ source, [String alias]) {
    _curJoin = JoinedTable.fullJoin(source, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds 'cross join' clause to the select statement.
  Find crossJoin(/* String | RowSource */ source, [String alias]) {
    _curJoin = JoinedTable.crossJoin(source, alias);
    _joins.add(_curJoin);
    return this;
  }

  /// Adds the condition with which to perform joins.
  Find joinOn(Expression exp) {
    if (_curJoin == null) throw Exception('No joins in the join stack!');

    _curJoin.on(exp);
    return this;
  }

  /// Selects a [column] to be fetched from the [table]. Use [alias] to alias
  /// the column name.
  Find sel(/* String | Expression */ column, {String alias}) {
    if (column is String) column = col(column);
    _column.add(SelClause(column, alias: alias));
    return this;
  }

  /// Selects a [column] to be fetched. Use [alias] to alias the column name.
  Find selAll() {
    _column.add(SelClause(col('*')));
    return this;
  }

  /// Selects many [columns] to be fetched in the given [table]. Use [alias] to
  /// alias the column name.
  Find selMany(Iterable< /* String | Expression */ dynamic> columns) {
    columns.forEach(sel);
    return this;
  }

  /// Adds an to 'where' [expression] clause.
  Find where(Expression expression) {
    _where = expression;
    return this;
  }

  /// Adds an 'AND' [expression] to 'where' clause.
  Find and(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.and(exp);
    }
    return this;
  }

  /// Adds an 'OR' [expression] to 'where' clause.
  Find or(Expression exp) {
    if (_where == null) {
      _where = exp;
    } else {
      _where = _where.or(exp);
    }
    return this;
  }

  /// Adds an '=' [expression] to 'where' clause.
  Find eq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).eq(rhs));

  /// Adds an '<>' [expression] to 'where' clause.
  Find ne(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ne(rhs));

  /// Adds an 'IS' [expression] to 'where' clause.
  Find iss(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).iss(rhs));

  /// Adds an 'IS NOT' [expression] to 'where' clause.
  Find isNot(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).isNot(rhs));

  /// Adds an '>' [expression] to 'where' clause.
  Find gt(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gt(rhs));

  /// Adds an '>=' [expression] to 'where' clause.
  Find gtEq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).gtEq(rhs));

  /// Adds an '<=' [expression] to 'where' clause.
  Find ltEq(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).ltEq(rhs));

  /// Adds an '<' [expression] to 'where' clause.
  Find lt(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).lt(rhs));

  /// Adds an '%' [expression] to 'where' clause.
  Find like(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ rhs) =>
      and(I.make(lhs).like(rhs));

  /// Adds an 'between' [expression] to 'where' clause.
  Find between(
          /* String | Field | I */ lhs,
          /* Literal | Expression */ low,
          /* Literal | Expression */ high) =>
      and(I.make(lhs).between(low, high));

  Find orderBy(/* String | int | Expression */ expr, {bool desc}) {
    if (expr is String) expr = col(expr);
    if (expr is int) expr = IntL(expr);
    if (expr is! Expression) {
      throw ArgumentError.value(
          expr, 'val', 'Must be String | int | Expression');
    }

    _orderBy.add(OrderBy(expr, desc: desc));
    return this;
  }

  Find orderByMany(List< /* String | int | Expression */ dynamic> columns,
      {bool desc}) {
    columns.forEach((column) {
      _orderBy.add(OrderBy(column, desc: desc));
    });
    return this;
  }

  Find limit(/* int | Expression */ val) {
    if (val is int) val = IntL(val);
    if (val is! Expression) {
      throw ArgumentError.value(val, 'val', 'Must be int | Expression');
    }

    _limit = val;
    return this;
  }

  Find offset(/* int | Expression */ val) {
    if (val is int) val = IntL(val);
    if (val is! Expression) {
      throw ArgumentError.value(val, 'val', 'Must be int | Expression');
    }

    _offset = val;
    return this;
  }

  Find groupBy(/* String | int | Expression */ expr) {
    if (expr is String) expr = col(expr);
    if (expr is int) expr = IntL(expr);
    if (expr is! Expression) {
      throw ArgumentError.value(
          expr, 'val', 'Must be String | int | Expression');
    }

    _groupBy.add(expr);
    return this;
  }

  Find groupByMany(List< /* String | int | Expression */ dynamic> expr) {
    expr.forEach(groupBy);
    return this;
  }

  FindExecutor<ConnType> exec<ConnType>(Connection<ConnType> connection) =>
      FindExecutor<ConnType>(connection, this);

  ImFind _immutable;

  ImFind get asImmutable => _immutable;
}

class ImFind {
  Find _find;

  ImFind(this._find)
      : selects = UnmodifiableListView<SelClause>(_find._column),
        joins = UnmodifiableListView<JoinedTable>(_find._joins),
        orderBy = UnmodifiableListView<OrderBy>(_find._orderBy),
        groupBy = UnmodifiableListView<Expression>(_find._groupBy);

  AliasedRowSource get from => _find.from;

  final UnmodifiableListView<SelClause> selects;

  final UnmodifiableListView<JoinedTable> joins;

  Expression get where => _find._where;

  final UnmodifiableListView<OrderBy> orderBy;

  final UnmodifiableListView<Expression> groupBy;

  Expression get limit => _find._limit;

  Expression get offset => _find._offset;
}

typedef MappedExpression<T> = Expression Function(T value);

class OrderBy {
  final /* String | int | Expression */ expr;

  final bool desc;

  const OrderBy(this.expr, {this.desc});
}
