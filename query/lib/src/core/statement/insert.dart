part of query;

class Insert implements Statement {
  String _tableName;

  String _id;

  final Map<String, dynamic> _values = {};

  Insert() {
    _info = new QueryInsertInfo(this);
  }

  String get tableName => _tableName;

  Insert into(String tableName) {
    if (_tableName != null) {
      throw new Exception("Name already assigend!");
    }
    _tableName = tableName;
    return this;
  }

  Insert id(String id) {
    _id = id;
    return this;
  }

  Insert setId<ValType>(Field<ValType> field, ValType value) {
    _id = field.name;
    return set<ValType>(field, value);
  }

  Insert set<ValType>(Field<ValType> field, ValType value) {
    setValue(field.name, value);
    return this;
  }

  Insert setMany(List<SetColumn> columns) {
    columns.forEach((SetColumn column) {
      setValue(column._column, column._value);
    });
    return this;
  }

  Insert setIdValue<ValType>(String column, ValType value) {
    _id = column;
    return setValue<ValType>(column, value);
  }

  Insert setValue<ValType>(String column, ValType value) {
    _values[column] = value;
    return this;
  }

  Insert setInt(String column, int value) {
    _values[column] = value;
    return this;
  }

  Insert setString(String column, String value) {
    _values[column] = value;
    return this;
  }

  Insert setBool(String column, bool value) {
    _values[column] = value;
    return this;
  }

  Insert setDateTime(String column, DateTime value) {
    _values[column] = value;
    return this;
  }

  Insert setValues(Map<String, dynamic> values) {
    _values.addAll(values);
    return this;
  }

  Future<T> exec<T>(Adapter adapter) => adapter.insert<T>(this);

  QueryInsertInfo _info;

  QueryInsertInfo get info => _info;
}

class QueryInsertInfo {
  final Insert _inner;

  QueryInsertInfo(this._inner)
      : values = new UnmodifiableMapView<String, dynamic>(_inner._values);

  String get tableName => _inner.tableName;

  String get id => _inner._id;

  final UnmodifiableMapView<String, dynamic> values;
}
