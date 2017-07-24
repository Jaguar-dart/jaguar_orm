part of jaguar_orm.generator.parser;

class ParsedSetColumn {
  final ParameterElementWrap element;

  ParsedSetColumn(this.element);

  String get name => element.name;

  static ParsedSetColumn detect(ParameterElementWrap param) {
    for (final AnnotationElementWrap annot in param.metadata) {
      dynamic instantiated = annot.instantiated;
      if (instantiated is! ant.SetField) {
        continue;
      }

      return new ParsedSetColumn(param);
    }

    return null;
  }
}

class ParsedUpdate {
  final MethodElementWrap method;

  final List<ParsedWhere> wheres;

  final List<ParsedSetColumn> sets;

  ParsedUpdate(this.method, this.wheres, this.sets);

  String get methodHeader =>
      method.prototype.substring(0, method.prototype.length - 2);

  static ParsedUpdate detect(MethodElementWrap method) {
    {
      bool isUpdate = method.metadata
          .map((AnnotationElementWrap annot) => annot.instantiated)
          .any((dynamic instantiated) => instantiated is ant.Updater);

      if (!isUpdate) {
        return null;
      }
    }

    List<ParsedWhere> wheres =
        method.parameters.map(ParsedWhere.detect).expand((wh) => wh).toList();

    List<ParsedSetColumn> sets = method.parameters
        .map(ParsedSetColumn.detect)
        .where((ParsedSetColumn i) => i != null)
        .toList();

    return new ParsedUpdate(method, wheres, sets);
  }
}
