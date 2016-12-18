library jaguar_orm.field;

import 'package:jaguar_query/jaguar_query.dart';

class Field<ValType extends V> {
  final String name;

  const Field(this.name);

  C<ValType> eq(ValType value) => C.eq<ValType>(name, value);

  C<ValType> ne(ValType value) => C.ne<ValType>(name, value);

  C<ValType> gt(ValType value) => C.gt<ValType>(name, value);

  C<ValType> gtEq(ValType value) => C.gtEq<ValType>(name, value);

  C<ValType> ltEq(ValType value) => C.ltEq<ValType>(name, value);

  C<ValType> lt(ValType value) => C.lt<ValType>(name, value);

  C<ValType> like(VString value) => C.like(name, value);

  InBetweenExpression inBetween(ValType low, ValType high) =>
      C.inBetween<ValType>(name, low, high);

  SetColumn set(ValType value) =>
      new SetColumn<ValType>().column(name).set(value);
}

class IntField {
  final String name;

  const IntField(this.name);

  C<VInt> eq(int value) => C.eq<VInt>(name, V.Int(value));

  C<VInt> ne(int value) => C.ne<VInt>(name, V.Int(value));

  C<VInt> gt(int value) => C.gt<VInt>(name, V.Int(value));

  C<VInt> gtEq(int value) => C.gtEq<VInt>(name, V.Int(value));

  C<VInt> ltEq(int value) => C.ltEq<VInt>(name, V.Int(value));

  C<VInt> lt(int value) => C.lt<VInt>(name, V.Int(value));

  InBetweenExpression<VInt> inBetween(int low, int high) =>
      C.inBetween<VInt>(name, V.Int(low), V.Int(high));

  SetColumn<VInt> set(int value) =>
      new SetColumn<VInt>().column(name).set(V.Int(value));
}

class DoubleField {
  final String name;

  const DoubleField(this.name);

  C<VDouble> eq(double value) => C.eq<VDouble>(name, V.Double(value));

  C<VDouble> ne(double value) => C.ne<VDouble>(name, V.Double(value));

  C<VDouble> gt(double value) => C.gt<VDouble>(name, V.Double(value));

  C<VDouble> gtEq(double value) => C.gtEq<VDouble>(name, V.Double(value));

  C<VDouble> ltEq(double value) => C.ltEq<VDouble>(name, V.Double(value));

  C<VDouble> lt(double value) => C.lt<VDouble>(name, V.Double(value));

  InBetweenExpression<VDouble> inBetween(double low, double high) =>
      C.inBetween<VDouble>(name, V.Double(low), V.Double(high));

  SetColumn<VDouble> set(double value) =>
      new SetColumn<VDouble>().column(name).set(V.Double(value));
}

class StrField {
  final String name;

  const StrField(this.name);

  C<VString> eq(String value) => C.eq<VString>(name, V.Str(value));

  C<VString> ne(String value) => C.ne<VString>(name, V.Str(value));

  C<VString> gt(String value) => C.gt<VString>(name, V.Str(value));

  C<VString> gtEq(String value) => C.gtEq<VString>(name, V.Str(value));

  C<VString> ltEq(String value) => C.ltEq<VString>(name, V.Str(value));

  C<VString> lt(String value) => C.lt<VString>(name, V.Str(value));

  C<VString> like(String value) => C.like(name, V.Str(value));

  InBetweenExpression<VString> inBetween(String low, String high) =>
      C.inBetween<VString>(name, V.Str(low), V.Str(high));

  SetColumn<VString> set(String value) =>
      new SetColumn<VString>().column(name).set(V.Str(value));
}
