import 'package:jaguar_query/jaguar_query.dart';

final postgresDialect = 'postgres';

class Array implements DataType {
  final DataType itemType;
  bool get auto => false;

  const Array(this.itemType);
}

class HStore implements DataType {
  const HStore();
  bool get auto => false;
}

// TODO JSON

Func array_length(/* TODO */ array, [int dim]) {
  final args = [array];
  if (dim != null) args.add(dim);
  return Func('array_length', args: args);
}
