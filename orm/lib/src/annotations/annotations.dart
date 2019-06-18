library jaguar_orm.annotation;

export 'package:jaguar_query/jaguar_query.dart';

export 'nextgen.dart';
export 'relations.dart';

import 'relations.dart';

/// Annotation on model class to request generation of ORM
/// bean for a model
class GenBean {
  // TODO column spec

  /// Specify [HasOne], [HasMany], [ManyToMany] relations on a table/document
  final Map<String, Relation> relations;

  const GenBean({this.relations = const <String, Relation>{}});
}
