export 'property.dart';

abstract class DataType<T> {}

Map<Type, DataType> sqlTypeMap = const {
  int: Int(),
  double: Double(),
  bool: Bool(),
  DateTime: Timestamp(),
  String: Str(),
  Duration: null, // TODO interval
};

/// Integer datatype.
class Int implements DataType<int> {
  final bool auto;

  const Int({this.auto});
}

const auto = Int(auto: true);

/// Integer datatype.
class Double implements DataType<double> {
  const Double();
}

/// Integer datatype.
class Bool implements DataType<bool> {
  const Bool();
}

/// Integer datatype.
class Timestamp implements DataType<DateTime> {
  const Timestamp();
}

/// Integer datatype.
class Str implements DataType<String> {
  final int length;

  const Str({this.length});
}

// TODO needed?
class UserDefinedType implements DataType<dynamic> {
  final String name;

  const UserDefinedType(this.name);
}
