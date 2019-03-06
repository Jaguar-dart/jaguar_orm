part of query.compose;

String composeAlter(Alter st) {
  final sb = new StringBuffer();

  sb.write('ALTER TABLE');
  sb.write(' ${st.table} ');

  // Add columns
  if (st.adds.isNotEmpty) {
    sb.write('ADD ');
    final adds = st.adds.values
        .map((AddColumn c) => composeCreateColumn(c.column))
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
  if (st.mods.isNotEmpty) {
    sb.write('ALTER COLUMN ');
    final mods = st.mods.values
        .map((ModifyColumn c) => c.name + ' TYPE' + composeType(c.column))
        .join(', ');
    sb.write(mods);
    sb.write(' ');
  }

  if (st.shouldDropPrimary) {
    sb.write('DROP PRIMARY KEY ');
  }

  if (st.primaryKeys.isNotEmpty) {
    sb.write('ADD PRIMARY KEY (${st.primaryKeys.join(', ')}) ');
  }

  return sb.toString();
}
