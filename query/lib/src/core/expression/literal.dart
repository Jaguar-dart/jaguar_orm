part of 'expression.dart';

abstract class L<T> extends Expression {
  T get value;

  const L();

  static Expression tryToLiteral(dynamic value) {
    if (value is Expression) return value;

    if (value is int) return IntL(value);
    if (value is num) return DoubleL(value);
    if (value is String) return StrL(value);
    if (value is bool) return BoolL(value);
    if (value is DateTime) return TimestampL(value);
    if (value is Duration) return DurationL(value);
    if(value is List) return Row.make(value);
    if (value == null) return nil;

    return null;
  }

  static Expression toLiteral(dynamic value) {
    Expression ret = tryToLiteral(value);

    if (ret == null) {
      throw ArgumentError.value(value, 'value', 'Not a valid literal');
    }

    return ret;
  }
}

class NilLiteral extends L<Null> {
  final Null value = null;

  const NilLiteral._();
}

const nil = NilLiteral._();

class IntL extends L<int> {
  final int value;

  const IntL(this.value);
}

class DoubleL extends L<double> {
  final double value;

  const DoubleL(this.value);
}

class StrL extends L<String> {
  final String value;

  const StrL(this.value);
}

class TimestampL extends L<DateTime> {
  final DateTime value;

  const TimestampL(this.value);
}

class DurationL extends L<Duration> {
  final Duration value;

  const DurationL(this.value);
}

class BoolL extends L<bool> {
  final bool value;

  const BoolL(this.value);
}
