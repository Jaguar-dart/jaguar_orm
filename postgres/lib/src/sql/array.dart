import 'package:jaguar_query/jaguar_query.dart';

final postgresDialect = 'postgres';

class Array implements DataType {
  final DataType itemType;

  const Array(this.itemType);
}

class HStore implements DataType {
  const HStore();
}

// TODO JSON

Func array_length(/* TODO */ array, [int dim]) {
  final args = [array];
  if (dim != null) args.add(dim);
  return Func('array_length', args: args);
}
