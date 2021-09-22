part of query.compose;

List<String> composeUpdateMany(final UpdateMany st) {
  final ImmutableUpdateManyStatement info = st.asImmutable;

  List<String> queries = [];

  for (var i = 0; i < info.values.length; ++i) {
    final sb = new StringBuffer();
    var item = info.values[i];
    sb.write('UPDATE ');
    sb.write(info.tableName);
    sb.write(' SET ');

    sb.write(item.values.keys
        .map((String key) => '$key=${composeValue(item.values[key])}')
        .join(', '));

    if (item.where.length != 0) {
      sb.write(' WHERE ');
      sb.write(composeExpression(item.where));
    }

    sb.write(';');
    queries.add(sb.toString());
  }

  return queries;
}
