import 'datatype.dart';

abstract class Property<T> {
  String get name;

  DataType<T> get type;

  bool get nonNull;
}
