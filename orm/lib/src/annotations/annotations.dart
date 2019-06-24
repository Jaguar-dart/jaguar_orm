library jaguar_orm.annotation;

export 'package:jaguar_query/jaguar_query.dart';

export 'column.dart';
export 'relations.dart';

/// Annotation on model class to request generation of ORM
/// bean for a model
class GenBean {
  const GenBean();
}
