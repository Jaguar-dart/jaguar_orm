part of query.compose;

String composeRowSource(RowSource source) {
  if (source is Table) {
    return source.name;
  } else if (source is Find) {
    return '(' + composeFind(source) + ')';
  } else if (source is Values) {
    return '(' + composeValues(source) + ')';
  } else if (source is ToDialect) {
    final ret = (source as ToDialect).toDialect("postgres", composer);
    if (ret is String) return ret;
    if (ret is RowSource) return composeRowSource(ret);
    throw UnsupportedError("Unsupported row source $ret");
  }
  throw UnsupportedError("Unsupported row source $source");
}

String composeAliasedRowSource(AliasedRowSource source) {
  var sb = StringBuffer();

  sb.write(composeRowSource(source.source));

  if (source.alias != null) {
    sb.write(' AS ${source.alias}');
  }

  return sb.toString();
}

String composeRow(Row row) {
  final sb = StringBuffer('(');
  sb.write(row.columns.map(composeExpression).join(','));
  sb.write(')');
  return sb.toString();
}

String composeValues(Values values) {
  if (values.rows.isEmpty) throw Exception("Values cannot be empty!");
  final sb = StringBuffer();

  sb.write('VALUES ');

  sb.write(values.rows.map(composeRow).join(','));

  return sb.toString();
}
