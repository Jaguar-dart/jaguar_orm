part of jaguar_orm.generator.parser;

class ParsedWhere {
  final ParameterElementWrap element;

  final ant.Where instantiated;

  ParsedWhere(this.element, this.instantiated);

  String get name => element.name;

  static List<ParsedWhere> detect(ParameterElementWrap param) {
    List<ParsedWhere> ret = [];
    for (final AnnotationElementWrap annot in param.metadata) {
      dynamic instantiated = annot.instantiated;
      if (instantiated is! ant.Where) {
        continue;
      }

      ret.add(new ParsedWhere(param, instantiated));
    }

    return ret;
  }
}

class ParsedFind {
  final MethodElementWrap method;

  final List<ParsedWhere> wheres;

  ParsedFind(this.method, this.wheres);

  String get methodHeader =>
      method.prototype.substring(0, method.prototype.length - 2);

  static ParsedFind detect(MethodElementWrap method) {
    {
      bool isFind = method.metadata
          .map((AnnotationElementWrap annot) => annot.instantiated)
          .any((dynamic instantiated) => instantiated is ant.Find);

      if (!isFind) {
        return null;
      }
    }

    List<ParsedWhere> wheres =
        method.parameters.map(ParsedWhere.detect).expand((wh) => wh).toList();

    return new ParsedFind(method, wheres);
  }
}
