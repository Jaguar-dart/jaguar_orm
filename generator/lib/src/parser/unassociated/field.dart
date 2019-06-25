part of 'parser.dart';

Column readColumn(ConstantReader reader) {
  return Column(
      name: getString(reader, 'name'),
      notNull: getBool(reader, 'notNull'),
      isPrimary: getBool(reader, 'isPrimary'));
}

ReferencesSpec readReferences(ConstantReader reader) {
  final String table = getString(reader, 'table');
  final String col = getString(reader, 'col');
  final String name = getString(reader, 'name');

  if (table == null) {
    throw Exception("table of a Reference is mandatory!");
  }

  if (col == null) {
    throw Exception("col of a Reference is mandatory!");
  }

  return ReferencesSpec(table, col, name: name);
}

BelongsToSpec readBelongsTo(ConstantReader reader) {
  final DartType bean = getType(reader, 'bean');
  final String references = getString(reader, 'references');
  final bool byHasMany = getBool(reader, 'byHasMany');
  final bool toMany = getBool(reader, 'toMany');
  final String name = getString(reader, 'name');

  if (references == null) {
    throw Exception("references cannot be null on BelongsTo!");
  }

  if (bean == null) {
    throw Exception("bean cannot be null on BelongsTo!");
  }

  return BelongsToSpec(bean, references, byHasMany, toMany, name: name);
}

List<ColumnDef> _filterColumnDef(FieldElement f) {
  final ret = <ColumnDef>[];

  for (ElementAnnotation annot in f.metadata) {
    final obj = annot.computeConstantValue();
    final reader = ConstantReader(obj);

    if (reader.instanceOf(isColumn)) {
      ret.add(readColumn(reader));
    } else if (reader.instanceOf(isReferences)) {
      ret.add(readReferences(reader));
    } else if (reader.instanceOf(isBelongsTo)) {
      ret.add(readBelongsTo(reader));
    }
  }

  return ret;
}

Map<Type, String> _defaultDataTypeDef = const {
  int: "Int()",
  double: "Double()",
  bool: "Bool()",
  DateTime: "Timestamp()",
  String: "Str()",
  Duration: "Interval()",
};

Map<Type, String> _defaultDataType = const {
  int: "Int",
  double: "Double",
  bool: "Bool",
  DateTime: "Timestamp",
  String: "Str",
  Duration: "Interval",
};

Tuple3<String, String, bool> _makeDataType(FieldElement f) {
  ElementAnnotation annot = firstAnnotationOf(f, isDataType);

  // TODO proper error
  if (annot == null) {
    final dartType = toDartType(f.type);
    if (dartType == null) throw Exception("Unknown type!");
    final ret = _defaultDataTypeDef[dartType];
    if (ret == null) throw Exception("Unknownd type!");
    return Tuple3(_defaultDataType[dartType], ret, false);
  }

  final auto =
      getBool(ConstantReader(annot.computeConstantValue()), 'auto') ?? false;

  return Tuple3(annot.computeConstantValue().type.displayName,
      annot.toSource().substring(1), auto);
}

List<String> _parseConstraints(Element f) {
  return f.metadata
      .where((ea) => isAnnotationOf(ea, isConstraint))
      .map((ea) => ea.toSource().substring(1))
      .toList();
}

ParsedField _parseField(FieldElement f) {
  final metadata = _filterColumnDef(f);

  final dataType = _makeDataType(f);
  Column column = metadata.firstWhere((c) => c is Column, orElse: () => null);

  ForeignSpec foreign =
      metadata.firstWhere((c) => c is ForeignSpec, orElse: () => null);
  final constraints = _parseConstraints(f);

  return ParsedField(f.type.displayName, f.name,
      isAuto: dataType.item3,
      column: column,
      dataType: dataType.item1,
      dataTypeDecl: dataType.item2,
      foreign: foreign,
      isFinal: f.isFinal && f.getter.isSynthetic,
      constraints: constraints);
}
