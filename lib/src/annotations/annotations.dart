library jaguar_orm.annotation;

class Find {
  const Find();
}

class WhereEq {
  final Symbol field;

  const WhereEq(this.field);
}

class PrimaryKey {
  const PrimaryKey();
}
