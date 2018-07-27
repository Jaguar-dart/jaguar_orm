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

/// name:value pair used to set a column named [name] to [value]. Used during
/// inserts and updates.
class SetColumn<ValType> {
  /// Name of the column to set
  final String name;

  /// Value of the column
  final ValType value;

  SetColumn(this.name, this.value);

  /// Returns a new [SetColumn] that sets the current column to new [value].
  SetColumn<ValType> setTo(ValType value) => SetColumn<ValType>(name, value);
}

abstract class Statement {}
