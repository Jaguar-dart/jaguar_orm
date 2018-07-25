part of query.compose;

String composeAnd(final And and) => and.expressions.map((Expression exp) {
      final sb = new StringBuffer();

      if (exp.length != 1) {
        sb.write('(');
      }

      sb.write(composeExpression(exp));

      if (exp.length != 1) {
        sb.write(')');
      }

      return sb.toString();
    }).join(' AND ');

String composeOr(final Or or) => or.expressions.map((Expression exp) {
      StringBuffer sb = new StringBuffer();

      if (exp.length != 1) {
        sb.write('(');
      }

      sb.write(composeExpression(exp));

      if (exp.length != 1) {
        sb.write(')');
      }

      return sb.toString();
    }).join(' OR ');

String composeExpression(final Expression exp) {
  if (exp is Or) {
    return composeOr(exp);
  } else if (exp is And) {
    return composeAnd(exp);
  } else if (exp is Cond) {
    return '${composeCol(exp.lhs)} ${exp.op.string} ${composeValue(exp.rhs)}';
  } else if (exp is CondCol) {
    return '${composeCol(exp.lhs)} ${exp.op.string} ${composeCol(exp.rhs)}';
  } else if (exp is Between) {
    return '(${composeCol(exp.field)} BETWEEN ${composeValue(exp.low)} AND ${composeValue(exp.high)})';
  } else if (exp is InBetweenCol) {
    return '(${composeCol(exp.field)} BETWEEN ${composeCol(exp.low)} AND ${composeCol(exp.high)})';
  } else {
    throw new Exception('Unknown expression ${exp.runtimeType}!');
  }
}

String composeCol(final Col col) =>
    (col.tableAlias != null ? col.tableAlias + '.' : '') + col.field;

String composeValue(dynamic val) {
  if (val == null) return null;
  if (val is int) {
    return "$val";
  } else if (val is String) {
    return "'$val'";
  } else if (val is double || val is num) {
    return "$val";
  } else if (val is DateTime) {
    return '"$val"';
  } else if (val is bool) {
    return val ? "1" : "0";
  } else if (val is Col) {
    return composeCol(val);
  } else {
    throw new Exception("Invalid type ${val.runtimeType}!");
  }
}
