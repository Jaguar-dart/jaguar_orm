part of jaguar_orm.generator.parser;

class ParsedDelete {
  final MethodElementWrap method;

  final List<ParsedWhere> wheres;

  ParsedDelete(this.method, this.wheres);

  String get methodHeader =>
      method.prototype.substring(0, method.prototype.length - 2);

  static ParsedDelete detect(MethodElementWrap method) {
    {
      bool isDelete = method.metadata
          .map((AnnotationElementWrap annot) => annot.instantiated)
          .any((dynamic instantiated) => instantiated is ant.Delete);

      if (!isDelete) {
        return null;
      }
    }

    List<ParsedWhere> wheres =
        method.parameters.map(ParsedWhere.detect).expand((wh) => wh).toList();

    return new ParsedDelete(method, wheres);
  }
}
