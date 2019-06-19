part of query.compose;

String composeInsert(final Insert st) {
  final ImmutableInsertStatement info = st.asImmutable;
  final sb = StringBuffer();

  sb.write('INSERT INTO ');
  sb.write(info.table);
  sb.write('(');

  sb.write(info.values.keys.join(', '));

  sb.write(') VALUES (');
  sb.write(info.values.values.map(composeValue).join(', '));
  sb.write(')');

  if (info.id is String) {
    sb.write(' RETURNING ');
    sb.write(info.id);
  }

  return sb.toString();
}
