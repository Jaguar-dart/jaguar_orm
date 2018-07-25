part of query.compose;

String composeInsert(final Insert st) {
  final QueryInsertInfo info = st.info;
  final sb = new StringBuffer();

  sb.write('INSERT INTO ');
  sb.write(info.tableName);
  sb.write('(');

  sb.write(info.values.keys.join(', '));

  sb.write(') VALUES (');
  sb.write(info.values.values.map(composeValue).join(', '));
  sb.write(')');

  return sb.toString();
}
