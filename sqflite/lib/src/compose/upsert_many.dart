part of query.compose;

List<String> composeUpsertMany(final UpsertMany st) {
  final ImUpsertMany info = st.asImmutable;

  List<String> queries = [];

  for (var i = 0; i < info.values.length; ++i) {
    final sb = new StringBuffer();
    var item = info.values[i];
    sb.write('INSERT OR REPLACE INTO ');
    sb.write(info.table);
    sb.write('(');

    sb.write(item.values.keys.join(', '));

    sb.write(') VALUES (');
    sb.write(item.values.values.map(composeExpression).join(', '));
    sb.write(')');

    sb.write(';');
    queries.add(sb.toString());
  }

  return queries;
}
