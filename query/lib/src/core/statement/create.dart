part of query;

class Foreign {
  /// The table in which foreign key references the column [col]
  final String table;

  /// References column in table [table]
  final String col;

  const Foreign(this.table, this.col);

  static Foreign make(String table, String refCol) =>
      new Foreign(table, refCol);
}

class Unique {
  final bool unique;

  final String group;

  const Unique([this.group]) : unique = true;

  const Unique.Not()
      : unique = false,
        group = null;
}

abstract class CreateColumn<ValType> {
  String get colName;

  bool get isNullable;

  bool get isPrimaryKey;

  Foreign get foreignKey;

  Unique get unique;
}

class CreateInt extends CreateColumn<int> {
  bool _nullable = false;

  String _colName;

  bool _autoIncrement = false;

  bool _primary = false;

  Foreign _foreignKey;

  Unique _unique;

  CreateInt(this._colName,
      {bool nullable: false,
      bool autoIncrement: false,
      bool primary: false,
      Foreign foreignKey,
      Unique unique: const Unique.Not()})
      : _nullable = nullable,
        _autoIncrement = autoIncrement,
        _primary = primary,
        _foreignKey = foreignKey,
        _unique = unique;

  CreateInt.Primary(this._colName, {Foreign foreignKey})
      : _primary = true,
        _foreignKey = foreignKey;

  CreateInt.AutoPrimary(this._colName)
      : _primary = true,
        _autoIncrement = true;

  CreateInt nullable() {
    _nullable = true;
    return this;
  }

  CreateInt foreign(String table, {String refCol}) {
    if (_foreignKey != null) throw new Exception("Foreign key alread set!");
    if (refCol == null) refCol = _colName;
    _foreignKey = new Foreign(table, refCol);
    return this;
  }

  String get colName => _colName;

  bool get isNullable => _nullable;

  bool get isPrimaryKey => _primary;

  Foreign get foreignKey => _foreignKey;

  Unique get unique => _unique;

  bool get autoIncrement => _autoIncrement;
}

class CreateDouble extends CreateColumn<double> {
  bool _nullable = false;

  String _colName;

  bool _autoIncrement = false;

  bool _primary = false;

  Foreign _foreignKey;

  Unique _unique;

  CreateDouble(this._colName,
      {bool nullable: false,
      bool autoIncrement: false,
      bool primary: false,
      Foreign foreignKey,
      Unique unique: const Unique.Not()})
      : _nullable = nullable,
        _autoIncrement = autoIncrement,
        _primary = primary,
        _foreignKey = foreignKey,
        _unique = unique;

  CreateDouble.Primary(this._colName, {Foreign foreignKey})
      : _primary = true,
        _foreignKey = foreignKey;

  CreateDouble.AutoPrimary(this._colName)
      : _primary = true,
        _autoIncrement = true;

  CreateDouble nullable() {
    _nullable = true;
    return this;
  }

  CreateDouble foreign(String table, {String refCol}) {
    if (_foreignKey != null) throw new Exception("Foreign key alread set!");
    if (refCol == null) refCol = _colName;
    _foreignKey = new Foreign(table, refCol);
    return this;
  }

  String get colName => _colName;

  bool get isNullable => _nullable;

  bool get isPrimaryKey => _primary;

  Foreign get foreignKey => _foreignKey;

  Unique get unique => _unique;
}

class CreateBool extends CreateColumn<bool> {
  bool _nullable = false;

  String _colName;

  bool _primary = false;

  Unique _unique;

  CreateBool(this._colName,
      {bool nullable: false,
      bool primary: false,
      Unique unique: const Unique.Not()})
      : _nullable = nullable,
        _primary = primary,
        _unique = unique;

  CreateBool nullable() {
    _nullable = true;
    return this;
  }

  String get colName => _colName;

  bool get isNullable => _nullable;

  bool get isPrimaryKey => _primary;

  Foreign get foreignKey => null;

  Unique get unique => _unique;
}

class CreateDateTime extends CreateColumn<DateTime> {
  bool _nullable = false;

  String _colName;

  bool _primary = false;

  Unique _unique;

  CreateDateTime(this._colName,
      {bool nullable: false,
      bool primary: false,
      Unique unique: const Unique.Not()})
      : _nullable = nullable,
        _primary = primary,
        _unique = unique;

  CreateDateTime nullable() {
    _nullable = true;
    return this;
  }

  String get colName => _colName;

  bool get isNullable => _nullable;

  bool get isPrimaryKey => _primary;

  Foreign get foreignKey => null;

  Unique get unique => _unique;
}

class CreateStr extends CreateColumn<String> {
  bool _nullable = false;

  String _colName;

  bool _primary = false;

