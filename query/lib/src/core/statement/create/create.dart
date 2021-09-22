part of query;

class Create implements Statement {
  final String name;

  final bool ifNotExists;

  final Map<String, CreateColumn> _columns = {};

  Create(this.name, {this.ifNotExists = false}) {
    _immutable = ImmutableCreateStatement(this);
  }

  Create addInt(String name,
      {bool isNullable = false,
      bool autoIncrement = false,
      bool primary = false,
      String? foreignTable,
      String? foreignCol,
      String? uniqueGroup}) {
    Foreign? foreign;
    if (foreignTable != null) {
      foreign = Foreign(foreignTable, foreignCol != null ? foreignCol : name);
    }
    _columns[name] = CreateInt(name,
        isNullable: isNullable,
        autoIncrement: autoIncrement,
        isPrimary: primary,
        foreignKey: foreign,
        uniqueGroup: uniqueGroup);
    return this;
  }

  Create addPrimaryInt(String name,
      {String? foreignTable, String? foreignCol, String? uniqueGroup}) {
    Foreign? foreign;
    if (foreignTable != null) {
      foreign = Foreign(foreignTable, foreignCol != null ? foreignCol : name);
    }
    _columns[name] =
        CreateInt.primary(name, foreignKey: foreign, uniqueGroup: uniqueGroup);
    return this;
  }

  Create addAutoPrimaryInt(String name, {String? uniqueGroup}) {
    _columns[name] = CreateInt.autoPrimary(name, uniqueGroup: uniqueGroup);
    return this;
  }

  Create addDouble(String name,
      {bool isNullable = false,
      bool primary = false,
      String? foreignTable,
      String? foreignCol,
      String? uniqueGroup}) {
    Foreign? foreign;
    if (foreignTable != null) {
      foreign = Foreign(foreignTable, foreignCol != null ? foreignCol : name);
    }
    _columns[name] = CreateDouble(name,
        isNullable: isNullable,
        isPrimary: primary,
        foreignKey: foreign,
        uniqueGroup: uniqueGroup);
    return this;
  }

  Create addBool(String name, {bool isNullable = false, String? uniqueGroup}) {
    _columns[name] =
        CreateBool(name, isNullable: isNullable, uniqueGroup: uniqueGroup);
    return this;
  }

  Create addDateTime(String name,
      {bool isNullable = false, String? uniqueGroup}) {
    _columns[name] =
        CreateDateTime(name, isNullable: isNullable, uniqueGroup: uniqueGroup);
    return this;
  }

  Create addStr(String name,
      {bool isNullable = false,
      int length = 20,
      bool primary = false,
      String? foreignTable,
      String? foreignCol,
      String? uniqueGroup}) {
    Foreign? foreign;
    if (foreignTable != null) {
      foreign = Foreign(foreignTable, foreignCol != null ? foreignCol : name);
    }
    _columns[name] = CreateStr(name,
        isNullable: isNullable,
        length: length,
        isPrimary: primary,
        foreignKey: foreign,
        uniqueGroup: uniqueGroup);
    return this;
  }

  Create addPrimaryStr(String name,
      {int length = 20,
      String? foreignTable,
      String? foreignCol,
      String? uniqueGroup}) {
    Foreign? foreign;
    if (foreignTable != null) {
      foreign = Foreign(foreignTable, foreignCol != null ? foreignCol : name);
    }
    _columns[name] = CreateStr.primary(name,
        length: length, foreignKey: foreign, uniqueGroup: uniqueGroup);
    return this;
  }

  Create addColumn(CreateColumn column) {
    _columns[column.name] = column;
    return this;
  }

  Create addColumns(List<CreateColumn> columns) {
    for (CreateColumn col in columns) {
      _columns[col.name] = col;
    }
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.createTable(this);

  late ImmutableCreateStatement _immutable;

  ImmutableCreateStatement get asImmutable => _immutable;
}

class ImmutableCreateStatement {
  final Create _inner;

  ImmutableCreateStatement(this._inner)
      : columns = UnmodifiableMapView<String, CreateColumn>(_inner._columns);

  String get name => _inner.name;

  final UnmodifiableMapView<String, CreateColumn> columns;

  bool get ifNotExists => _inner.ifNotExists;
}

/// Clause to create a column in a SQL table.
abstract class CreateColumn<ValType> {
  String get name;

  bool get isNullable;

  bool get isPrimary;

  Foreign? get foreignKey;

  String? get uniqueGroup;
}

class Foreign {
  /// The table in which foreign key references the column [col]
  final String table;

  /// References column in table [table]
  final String col;

  const Foreign(this.table, this.col);
}
