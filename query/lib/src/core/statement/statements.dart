part of query;

class SelColumn {
  final String name;

  final String alias;

  SelColumn(this.name, [this.alias]);
}

class CountSelColumn extends SelColumn {
  final bool isDistinct;

  CountSelColumn(String name, {String alias, this.isDistinct: false})
      : super(name, alias);
}

class SetColumn<ValType> {
  String _column;

  ValType _value;

  SetColumn();

  SetColumn<ValType> column(String column) {
    _column = column;
    return this;
  }

  SetColumn<ValType> set(ValType value) {
    _value = value;
    return this;
  }

  String get getColumn => _column;

  ValType get getValue => _value;
}

abstract class Statement {}
