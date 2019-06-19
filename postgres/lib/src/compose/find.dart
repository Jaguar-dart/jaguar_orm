part of query.compose;

String composeFind(final Find find) {
  final ImmutableFindStatement info = find.asImmutable;
  final sb = StringBuffer();
  sb.write('SELECT ');

  if (info.selects.length == 0) {
    sb.write('* ');
  } else {
    sb.write(info.selects.map(composeSelColumn).toList().join(', '));
  }

  sb.write(' FROM ');
  sb.write(composeAliasedRowSource(info.from));

  for (JoinedTable tab in info.joins) {
    sb.write(' ');
    sb.write(composeJoinedTable(tab));
  }

  if (info.where.length != 0) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  if (info.orderBy.length != 0) {
    sb.write(' ORDER BY ');
    sb.write(info.orderBy.map(composeOrderBy).join(', '));
  }

  if (info.limit is int) {
    sb.write(' LIMIT ');
    sb.write(info.limit);
  }

  if (info.offset is int) {
    sb.write(' OFFSET ');
    sb.write(info.offset);
  }

  if (info.groupBy.length != 0) {
    sb.write(' GROUP BY ');
    sb.write(info.groupBy.join(', '));
  }

  return sb.toString();
}

String composeSelColumn(final SelClause column) {
  String ret = composeSelExpr(column.expr);

  if (column.alias is String) {
    ret += ' AS "${column.alias}"';
  }

  return ret;
}

String composeJoinedTable(final JoinedTable join) {
  join.validate();

  final sb = StringBuffer();

  final QueryJoinedTableInfo info = join.info;

  sb.write(info.type.string);
  sb.write(' ' + composeAliasedRowSource(info.to));

  if (info.on.length != 0) {
    sb.write(' ON ');
    sb.write(composeAnd(info.on));
  }

  return sb.toString();
}

String composeOrderBy(final OrderBy orderBy) =>
    '${orderBy.columnName} ' + (orderBy.ascending ? 'ASC' : 'DESC');

String composeSelExpr(SelExpr exp) {
  if(exp is Sel) {
    return exp.name;
  } else if(exp is Func) {
    return composeFunc(exp);
  } else if(exp is ToDialectAble) {
    final ret = (exp as ToDialectAble).toDialect("postgres");
    if(ret is String) return ret;
    if(ret is SelExpr) return composeSelExpr(ret);
    throw UnsupportedError("Unsupported select expression $ret");
  }
  throw UnsupportedError("Unsupported select expression $exp");
}

String composeFunc(Func func) {
  var sb = StringBuffer();

  sb.write(func.name);

  sb.write('(');

  sb.write(func.args.map((s) => composeSelExpr(s)).join(', '));

  sb.write(')');

  return sb.toString();
}
