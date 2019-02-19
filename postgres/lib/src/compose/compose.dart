library query.compose;

import 'package:jaguar_query/jaguar_query.dart';

part 'alter.dart';
part 'create.dart';
part 'delete.dart';
part 'expression.dart';
part 'insert.dart';
part 'update.dart';

String composeSelColumn(final SelColumn column) {
  if (column is CountSelColumn) {
    String ret = 'COUNT(';

    if (column.isDistinct) {
      ret += 'DISTINCT ';
    }

    ret += '${column.name})';

    if (column.alias is String) {
      ret += ' as ${column.alias}';
    }

    return ret;
  } else {
    String ret = column.name;

    if (column.alias is String) {
      ret += ' as "${column.alias}"';
    }

    return ret;
  }
}

String composeTableName(final TableName name) {
  String ret = '${name.tableName}';
  if (name.alias is String) {
    ret += ' AS ${name.alias}';
  }
  return ret;
}

String composeJoinedTable(final JoinedTable join) {
  join.validate();

  final sb = new StringBuffer();

  final QueryJoinedTableInfo info = join.info;

  sb.write(info.type.string);
  sb.write(' ' + composeTableName(info.to));

  if (info.on.length != 0) {
    sb.write(' ON ');
    sb.write(composeAnd(info.on));
  }

  return sb.toString();
}

String composeOrderBy(final OrderBy orderBy) =>
    '${orderBy.columnName} ' + (orderBy.ascending ? 'ASC' : 'DESC');

String composeFind(final Find find) {
  final ImmutableFindStatement info = find.asImmutable;
  final sb = new StringBuffer();
  sb.write('SELECT ');

  if (info.selects.length == 0) {
    sb.write('* ');
  } else {
    sb.write(info.selects.map(composeSelColumn).toList().join(', '));
  }

  sb.write(' FROM ');
  sb.write(composeTableName(info.from));

  for (JoinedTable tab in info.joins) {
    sb.write(' ');
    sb.write(composeJoinedTable(tab));
  }

  if (info.where.length != 0) {
    sb.write(' WHERE ');
    sb.write(composeExpression(info.where));
  }

  if (info.orderBy.length != 0) {
    sb.write(' ORDER BY ');
    sb.write(info.orderBy.map(composeOrderBy).join(', '));
  }

  if (info.limit is int) {
    sb.write(' LIMIT ');
    sb.write(info.limit);
  }

  if (info.offset is int) {
    sb.write(' OFFSET ');
    sb.write(info.offset);
  }

  if (info.groupBy.length != 0) {
    sb.write(' GROUP BY ');
    sb.write(info.groupBy.join(', '));
  }

  sb.write(';');

  return sb.toString();
}
