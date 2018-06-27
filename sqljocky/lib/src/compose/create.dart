part of query.compose;

String composeCreateColumn(final CreateColumn col) {
  final sb = new StringBuffer();
  sb.write(col.colName);

  if (col is CreateInt) {
    sb.write(' INT');
  } else if (col is CreateBool) {
    sb.write(' BOOLEAN');
  } else if (col is CreateDateTime) {
    sb.write(' TIMESTAMP'); //TODO
  } else if (col is CreateStr) {
    sb.write(' VARCHAR(');
    sb.write(col.length);
    sb.write(')');
  } else {
    throw new Exception('Unknown columns to create ${col.runtimeType}!');
  }

  if (!col.isNullable) sb.write(' NOT NULL');

  if (col is CreateInt && col.autoIncrement) {
    sb.write(' AUTO_INCREMENT');
  }

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
    final y = <CreateColumn>[];
    final x = <String, List<CreateColumn>>{};
    for (CreateColumn col in info.columns.values) {
      if (col.foreignKey != null) {
        sb.write(', FOREIGN KEY (${col.colName}) REFERENCES ${col.foreignKey
            .table}(${col.foreignKey.col})');
      }

      if (col.unique.unique) {
        if (col.unique.group == null) {
          y.add(col);
        } else {
          x[col.unique.group] = (x[col.unique.group] ?? <CreateColumn>[])
            ..add(col);
        }
      }
    }

    for (CreateColumn col in y) {
      sb.write(', UNIQUE(${col.colName})');
    }

    for (String group in x.keys) {
      final String str =
          x[group].map((CreateColumn col) => col.colName).join(', ');
      sb.write(', UNIQUE($str)');
    }
  }

  sb.write(')');

  return sb.toString();
}

String composeCreateDb(final CreateDb st) => "CREATE DATABASE ${st.dbName}";
