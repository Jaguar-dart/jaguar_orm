part of query;

/// Clause to create int column in SQL table.
class CreateInt implements CreateColumn<int> {
  final bool isNullable;

  final String name;

  final bool autoIncrement;

  final bool isPrimary;

  final Foreign foreignKey;

  final String uniqueGroup;

  const CreateInt(this.name,
      {this.isNullable = false,
      this.autoIncrement = false,
      this.isPrimary = false,
      this.foreignKey,
      this.uniqueGroup});

  const CreateInt.primary(this.name, {this.foreignKey, this.uniqueGroup})
      : isPrimary = true,
        isNullable = false,
        autoIncrement = false;

  const CreateInt.autoPrimary(this.name, {this.uniqueGroup})
      : isPrimary = true,
        autoIncrement = true,
        foreignKey = null,
        isNullable = false;
}

/// Clause to create double column in SQL table.
class CreateDouble extends CreateColumn<double> {
  final bool isNullable;

  final String name;

  final bool isPrimary;

  final Foreign foreignKey;

  final String uniqueGroup;

  CreateDouble(this.name,
      {this.isNullable = false,
      this.isPrimary = false,
      this.foreignKey,
      this.uniqueGroup});

  CreateDouble.primary(this.name, {this.foreignKey})
      : isPrimary = true,
        isNullable = false,
        uniqueGroup = null;
}

/// Clause to create bool column in SQL table.
class CreateBool extends CreateColumn<bool> {
  final bool isNullable;

  final String name;

  final bool isPrimary;

  final String uniqueGroup;

  final Foreign foreignKey = null;

  CreateBool(this.name,
      {this.isNullable = false, this.isPrimary = false, this.uniqueGroup});
}

/// Clause to create datetime column in SQL table.
class CreateDateTime extends CreateColumn<DateTime> {
  final bool isNullable;

  final String name;

  final bool isPrimary;

  final Foreign foreignKey;

  final String uniqueGroup;

  CreateDateTime(this.name,
      {this.isNullable = false,
      this.isPrimary = false,
      this.foreignKey,
      this.uniqueGroup});
}

/// Clause to create string column in SQL table.
class CreateStr extends CreateColumn<String> {
  final bool isNullable;

  final String name;

  final bool isPrimary;

  final int length;

  final Foreign foreignKey;

  final String uniqueGroup;

  CreateStr(this.name,
      {this.isNullable = false,
      this.isPrimary = false,
      this.length = 20,
      this.foreignKey,
      this.uniqueGroup});

  CreateStr.primary(this.name,
      {this.length = 20, this.foreignKey, this.uniqueGroup})
      : isPrimary = true,
        isNullable = false;
}
