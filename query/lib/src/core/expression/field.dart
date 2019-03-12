part of query;

/// Field is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final age = IntField(age);
///     var value = await Find()
///             .from('user')
///             .where(age > 30)  // Simplifies query expressions
///             .exec(adapter).one();
class Field<ValType> {
  /// Name of the field
  final String name;

  final String tableName;

  const Field(this.name) : tableName = null;

  const Field.inTable(this.tableName, this.name);

  /// Returns an "is equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> author = Field<int>('age');
  ///     find.where(age.eq(20));
  Cond<ValType> eq(ValType value) => Cond.eq<ValType>(this, value);

  /// Returns an "IS" condition, i.e. 'where var IS null'
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> phone = Field<String>('phone');
  ///     find.where(phone.iss(null));
  Cond<ValType> iss(ValType value) => Cond.iss<ValType>(this, value);

  /// Returns an "IS NOT" condition, i.e. 'where var IS NOT null'
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> phone = Field<String>('phone');
  ///     find.where(phone.isNot(null));
  Cond<ValType> isNot(ValType value) => Cond.isNot<ValType>(this, value);

  /// Returns a "not equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ne(20));
  Cond<ValType> ne(ValType value) => Cond.ne<ValType>(this, value);

  /// Returns a "greater than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gt(20));
  Cond<ValType> gt(ValType value) => Cond.gt<ValType>(this, value);

  /// Returns a "greater than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtEq(20));
  Cond<ValType> gtEq(ValType value) => Cond.gtEq<ValType>(this, value);

  /// Returns a "less than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltEq(20));
  Cond<ValType> ltEq(ValType value) => Cond.ltEq<ValType>(this, value);

  /// Returns a "less than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.lt(20));
  Cond<ValType> lt(ValType value) => Cond.lt<ValType>(this, value);

  /// Returns an "in between" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.between(20, 30));
  Between<ValType> between(ValType low, ValType high) =>
      Cond.between<ValType>(this, low, high);

  Field<ValType> aliasAs(String tableAlias) =>
      Field<ValType>.inTable(tableAlias, name);

  /// Returns an "is equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.eqCol(col('age', 'employee')));
  CondCol<ValType> eqField(Field<ValType> rhs) =>
      CondCol.eq<ValType>(this, rhs);

  /// Returns a "not equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.neCol(col('age', 'employee')));
  CondCol<ValType> neField(Field<ValType> rhs) =>
      CondCol.ne<ValType>(this, rhs);

  /// Returns a "greater than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtCol(col('age', 'employee')));
  CondCol<ValType> gtField(Field<ValType> rhs) =>
      CondCol.gt<ValType>(this, rhs);

  /// Returns a "greater than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtEqCol(col('age', 'employee')));
  CondCol<ValType> gtEqField(Field<ValType> rhs) =>
      CondCol.gtEq<ValType>(this, rhs);

  /// Returns a "less than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltEqCol(col('age', 'employee')));
  CondCol<ValType> ltEqField(Field<ValType> rhs) =>
      CondCol.ltEq<ValType>(this, rhs);

  /// Returns a "less than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltCol(col('age', 'employee')));
  CondCol<ValType> ltField(Field<ValType> rhs) =>
      CondCol.lt<ValType>(this, rhs);

  /// Returns an "in between" condition
  InBetweenCol<ValType> inBetweenFields(
          Field<ValType> low, Field<ValType> high) =>
      CondCol.between<ValType>(this, low, high);

