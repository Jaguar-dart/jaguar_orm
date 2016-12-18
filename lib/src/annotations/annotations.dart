library jaguar_orm.annotation;

class GenBean {
  const GenBean();
}

class IgnoreColumn {
  const IgnoreColumn();
}

abstract class ColumnBase {
  String get key;
}

class Column implements ColumnBase {
  final String key;

  const Column([this.key]);
}

class AddColumn implements ColumnBase {
  final Symbol field;

  final String key;

  const AddColumn(this.field, [this.key]);
}

class PrimaryKey implements ColumnBase {
  final String key;

  const PrimaryKey([this.key]);
}

class Find {
  const Find();
}

class WhereEq {
  final Symbol field;

  const WhereEq(this.field);
}
