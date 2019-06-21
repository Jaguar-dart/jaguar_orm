export 'property.dart';

abstract class DataType<T> {}

/// Integer datatype.
class Int implements DataType<int> {
  final bool autoIncrement;

  const Int({this.autoIncrement});
}

/// Integer datatype.
class Double implements DataType<double> {}

/// Integer datatype.
class Bool implements DataType<bool> {
  Bool();
}

/// Integer datatype.
class Timestamp implements DataType<DateTime> {
  Timestamp();
}

/// Integer datatype.
class Str implements DataType<String> {
  final int length;

  Str({this.length});
}

class UserDefinedType implements DataType<dynamic> {
  final String name;

  UserDefinedType(this.name);
}