  /// Returns an "is equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.eqCol(col('age', 'employee')));
  CondCol<ValType> eqF(String name, {String table}) =>
      CondCol.eq<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "not equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.neCol(col('age', 'employee')));
  CondCol<ValType> neF(String name, {String table}) =>
      CondCol.ne<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "greater than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtCol(col('age', 'employee')));
  CondCol<ValType> gtF(String name, {String table}) =>
      CondCol.gt<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "greater than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.gtEqCol(col('age', 'employee')));
  CondCol<ValType> gtEqF(String name, {String table}) =>
      CondCol.gtEq<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "less than equal to" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltEqCol(col('age', 'employee')));
  CondCol<ValType> ltEqF(String name, {String table}) =>
      CondCol.ltEq<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "less than" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<int> age = Field<int>('age');
  ///     find.where(age.ltCol(col('age', 'employee')));
  CondCol<ValType> ltF(String name, {String table}) =>
      CondCol.lt<ValType>(this, Field<ValType>.inTable(table, name));

  /// Returns a "set column" clause
  ///
  ///     UpdateStatement update = UpdateStatement();
  ///     Field<int> age = Field<int>('age');
  ///     update.set(age.set(20));
  SetColumn<ValType> set(ValType value) => SetColumn<ValType>(name, value);

  Cond<ValType> operator <(ValType other) {
    return lt(other);
  }

  Cond<ValType> operator >(ValType other) {
    return gt(other);
  }

  Cond<ValType> operator <=(ValType other) {
    return ltEq(other);
  }

  Cond<ValType> operator >=(ValType other) {
    return gtEq(other);
  }
}

/// IntField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final age = IntField(age);
///     var value = await Find()
///             .from('user')
///             .where(age > 30)  // Simplifies query expressions
///             .exec(adapter).one();
class IntField extends Field<int> {
  IntField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool autoIncrement = false,
      bool primary = false,
      bool isNullable = false,
      String foreignTable,
      String foreignCol,
      String uniqueGroup}) {
    statement.addInt(name,
        isNullable: isNullable,
        autoIncrement: autoIncrement,
        primary: primary,
        foreignTable: foreignTable,
        foreignCol: foreignCol,
        uniqueGroup: uniqueGroup);
  }
}

/// DoubleField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final score = DoubleField('age');
///     var value = await Find()
///             .from('user')
///             .where(score > 90.0)  // Simplifies query expressions
///             .exec(adapter).one();
class DoubleField extends Field<double> {
  DoubleField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement,
      {bool isNullable = false,
      bool primary = false,
      String foreignTable,
      String foreignCol,
      String uniqueGroup}) {
    statement.addDouble(name,
        isNullable: isNullable,
        primary: primary,
        foreignTable: foreignTable,
        foreignCol: foreignCol,
        uniqueGroup: uniqueGroup);
  }
}

/// StrField is a convenience DSL used to construct queries in a concise and
/// understandable way.
///
/// Example:
///
///     final name = DoubleField('name');
///     var value = await Find()
///             .from('user')
///             .where(name.eq('teja'))  // Simplifies query expressions
///             .exec(adapter).one();
class StrField extends Field<String> {
  StrField(String name) : super(name);

  /// This is actually 'like' operator
  Cond<String> operator %(String other) {
    return like(other);
  }

  /// Returns a "like" condition
  ///
  ///     FindStatement find = FindStatement();
  ///     Field<String> author = Field<String>('author');
  ///     find.where(author.like('%Mark%'));
  Cond<String> like(String value) => Cond.like(this, value);

  /// Adds the field to create statement
  void create(Create statement,
      {bool isNullable = false,
      int length = 20,
      bool primary = false,
      String foreignTable,
      String foreignCol,
      String uniqueGroup}) {
    statement.addStr(name,
        isNullable: isNullable,
        length: length,
        primary: primary,
        foreignTable: foreignTable,
        foreignCol: foreignCol,
        uniqueGroup: uniqueGroup);
  }
}

/// DateTimeField is a convenience DSL used to construct queries in a concise and
/// understandable way.
class DateTimeField extends Field<DateTime> {
  DateTimeField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement, {bool isNullable, String uniqueGroup}) {
    statement.addDateTime(name,
        isNullable: isNullable, uniqueGroup: uniqueGroup);
  }
}

/// BoolField is a convenience DSL used to construct queries in a concise and
/// understandable way.
class BoolField extends Field<bool> {
  BoolField(String name) : super(name);

  /// Adds the field to create statement
  void create(Create statement, {bool isNullable = false, String uniqueGroup}) {
    statement.addBool(name, isNullable: isNullable, uniqueGroup: uniqueGroup);
  }
}
