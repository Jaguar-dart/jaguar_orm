part of query.compose;

String composeUpdate(final Update st) {
  final ImmutableUpdateStatement info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('UPDATE ');
  sb.write(info.tableName);
  sb.write(' SET ');

  sb.write(info.values.keys
      .map((String key) => '$key=${composeValue(info.values[key])}')
      .join(', '));

  if (info.where.length != 0) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  sb.write(';');

  return sb.toString();
}
