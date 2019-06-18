import 'package:meta/meta.dart';

export 'relations.dart';

abstract class ColumnDef {}

class Column implements ColumnDef {
  final String name;

  final bool isNullable;

  final bool isPrimary;

  final String unique;

  const Column(
      {this.name, this.isNullable = true, this.isPrimary = false, this.unique});
}

abstract class DataType implements ColumnDef {}

class Int implements DataType {
  final bool auto;

  const Int({this.auto = false});
}

class VarChar implements DataType {
  final int length;

  const VarChar(this.length);
}

const auto = Int(auto: true);

abstract class ForeignBase implements ColumnDef {
  String get references;
}

class ForeignKey implements ForeignBase {
  final String toTable;

  final String references;

  const ForeignKey(this.toTable, {@required this.references});
}

class BelongsTo implements ForeignBase {
  final Type bean;

  /// The field/column in the foreign bean
  final String references;

  // TODO what is this?
  final bool byHasMany;

  // TODO what is this?
  final bool toMany;

  const BelongsTo(this.bean, {@required this.references, this.byHasMany})
      : toMany = false;

  const BelongsTo.many(this.bean, {@required this.references, this.byHasMany})
      : toMany = true;
}

class IgnoreColumn implements ColumnDef {
  const IgnoreColumn();
}

const primaryKey = Column(isPrimary: true);

const ignoreColumn = IgnoreColumn();
