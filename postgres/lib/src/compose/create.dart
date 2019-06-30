part of query.compose;

String composeDataType(final DataType type) {
  if (type == null) throw Exception("Data type cannot be null!");
  if (type is Int) {
    if (type.auto) {
      return 'INT GENERATED ALWAYS AS IDENTITY';
    } else {
      return 'INT';
    }
  } else if (type is prefix0.Double) {
    return 'DECIMAL';
  } else if (type is Array) {
    return composeDataType(type.itemType) + '[]';
  } else if (type is HStore) {
    return 'HSTORE';
  } else if (type is Timestamp) {
    return 'TIMESTAMP';
  } else if (type is Str) {
    if (type.length == null) return 'TEXT';
    return 'VARCHAR(${type.length})';
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
  final sb = StringBuffer();

  sb.write('CREATE TABLE');

  if (info.ifNotExists) sb.write(' IF NOT EXISTS');

  sb.write(' ${info.name} (');

  sb.write(info.columns.values.map(composeProperty).join(', '));

  final List<CreateCol> primaries =
      info.columns.values.where((CreateCol col) => col.isPrimary).toList();
  if (primaries.length != 0) {
    sb.write(', PRIMARY KEY (');
    sb.write(primaries.map((CreateCol col) => col.name).join(','));
    sb.write(')');
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

      final Unique uniqueSpec = col.constraints
          .firstWhere((c) => c is Unique, orElse: () => null) as Unique;
      if (uniqueSpec != null) {
        if (uniqueSpec.group == null) {
          uniques.add(col);
        } else {
          compositeUniques[uniqueSpec.group] =
              (compositeUniques[uniqueSpec.group] ?? <CreateCol>[])..add(col);
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
      final String str =
          compositeUniques[group].map((CreateCol col) => col.name).join(', ');
      sb.write(', UNIQUE($str)');
    }
  }

  sb.write(')');

  return sb.toString();
}
