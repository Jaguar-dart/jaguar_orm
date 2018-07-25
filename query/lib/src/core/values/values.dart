part of query;

class Col<ValType> {
  final String field;

  final String tableAlias;

  const Col(this.field, [this.tableAlias]);

  /// DSL to create 'is equal to' relational condition
  Cond<ValType> eq(ValType rhs) => Cond.eq<ValType>(this, rhs);

  /// DSL to create 'is equal to' relational condition
  CondCol<ValType> eqC(Col<ValType> rhs) => CondCol.eq<ValType>(this, rhs);

  static Col<core.int> int(String field, [String tableName]) =>
      new Col<core.int>(field, tableName);

  static Col<core.double> double(String field, [String tableName]) =>
      new Col<core.double>(field, tableName);

  static Col<String> string(String field, [String tableName]) =>
      new Col<String>(field, tableName);

  static Col<DateTime> datetime(String field, [String tableName]) =>
      new Col<DateTime>(field, tableName);

  static Col<core.bool> bool(String field, [String tableName]) =>
      new Col<core.bool>(field, tableName);
}
