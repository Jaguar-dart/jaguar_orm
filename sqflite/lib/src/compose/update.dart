part of query.compose;

String composeUpdate(final Update st) {
  final ImUpdate info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('UPDATE ');
  sb.write(info.tableName);
  sb.write(' SET ');

  sb.write(info.values.keys.map((String key) => '$key=${composeLiteral(info.values[key])}').join(', '));

  if (info.where != null) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  sb.write(';');

  return sb.toString();
}
