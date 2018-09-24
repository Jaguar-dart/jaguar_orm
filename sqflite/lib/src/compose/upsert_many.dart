part of query.compose;

List<String> composeUpsertMany(final UpsertMany st) {
  final ImmutableUpsertManyStatement info = st.asImmutable;

  List<String> queries = [];

  for (var i = 0; i < info.values.length; ++i) {
    final sb = new StringBuffer();
    var item = info.values[i];
    sb.write('INSERT OR REPLACE INTO ');
    sb.write(info.table);
    sb.write('(');

    sb.write(item.keys.join(', '));

    sb.write(') VALUES (');
    sb.write(item.values.map(composeValue).join(', '));
    sb.write(')');

    sb.write(';');
    queries.add(sb.toString());
  }

  return queries;
}
