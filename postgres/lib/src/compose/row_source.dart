part of query.compose;

String composeRowSource(RowSource source) {
  if(source is Table) {
    return source.name;
  } else if(source is Find) {
    return '(' + composeFind(source) + ')';
  } else if(source is ToDialectAble) {
    final ret = (source as ToDialectAble).toDialect("postgres");
    if(ret is String) return ret;
    if(ret is RowSource) return composeRowSource(ret);
    throw UnsupportedError("Unsupported row source $ret");
  }
  throw UnsupportedError("Unsupported row source $source");
}

String composeAliasedRowSource(AliasedRowSource source) {
  var sb = StringBuffer();

  sb.write(composeRowSource(source.source));

  if(source.alias != null) {
    sb.write(' AS ${source.alias}');
  }

  return sb.toString();
}