  int _length = 20;

  Foreign _foreignKey;

  Unique _unique;

  CreateStr(this._colName,
      {bool nullable: false,
      bool primary: false,
      int length: 20,
      Foreign foreignKey,
      Unique unique: const Unique.Not()})
      : _nullable = nullable,
        _length = length,
        _primary = primary,
        _foreignKey = foreignKey,
        _unique = unique;

  CreateStr.Primary(this._colName, {int length: 20, Foreign foreignKey})
      : _primary = true,
        _length = length,
        _foreignKey = foreignKey;

  CreateStr nullable() {
    _nullable = true;
    return this;
  }

  CreateStr foreign(String table, {String refCol}) {
    if (_foreignKey != null) throw new Exception("Foreign key alread set!");
    if (refCol == null) refCol = _colName;
    _foreignKey = new Foreign(table, refCol);
    return this;
  }

  String get colName => _colName;

  bool get isNullable => _nullable;

  bool get isPrimaryKey => _primary;

  int get length => _length;

  Foreign get foreignKey => _foreignKey;

  Unique get unique => _unique;
}

class Create implements Statement {
  String _tableName;

  final Map<String, CreateColumn> _columns = {};

  bool _ifNotExists = false;

  Create() {
    _info = new QueryCreateInfo(this);
  }

  Create named(String tableName) {
    _tableName = tableName;
    return this;
  }

  Create ifNotExists([bool create = true]) {
    _ifNotExists = create;
    return this;
  }

  Create addInt(String colName,
      {bool autoIncrement: false,
      bool primary: false,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateInt(colName,
        autoIncrement: autoIncrement,
        primary: primary,
        foreignKey: foreign,
        unique: unique);
    return this;
  }

  Create addNullInt(String colName,
      {bool autoIncrement: false,
      bool primary: false,
      Foreign foreign,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateInt(colName,
        nullable: true,
        primary: primary,
        foreignKey: foreign,
        unique: unique,
        autoIncrement: autoIncrement);
    return this;
  }

  Create addDouble(String colName,
      {bool autoIncrement: false,
      bool primary: false,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateDouble(colName,
        autoIncrement: autoIncrement,
        primary: primary,
        foreignKey: foreign,
        unique: unique);
    return this;
  }

  Create addNullDouble(String colName,
      {bool autoIncrement: false,
      bool primary: false,
      Foreign foreign,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateDouble(colName,
        nullable: true,
        primary: primary,
        foreignKey: foreign,
        unique: unique,
        autoIncrement: autoIncrement);
    return this;
  }

  Create addBool(String colName, {Unique unique: const Unique.Not()}) {
    _columns[colName] = new CreateBool(colName, unique: unique);
    return this;
  }

  Create addNullBool(String colName, {Unique unique: const Unique.Not()}) {
    _columns[colName] = new CreateBool(colName).nullable();
    return this;
  }

  Create addDateTime(String colName, {Unique unique: const Unique.Not()}) {
    _columns[colName] = new CreateDateTime(colName, unique: unique);
    return this;
  }

  Create addNullDateTime(String colName, {Unique unique: const Unique.Not()}) {
    _columns[colName] = new CreateBool(colName, unique: unique).nullable();
    return this;
  }

  Create addStr(String colName,
      {int length: 20,
      bool primary: false,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateStr(colName,
        length: length, primary: primary, foreignKey: foreign, unique: unique);
    return this;
  }

  Create addNullStr(String colName,
      {int length: 20,
      bool primary: false,
      String foreignTable,
      String foreignCol,
      Unique unique: const Unique.Not()}) {
    Foreign foreign;
    if (foreignTable != null) {
      foreign =
          Foreign.make(foreignTable, foreignCol != null ? foreignCol : colName);
    }
    _columns[colName] = new CreateStr(colName,
            length: length,
            primary: primary,
            foreignKey: foreign,
            unique: unique)
        .nullable();
    return this;
  }

  Create addColumn(CreateColumn column) {
    _columns[column.colName] = column;
    return this;
  }

  Create addColumns(List<CreateColumn> columns) {
    for (CreateColumn col in columns) {
      _columns[col.colName] = col;
    }
    return this;
  }

  Future<void> exec(Adapter adapter) => adapter.createTable(this);

  QueryCreateInfo _info;

  QueryCreateInfo get info => _info;
}

class QueryCreateInfo {
  final Create _inner;

  QueryCreateInfo(this._inner)
      : columns =
            new UnmodifiableMapView<String, CreateColumn>(_inner._columns);

  String get tableName => _inner._tableName;

  final UnmodifiableMapView<String, CreateColumn> columns;

  bool get ifNotExists => _inner._ifNotExists;
}
