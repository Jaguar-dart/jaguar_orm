part of query.compose;

String composeDataType(final DataType type) {
  if (type == null) throw Exception("Data type cannot be null!");
  if (type is Int) {
    if (type.auto) {
      return 'INTEGER PRIMARY KEY';
    } else {
      return 'INT';
    }
  } else if (type is Bool) {
    return 'INT';
  } else if (type is prefix0.Double) {
    return 'REAL';
  } else if (type is Double) {
    return 'REAL';
  } else if (type is DateTime) {
    return 'TEXT';
  } else if (type is Str) {
    if (type.length == null) return 'TEXT';
    return 'CHAR(${type.length})';
  } else {
    throw Exception('Unknown data type ${type.runtimeType}!');
  }
}

String composeProperty(final Property col) {
  final sb = StringBuffer();

  sb.write(col.name);
  sb.write(' ');
  sb.write(composeDataType(col.type));

  if (col.notNull) sb.write(' NOT NULL');

  return sb.toString();
}

String composeCreate(final Create create) {
  final ImCreate info = create.asImmutable;
  final sb = new StringBuffer();

  sb.write('CREATE TABLE');

  if (info.ifNotExists) sb.write(' IF NOT EXISTS');

  sb.write(' ${info.name} (');

  // Write col specs
  {
    final cols = <String>[];

    for (CreateCol col in info.columns.values) {
      final colSpec = StringBuffer();
      colSpec.write(composeProperty(col));

      // TODO handle other constraints

      Check check = col.constraints.firstWhere((c) => c is Check, orElse: () => null);
      if (check != null) {
        colSpec.write(' CHECK( ${composeExpression(check.expression)} )');
      }

      cols.add(colSpec.toString());
    }

    sb.write(cols.join(','));
  }

  {
    final uniques = <CreateCol>[];
    final compositeUniques = <String, List<CreateCol>>{};
    final foreigns = <String, Map<String, String>>{};
    for (CreateCol col in info.columns.values) {
      if (col.foreign != null) {
        if (!foreigns.containsKey(col.foreign.table)) {
          foreigns[col.foreign.table] = <String, String>{};
        }
        foreigns[col.foreign.table][col.name] = col.foreign.col;
      }

      final Unique uniqueSpec = col.constraints.firstWhere((c) => c is Unique, orElse: () => null) as Unique;
      if (uniqueSpec != null) {
        if (uniqueSpec.group == null) {
          uniques.add(col);
        } else {
          compositeUniques[uniqueSpec.group] = (compositeUniques[uniqueSpec.group] ?? <CreateCol>[])..add(col);
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

    for (CreateCol col in uniques) {
      sb.write(', UNIQUE(${col.name})');
    }

    for (String group in compositeUniques.keys) {
      final String str = compositeUniques[group].map((CreateCol col) => col.name).join(', ');
      sb.write(', UNIQUE($str)');
    }
  }

  sb.write(')');

  return sb.toString();
}
