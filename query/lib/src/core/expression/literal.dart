part of 'expression.dart';

abstract class Literal extends Expression {
  dynamic get value;

  const Literal();

  static Literal tryToLiteral(dynamic value) {
    if (value is Literal) return value;

    if (value is int) return IntLiteral(value);
    if (value is num) return DoubleLiteral(value);
    if (value is String) return StrLiteral(value);
    if (value is bool) return BoolLiteral(value);
    if (value is DateTime) return TimestampLiteral(value);
    if (value is Duration) return DurationLiteral(value);
    if (value == null) return nil;

    return null;
  }

  static Literal toLiteral(dynamic value) {
    Literal ret = tryToLiteral(value);

    if (ret == null) {
      throw ArgumentError.value(value, 'value', 'Not a valid literal');
    }

    return ret;
  }
}

class NilLiteral extends Literal {
  final Null value = null;

  const NilLiteral._();
}

const nil = NilLiteral._();

class IntLiteral extends Literal {
  final int value;

  const IntLiteral(this.value);
}

class DoubleLiteral extends Literal {
  final double value;

  const DoubleLiteral(this.value);
}

class StrLiteral extends Literal {
  final String value;

  const StrLiteral(this.value);
}

class TimestampLiteral extends Literal {
  final DateTime value;

  const TimestampLiteral(this.value);
}

class DurationLiteral extends Literal {
  final Duration value;

  const DurationLiteral(this.value);
}

class BoolLiteral extends Literal {
  final bool value;

  const BoolLiteral(this.value);
}
