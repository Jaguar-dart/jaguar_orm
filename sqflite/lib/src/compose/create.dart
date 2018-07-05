part of query.compose;

String composeCreateColumn(final CreateColumn col) {
  final sb = new StringBuffer();
  sb.write(col.colName);

  if (col is CreateInt) {
    if (col.autoIncrement) {
      sb.write(' INTEGER AUTOINCREMENT');
    } else {
      sb.write(' INT');
    }
  } else if (col is CreateBool) {
    sb.write(' INT');
  } else if (col is CreateDateTime) {
    sb.write(' TEXT');
  } else if (col is CreateStr) {
    if (col.length <= 0) {
      sb.write(' TEXT');
    } else {
      sb.write(' CHAR(');
      sb.write(col.length);
      sb.write(')');
    }
  } else {
    throw new Exception('Unknown columns to create ${col.runtimeType}!');
  }

  if (!col.isNullable) sb.write(' NOT NULL');

  return sb.toString();
}

String composeCreate(final Create create) {
  final QueryCreateInfo info = create.info;
  final sb = new StringBuffer();

  sb.write('CREATE TABLE');

  if (info.ifNotExists) sb.write(' IF NOT EXISTS');

  sb.write(' ${info.tableName} (');

  sb.write(info.columns.values.map(composeCreateColumn).join(', '));

  final List<CreateColumn> primaries = info.columns.values
      .where((CreateColumn col) => col.isPrimaryKey)
      .toList();
  if (primaries.length != 0) {
    sb.write(', PRIMARY KEY (');
    sb.write(primaries.map((CreateColumn col) => col.colName).join(','));
    sb.write(')');
  }

  {
    final uniques = <CreateColumn>[];
    final compositeUniques = <String, List<CreateColumn>>{};
    final foreigns = <String, Map<String, String>>{};
    for (CreateColumn col in info.columns.values) {
      if (col.foreignKey != null) {
        if (!foreigns.containsKey(col.foreignKey.table)) {
          foreigns[col.foreignKey.table] = <String, String>{};
        }
        foreigns[col.foreignKey.table][col.colName] = col.foreignKey.col;
      }

      if (col.unique.unique) {
        if (col.unique.group == null) {
          uniques.add(col);
        } else {
          compositeUniques[col.unique.group] =
              (compositeUniques[col.unique.group] ?? <CreateColumn>[])
                ..add(col);
        }
      }
    }

    for (final String foreignTab in foreigns.keys) {
      final Map<String, String> cols = foreigns[foreignTab];
      sb.write(', FOREIGN KEY (');
      sb.write(cols.keys.join(', '));
      sb.write(') REFERENCES ');
      sb.write(foreignTab + '(');
      sb.write(cols.values.join(', '));
      sb.write(')');
    }

    for (CreateColumn col in uniques) {
      sb.write(', UNIQUE(${col.colName})');
    }

    for (String group in compositeUniques.keys) {
      final String str = compositeUniques[group]
          .map((CreateColumn col) => col.colName)
          .join(', ');
      sb.write(', UNIQUE($str)');
    }
  }

  sb.write(')');

  return sb.toString();
}

String composeCreateDb(final CreateDb st) => "CREATE DATABASE ${st.dbName}";
