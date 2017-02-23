library jaguar_orm.generator.parser;

import 'package:analyzer/dart/element/element.dart';

import 'package:source_gen_help/source_gen_help.dart';

import 'package:jaguar_orm/src/annotations/annotations.dart' as ant;

part 'methods/find.dart';
part 'methods/delete.dart';
part 'methods/update.dart';

class ParsedColumn {
  final FieldElement element;

  final ant.ColumnBase instantiated;

  final DartTypeWrap fieldType;

  ParsedColumn(this.element, this.fieldType, this.instantiated);

  String get key => instantiated.key ?? name;

  String get name => element.name;

  bool get isPrimary => instantiated is ant.PrimaryKey;

  static ParsedColumn detect(FieldElement f) {
    //If IgnoreField is present, skip!
    {
      int ignore = f.metadata
          .map((ElementAnnotation annot) => new AnnotationElementWrap(annot))
          .map((AnnotationElementWrap annot) => annot.instantiated)
          .where((dynamic instantiated) => instantiated is ant.IgnoreColumn)
          .length;

      if (ignore != 0) {
        return null;
      }
    }

    DartTypeWrap fieldType = new DartTypeWrap(f.type);

    if (f.isStatic || (!fieldType.isBuiltin && !fieldType.isDateTime)) {
      return null;
    }

    List<ant.ColumnBase> columns = f.metadata
        .map((ElementAnnotation annot) => new AnnotationElementWrap(annot))
        .map((AnnotationElementWrap annot) => annot.instantiated)
        .where((dynamic instantiated) => instantiated is ant.ColumnBase)
        .toList() as List<ant.ColumnBase>;

    if (columns.length > 1) {
      throw new Exception('Only one Column annotation is allowed on a Field!');
    }

    if (columns.length == 0) {
      return new ParsedColumn(f, fieldType, new ant.Column());
    }

    return new ParsedColumn(f, fieldType, columns.first);
  }
}

const NamedElement kTypeBean =
    const NamedElementImpl.Make('Bean', 'jaguar_orm.bean');

class ParsedBean {
  final ClassElementWrap clazz;

  final DartTypeWrap model;

  final List<ParsedColumn> columns;

  final ParsedColumn primary;

  final List<ParsedFind> finds;

  final List<ParsedUpdate> updates;

  final List<ParsedDelete> deletes;

  ParsedBean(this.clazz, this.model, this.columns, this.primary, this.finds,
      this.updates, this.deletes);

  String get name => clazz.name;

  static ParsedBean detect(ClassElementWrap clazz, ant.GenBean gen) {
    InterfaceTypeWrap interface = clazz.getSubtypeOf(kTypeBean);

    if (interface == null) {
      throw new Exception("Beans must implement Bean interface!");
    }

    DartTypeWrap model = interface.typeArguments.first;

    if (model.isDynamic) {
      throw new Exception("Don't support Model of type dynamic!");
    }

    List<ParsedColumn> columns = model.clazz.fields
        .map(ParsedColumn.detect)
        .where((ParsedColumn col) => col is ParsedColumn)
        .toList();

    List<ParsedColumn> primaries =
        columns.where((ParsedColumn col) => col.isPrimary).toList();

    if (primaries.length > 1) {
      throw new Exception('Only one primary key allowed!');
    }

    ParsedColumn primary = primaries.length == 1 ? primaries.first : null;

    List<ParsedFind> finds = clazz.methods
        .map(ParsedFind.detect)
        .where((ParsedFind f) => f != null)
        .toList();

    List<ParsedUpdate> updates = clazz.methods
        .map(ParsedUpdate.detect)
        .where((ParsedUpdate f) => f != null)
        .toList();

    List<ParsedDelete> deletes = clazz.methods
        .map(ParsedDelete.detect)
        .where((ParsedDelete f) => f != null)
        .toList();

    return new ParsedBean(
        clazz, model, columns, primary, finds, updates, deletes);
  }
}
