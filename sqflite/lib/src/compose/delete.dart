part of query.compose;

String composeRemove(final Remove st) {
  final QueryRemoveInfo info = st.info;
  final sb = new StringBuffer();

  sb.write('DELETE FROM ');
  sb.write(st.info.tableName);

  if (info.where.length != 0) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  sb.write(';');

  return sb.toString();
}

String composeDropDb(final DropDb st) => "DROP DATABASE ${st.name}";

String composeDrop(final Drop st) {
  return "DROP TABLE " +
      (st.onlyIfExists ? 'IF EXISTS ' : '') +
      st.tables.join(', ');
}
