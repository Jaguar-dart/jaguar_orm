import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/constant/value.dart';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_orm/src/annotations/column.dart';

final isGenBean = TypeChecker.fromRuntime(GenBean);

final isBean = TypeChecker.fromRuntime(Bean);

final isColumnDef = TypeChecker.fromRuntime(ColumnDef);

final isColumn = TypeChecker.fromRuntime(Column);

final isIgnore = TypeChecker.fromRuntime(IgnoreColumn);

final isConstraint = TypeChecker.fromRuntime(Constraint);

final isDataType = TypeChecker.fromRuntime(DataType);

final isReferences = TypeChecker.fromRuntime(References);

final isBelongsTo = TypeChecker.fromRuntime(BelongsTo);

final isRelation = TypeChecker.fromRuntime(Relation);

final isHasOne = TypeChecker.fromRuntime(HasOne);

final isHasMany = TypeChecker.fromRuntime(HasMany);

final isManyToMany = TypeChecker.fromRuntime(ManyToMany);

final isList = TypeChecker.fromRuntime(List);

final isMap = TypeChecker.fromRuntime(Map);

final isString = TypeChecker.fromRuntime(String);

final isInt = TypeChecker.fromRuntime(int);

final isDouble = TypeChecker.fromRuntime(double);

final isNum = TypeChecker.fromRuntime(num);

final isDateTime = TypeChecker.fromRuntime(DateTime);

final isDuration = TypeChecker.fromRuntime(Duration);

final isBool = TypeChecker.fromRuntime(bool);

bool isBuiltin(DartType type) {
  if (isString.isExactlyType(type)) return true;
  if (isInt.isExactlyType(type)) return true;
  if (isDouble.isExactlyType(type)) return true;
  if (isNum.isExactlyType(type)) return true;
  if (isBool.isExactlyType(type)) return true;
  // TODO DateTime
  // TODO Duration

  return false;
}

DartType getModelForBean(DartType bean) {
  ClassElement c = bean.element;
  InterfaceType i =
      c.allSupertypes.firstWhere((InterfaceType i) => isBean.isExactlyType(i));
  return i.typeArguments[0];
}

class FieldSpecException {
  String name;

  String message;

  FieldSpecException(this.name, this.message);

  String toString() => 'Field $name has exception: $message';
}

String uncap(String str) =>
    str.substring(0, 1).toLowerCase() + str.substring(1);

ElementAnnotation firstAnnotationOf(Element e, TypeChecker check) {
  for (ElementAnnotation ea in e.metadata) {
    if (check.isAssignableFromType(ea.computeConstantValue().type)) {
      return ea;
    }
  }
  return null;
}

bool isAnnotationOf(ElementAnnotation ea, TypeChecker check) {
  return check.isAssignableFromType(ea.computeConstantValue().type);
}

Type toDartType(DartType type) {
  if (isString.isExactlyType(type)) return String;
  if (isInt.isExactlyType(type)) return int;
  if (isDouble.isExactlyType(type)) return double;
  if (isNum.isExactlyType(type)) return double;
  if (isBool.isExactlyType(type)) return bool;
  if (isDateTime.isExactlyType(type)) return DateTime;
  if (isDuration.isExactlyType(type)) return Duration;

  return null;
}

String getString(/* ConstantReader | DartObject */ reader, String field) {
  if (reader is DartObject) reader = ConstantReader(reader);
  ConstantReader value = reader.read(field);
  if (value.isNull) return null;
  return value.stringValue;
}

bool getBool(/* ConstantReader | DartObject */ reader, String field) {
  if (reader is DartObject) reader = ConstantReader(reader);
  ConstantReader value = reader.read(field);
  if (value.isNull) return null;
  return value.boolValue;
}

int getInt(/* ConstantReader | DartObject */ reader, String field) {
  if (reader is DartObject) reader = ConstantReader(reader);
  ConstantReader value = reader.read(field);
  if (value.isNull) return null;
  return value.intValue;
}

DartType getType(/* ConstantReader | DartObject */ reader, String field) {
  if (reader is DartObject) reader = ConstantReader(reader);
  ConstantReader value = reader.read(field);
  if (value.isNull) return null;
  return value.typeValue;
}
