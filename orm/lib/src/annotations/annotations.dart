library jaguar_orm.annotation;

export 'package:jaguar_query/jaguar_query.dart';

part 'property.dart';
part 'relations.dart';

/// Annotation on model class to request generation of ORM
/// bean for a model
class GenBean {
  /// Specify columns
  final Map<String, ColumnBase> columns;

  /// Specify [HasOne], [HasMany], [ManyToMany] relations on a table/document
  final Map<String, Relation> relations;

  const GenBean(
      {this.columns = const <String, ColumnBase>{},
      this.relations = const <String, Relation>{}});
}
