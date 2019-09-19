part of query.compose;

String composeUpsert(final Upsert st) {
  final ImUpsert info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('INSERT OR REPLACE INTO ');
  sb.write(info.table);
  sb.write('(');

  sb.write(info.values.keys.join(', '));

  sb.write(') VALUES (');
  sb.write(info.values.values.map(composeExpression).join(', '));
  sb.write(')');

  sb.write(';');

  return sb.toString();
}
