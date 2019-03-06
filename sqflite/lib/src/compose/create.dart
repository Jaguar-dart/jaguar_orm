part of query.compose;

String composeCreateColumn(final CreateColumn col) {
  final sb = new StringBuffer();
  sb.write(col.name);

  if (col is CreateInt) {
    if (col.autoIncrement) {
      if (!col.isPrimary)
        throw new Exception(
            'SQLite requires that AUTOINCREMENT columns are Primary keys!');
      sb.write(' INTEGER PRIMARY KEY');
    } else {
      sb.write(' INT');
    }
  } else if (col is CreateBool) {
    sb.write(' INT');
  } else if (col is CreateDouble) {
    sb.write(' REAL');
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
    throw new Exception('Unknown columns to create ${col.runtimeType}!');
  }

  if (!col.isNullable) sb.write(' NOT NULL');

  return sb.toString();
}

String composeCreate(final Create create) {
  final ImmutableCreateStatement info = create.asImmutable;
  final sb = new StringBuffer();

  sb.write('CREATE TABLE');

  if (info.ifNotExists) sb.write(' IF NOT EXISTS');

  sb.write(' ${info.name} (');

  sb.write(info.columns.values.map(composeCreateColumn).join(', '));

  final List<CreateColumn> primaries = info.columns.values
      .where((CreateColumn col) =>
          col.isPrimary &&
          (col is! CreateInt || !(col as CreateInt).autoIncrement))
      .toList();
  if (primaries.length != 0) {
    sb.write(', PRIMARY KEY (');
    sb.write(primaries.map((CreateColumn col) => col.name).join(','));
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
        foreigns[col.foreignKey.table][col.name] = col.foreignKey.col;
      }

      if (col.uniqueGroup != null) {
        if (col.uniqueGroup.isEmpty) {
          uniques.add(col);
        } else {
          compositeUniques[col.uniqueGroup] =
              (compositeUniques[col.uniqueGroup] ?? <CreateColumn>[])..add(col);
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
      sb.write(', UNIQUE(${col.name})');
    }

    for (String group in compositeUniques.keys) {
      final String str = compositeUniques[group]
          .map((CreateColumn col) => col.name)
          .join(', ');
      sb.write(', UNIQUE($str)');
    }
  }

  sb.write(')');

  return sb.toString();
}

String composeCreateDb(final CreateDb st) => "CREATE DATABASE ${st.name}";
