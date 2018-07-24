import 'package:source_gen/source_gen.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:analyzer/dart/element/element.dart';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

final isGenBean = new TypeChecker.fromRuntime(GenBean);

final isBean = new TypeChecker.fromRuntime(Bean);

final isIgnore = new TypeChecker.fromRuntime(IgnoreColumn);

final isColumnBase = new TypeChecker.fromRuntime(ColumnBase);

final isColumn = new TypeChecker.fromRuntime(Column);

final isPrimaryKey = new TypeChecker.fromRuntime(PrimaryKey);

final isForeignKey = new TypeChecker.fromRuntime(ForeignKey);

final isBelongsTo = new TypeChecker.fromRuntime(BelongsTo);

final isRelation = new TypeChecker.fromRuntime(Relation);

final isHasOne = new TypeChecker.fromRuntime(HasOne);

final isHasMany = new TypeChecker.fromRuntime(HasMany);

final isManyToMany = new TypeChecker.fromRuntime(ManyToMany);

final isList = new TypeChecker.fromRuntime(List);

final isMap = new TypeChecker.fromRuntime(Map);

final isString = new TypeChecker.fromRuntime(String);

final isInt = new TypeChecker.fromRuntime(int);

final isDouble = new TypeChecker.fromRuntime(double);

final isNum = new TypeChecker.fromRuntime(num);

final isDateTime = new TypeChecker.fromRuntime(DateTime);

final isBool = new TypeChecker.fromRuntime(bool);

bool isBuiltin(DartType type) {
  if (isString.isExactlyType(type)) return true;
  if (isInt.isExactlyType(type)) return true;
  if (isDouble.isExactlyType(type)) return true;
  if (isNum.isExactlyType(type)) return true;
  if (isBool.isExactlyType(type)) return true;

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
