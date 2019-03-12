part of query.compose;

String composeInsertMany(final InsertMany st) {
  final ImmutableInsertManyStatement info = st.asImmutable;
  final sb = new StringBuffer();

  sb.write('INSERT INTO ');
  sb.write(info.table);

  final keys = info.values[0].keys.toList();
  sb.write(' SELECT ');
  for (var i = 0; i < keys.length; ++i) {
    var key = keys[i];
    sb.write('${composeValue(info.values[0][key])} AS \'$key\'');
    if (i < keys.length - 1) {
      sb.write(', ');
    }
  }
  sb.write('\n');

  for (var i = 1; i < info.values.length; ++i) {
    final values = info.values[i];
    final keys = info.values[i].keys.toList();
    sb.write('UNION ALL SELECT ');
    for (var j = 0; j < keys.length; ++j) {
      var key = keys[j];
      sb.write('${composeValue(values[key])}');
      if (j < keys.length - 1) {
        sb.write(', ');
      }
    }
    sb.write('\n');
  }

  return sb.toString();
}
