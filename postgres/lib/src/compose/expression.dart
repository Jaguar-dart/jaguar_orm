part of query.compose;

String composeExpression(final Expression exp) {
  if (exp is ToDialect) {
    final ret = (exp as ToDialect).toDialect("postgres");
    if (ret is String) return ret;
    if (ret is Expression) return composeExpression(ret);
    throw UnsupportedError(
        "${exp.runtimeType}.toDialect returned invalid literal: $ret");
  }

  if (exp is I) return exp.name;
  if (exp is Literal) return composeLiteral(exp);
  if (exp is E) return exp.expr;
  if (exp is Not) return 'NOT ${composeExpression(exp.expr)}';
  if (exp is Exists) return 'EXISTS (${composeExpression(exp.expr)})';
  if (exp is Func) return composeFunc(exp);

  if (exp is Or) {
    final sb = StringBuffer();
    if (exp.length != 1) sb.write('(');
    sb.write(exp.expressions
        .map((Expression exp) => composeExpression(exp))
        .join(' OR '));
    if (exp.length != 1) sb.write(')');
    return sb.toString();
  }

  if (exp is And) {
    final sb = StringBuffer();
    if (exp.length != 1) sb.write('(');
    sb.write(exp.expressions
        .map((Expression exp) => composeExpression(exp))
        .join(' AND '));
    if (exp.length != 1) sb.write(')');
    return sb.toString();
  }

  if (exp is Cond) {
    return '${composeExpression(exp.lhs)} ${exp.op.string} ${composeExpression(exp.rhs)}';
  }

  if (exp is Between) {
    return '(${composeExpression(exp.lhs)} BETWEEN ${composeExpression(exp.low)} AND ${composeExpression(exp.high)})';
  }

  throw Exception('Unknown expression ${exp.runtimeType}!');
}

String composeField(final Field field) => field.name;

String composeLiteral(Literal literal) {
  if (literal is ToDialect) {
    final val = (literal as ToDialect).toDialect(postgresDialect);
    if (val is String) return val;
    if (val is Expression) return composeExpression(val);
    throw UnsupportedError(
        "${literal.runtimeType}.toDialect returned invalid literal: $val");
  }

  if (literal is NilLiteral) return "NULL";

  final val = literal.value;

  if (val is num) return "$val";
  if (val is String) return "'${sqlStringEscape(val)}'";
  if (val is DateTime) return "$val"; //TODO
  if (val is bool) return val ? 'TRUE' : 'FALSE';
  if (val is Duration) return "$val"; //TODO

  throw Exception("Invalid type ${val.runtimeType}!");
}

/*
String composeValue(dynamic val) {
  if (val == null) return null;
  if (val is int) {
    return "$val";
  } else if (val is String) {
    return "'${sqlStringEscape(val)}'";
  } else if (val is double || val is num) {
    return "$val";
  } else if (val is DateTime) {
    return "$val"; //TODO
  } else if (val is bool) {
    return val ? 'TRUE' : 'FALSE';
  } else if (val is Field) {
    return composeField(val);
  } else {
    throw Exception("Invalid type ${val.runtimeType}!");
  }
}
 */

String sqlStringEscape(String input) => input.replaceAll("'", "''");

String composeFunc(Func func) {
  var sb = StringBuffer();

  sb.write(func.name);

  sb.write('(');

  sb.write(func.args.map((s) => composeExpression(s)).join(', '));

  sb.write(')');

  return sb.toString();
}
