import 'package:meta/meta.dart';

export 'relations.dart';
export 'package:jaguar_query/jaguar_query.dart' show References;

abstract class ColumnDef {}

class Column implements ColumnDef {
  final String name;

  final bool notNull;

  final bool isPrimary;

  const Column({this.name, this.notNull = false, this.isPrimary = false});
}

class BelongsTo implements ColumnDef {
  final Type bean;

  /// The field/column in the foreign bean
  final String references;

  final bool byHasMany;

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
