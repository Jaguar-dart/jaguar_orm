part of query.compose;

String composeFind(final Find find) {
  final ImFind info = find.asImmutable;
  final sb = StringBuffer();
  sb.write('SELECT ');

  if (info.selects.length == 0) {
    sb.write('* ');
  } else {
    sb.write(info.selects.map(composeSelClause).toList().join(', '));
  }

  sb.write(' FROM ');
  sb.write(composeAliasedRowSource(info.from));

  for (JoinedTable tab in info.joins) {
    sb.write(' ');
    sb.write(composeJoinedTable(tab));
  }

  if (info.where != null) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  if (info.groupBy.length != 0) {
    sb.write(' GROUP BY ');
    sb.write(info.groupBy.map(composeExpression).join(', '));
  }

  if (info.orderBy.length != 0) {
    sb.write(' ORDER BY ');
    sb.write(info.orderBy.map(composeOrderBy).join(', '));
  }

  if (info.limit != null) {
    sb.write(' LIMIT ');
    sb.write(composeExpression(info.limit));
  }

  if (info.offset != null) {
    sb.write(' OFFSET ');
    sb.write(composeExpression(info.offset));
  }

  return sb.toString();
}

String composeSelClause(final SelClause column) {
  String ret = composeExpression(column.expr);

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

  if (info.on != null) {
    sb.write(' ON ');
    sb.write(composeExpression(info.on));
  }

  return sb.toString();
}

String composeOrderBy(final OrderBy orderBy) {
  var sb = StringBuffer();

  sb.write(composeExpression(orderBy.expr));

  if (orderBy.desc != null) {
    if (orderBy.desc) sb.write(' DESC');
  }

  return sb.toString();
}
