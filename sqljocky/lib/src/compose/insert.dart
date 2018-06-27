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

String composeValue(dynamic val) {
  if (val is int) {
    return "$val";
  } else if (val is String) {
    return "'$val'";
  } else if (val is double || val is num) {
    return "$val";
  } else if (val is DateTime) {
    return "$val"; //TODO
  } else if (val is bool) {
    return val ? 'TRUE' : 'FALSE';
  } else {
    throw new Exception("Invalid type ${val.runtimeType}!");
  }
}
