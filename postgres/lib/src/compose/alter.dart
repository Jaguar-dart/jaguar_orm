part of query.compose;

/* TODO
String composeType(final CreateColumn col) {
  final sb = StringBuffer();

  if (col is CreateInt) {
    if (col.autoIncrement) {
      sb.write(' SERIAL');
    } else {
      sb.write(' INT');
    }
  } else if (col is CreateBool) {
    sb.write(' BOOLEAN');
  } else if (col is CreateDateTime) {
    sb.write(' TIMESTAMP');
  } else if (col is CreateStr) {
    sb.write(' VARCHAR(');
    sb.write(col.length);
    sb.write(')');
  } else {
    throw Exception('Unknown columns to create ${col.runtimeType}!');
  }

  if (!col.isNullable) sb.write(' NOT NULL');

  return sb.toString();
}
 */

String composeAlter(Alter st) {
  final sb = StringBuffer();

  sb.write('ALTER TABLE');
  sb.write(' ${st.table} ');

  // Add columns
  if (st.adds.isNotEmpty) {
    sb.write('ADD ');
    final adds = st.adds.values
        .map((AddColumn c) => composeProperty(c.column))
        .join(', ');
    sb.write(adds);
    sb.write(' ');
  }

  // Drop columns
  if (st.drops.isNotEmpty) {
    sb.write('DROP COLUMN ');
    final drops = st.drops.values.map((DropColumn c) => c.name).join(', ');
    sb.write(drops);
    sb.write(' ');
  }

  // Modify columns
  /* TODO
  if (st.mods.isNotEmpty) {
    sb.write('ALTER COLUMN ');
    final mods = st.mods.values
        .map((ModifyColumn c) => c.name + ' TYPE' + composeType(c.column))
        .join(', ');
    sb.write(mods);
    sb.write(' ');
  }
   */

  if (st.shouldDropPrimary) {
    sb.write('DROP PRIMARY KEY ');
  }

  if (st.primaryKeys.isNotEmpty) {
    sb.write('ADD PRIMARY KEY (${st.primaryKeys.join(', ')}) ');
  }

  return sb.toString();
}
