library jaguar_orm.annotation;

export 'package:jaguar_query/jaguar_query.dart' show OrderBy;

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

class Update {
  const Update();
}

class Delete {
  const Delete();
}

abstract class Where {}

class WhereEq implements Where {
  const WhereEq();
}

class WhereNe implements Where {
  const WhereNe();
}

class WhereLt implements Where {
  const WhereLt();
}

class WhereGt implements Where {
  const WhereGt();
}

class WhereGtEq implements Where {
  const WhereGtEq();
}

class WhereLtEq implements Where {
  const WhereLtEq();
}

class WhereLike implements Where {
  const WhereLike();
}

class SetField {
  const SetField();
}
