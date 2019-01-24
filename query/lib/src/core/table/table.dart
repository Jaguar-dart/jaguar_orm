part of query;

/// Table selector
abstract class Table {}

/// TableName
class TableName implements Table {
  final String tableName;

  final String alias;

  TableName(this.tableName, [this.alias]);
}

/// A SQL join type that can be used in 'SELECT' statements
class JoinType {
  /// Identification code for this join type
  final int id;

  /// String representation of this join type
  final String string;

  const JoinType._(this.id, this.string);

  /// 'INNER JOIN' join type
  static const JoinType InnerJoin = const JoinType._(0, 'INNER JOIN');

  /// 'LEFT JOIN' join type
  static const JoinType LeftJoin = const JoinType._(1, 'LEFT JOIN');

  /// 'RIGHT JOIN' join type
  static const JoinType RightJoin = const JoinType._(2, 'RIGHT JOIN');

  /// 'FULL JOIN' join type
  static const JoinType FullJoin = const JoinType._(3, 'FULL JOIN');

  /// 'CROSS JOIN' join type
  static const JoinType CrossJoin = const JoinType._(4, 'CROSS JOIN');
}

class JoinedTable implements Table {
  final JoinType _type;

  final TableName _to;

  final _on = And();

  JoinedTable(this._type, String tableName, [String alias])
      : _to = TableName(tableName, alias) {
    _info = QueryJoinedTableInfo(this);
  }

  factory JoinedTable.innerJoin(String tableName, [String alias]) =>
      JoinedTable(JoinType.InnerJoin, tableName, alias);

  factory JoinedTable.leftJoin(String tableName, [String alias]) =>
      JoinedTable(JoinType.LeftJoin, tableName, alias);

  factory JoinedTable.rightJoin(String tableName, [String alias]) =>
      JoinedTable(JoinType.RightJoin, tableName, alias);

  factory JoinedTable.fullJoin(String tableName, [String alias]) =>
      JoinedTable(JoinType.FullJoin, tableName, alias);

  factory JoinedTable.crossJoin(String tableName, [String alias]) =>
      JoinedTable(JoinType.CrossJoin, tableName, alias);

  JoinedTable joinOn(Expression onExp) {
    if (_type == null || _to == null) {
      throw Exception('Query has no join on it!');
    }

    _on.and(onExp);

    return this;
  }

  void validate() {
    if (_to == null) {
      if (_type != null || _on.length != 0) {
        throw Exception('Join not initialized properly!');
      }
    } else {
      if (_type == null || _on.length == 0) {
        throw Exception('Join not initialized properly!');
      }
    }
  }

  QueryJoinedTableInfo _info;

  QueryJoinedTableInfo get info => _info;
}

class QueryJoinedTableInfo {
  final JoinedTable _inner;

  QueryJoinedTableInfo(this._inner);

  JoinType get type => _inner._type;

  TableName get to => _inner._to;

  // TODO immutable
  And get on => _inner._on;
}
