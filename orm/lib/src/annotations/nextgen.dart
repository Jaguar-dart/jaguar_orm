class Column {
  final String name;

  final bool isNullable;

  const Column(this.name, {this.isNullable});
}

class Unique {
  final String name;

  const Unique(this.name);
}

/// Column is a primary key
class Primary {
  const Primary();
}

class VarChar {
  final int length;

  const VarChar(this.length);
}

abstract class ForeignBase {
  String get refCol;
}

class Foreign implements ForeignBase {
  final String toTable;

  final String refCol;

  const Foreign(this.toTable, {this.refCol = 'id'});
}

class BelongsTo implements ForeignBase {
  final Type bean;

  /// The field/column in the foreign bean
  final String refCol;

  // TODO what is this?
  final bool byHasMany;

  // TODO what is this?
  final bool toMany;

  BelongsTo(this.bean, {this.refCol = 'id', this.byHasMany}) : toMany = false;

  const BelongsTo.many(this.bean, {this.refCol = 'id', this.byHasMany})
      : toMany = true;
}
