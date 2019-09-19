part of query.compose;

String composeExpression(final Expression exp) {
  if (exp is ToDialect) {
    final ret = (exp as ToDialect).toDialect(postgresDialect, composer);
    if (ret is String) return ret;
    if (ret is Expression) return composeExpression(ret);
    throw UnsupportedError("${exp.runtimeType}.toDialect returned invalid literal: $ret");
  }

  if (exp is I) return exp.name;
  if (exp is Literal) return composeLiteral(exp);
  if (exp is E) return exp.expr;
  if (exp is Not) return 'NOT ${composeExpression(exp.expr)}';
  if (exp is Exists) return 'EXISTS (${composeExpression(exp.expr)})';
  if (exp is Func) return composeFunc(exp);
  if (exp is RowSourceExpr) return composeRowSource(exp.expr);
  if (exp is MakeExpr) return composeExpression(exp.maker());

  if (exp is Or) return composeOr(exp);
  if (exp is And) return composeAnd(exp);
  if (exp is Cond) return '${composeExpression(exp.lhs)} ${exp.op.string} ${composeExpression(exp.rhs)}';
  if (exp is Between)
    return '(${composeExpression(exp.lhs)} BETWEEN ${composeExpression(exp.low)} AND ${composeExpression(exp.high)})';

  throw new Exception('Unknown expression ${exp.runtimeType}!');
}

String composeAnd(final And and) {
  final sb = StringBuffer();
  if (and.length != 1) sb.write('(');
  sb.write(and.expressions.map((Expression exp) => composeExpression(exp)).join(' AND '));
  if (and.length != 1) sb.write(')');
  return sb.toString();
}

String composeOr(final Or or) {
  final sb = StringBuffer();
  if (or.length != 1) sb.write('(');
  sb.write(or.expressions.map((Expression exp) => composeExpression(exp)).join(' OR '));
  if (or.length != 1) sb.write(')');
  return sb.toString();
}

String composeField(final Field col) => col.name;

String composeLiteral(Literal literal) {
  if (literal == null) return null;
  if (literal is ToDialect) {
    final val = (literal as ToDialect).toDialect(postgresDialect, composer);
    if (val is String) return val;
    if (val is Expression) return composeExpression(val);
    throw UnsupportedError("${literal.runtimeType}.toDialect returned invalid literal: $val");
  }

  if (literal is NilLiteral) return "NULL";

  final val = literal.value;

  if (val is int) return "$val";
  if (val is num) return "$val";
  if (val is String) return "'${sqlStringEscape(val)}'";
  if (val is double) return "$val";
  if (val is DateTime) return '"$val"';
  if (val is bool) return val ? "1" : "0";
  if (val is Field) return composeField(val);

  throw new Exception("Invalid type ${val.runtimeType}!");
}

String sqlStringEscape(String input) => input.replaceAll("'", "''");

String composeFunc(Func func) {
  var sb = StringBuffer();

  sb.write(func.name);

  sb.write('(');

  sb.write(func.args.map((s) => composeExpression(s)).join(', '));

  sb.write(')');

  return sb.toString();
}
