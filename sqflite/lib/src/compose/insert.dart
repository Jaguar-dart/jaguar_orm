part of query.compose;

String composeInsert(final Insert st) {
  final ImmutableInsertStatement info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('INSERT');
  if (info.ignoreIfExist) {
    sb.write(' OR IGNORE');
  }
  sb.write(' INTO ');
  sb.write(info.table);
  sb.write('(');

  sb.write(info.values.keys.join(', '));

  sb.write(') VALUES (');
  sb.write(info.values.values.map(composeValue).join(', '));
  sb.write(')');

  return sb.toString();
}
