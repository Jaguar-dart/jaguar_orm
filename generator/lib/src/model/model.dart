library jaguar_orm.generator.model;

import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:meta/meta.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_orm_gen/src/common/common.dart';
import 'package:jaguar_orm/src/annotations/column.dart';
import 'preloads.dart';

export 'preloads.dart';

part 'association.dart';
part 'foreign.dart';

class ParsedField {
  final String type;

  final String field;

  final bool isFinal;

  final Column column;

  final String dataType;

  final ForeignSpec foreign;

  final bool isAuto;

  final List<String> constraints;

  ParsedField(this.type, this.field,
      {@required Column column,
      @required this.dataType,
      @required this.foreign,
      @required this.isFinal,
      @required this.isAuto,
      this.constraints: const []})
      : column = column ?? Column();

  String get colName => column?.name ?? field;

  // TODO
  String get vType {
    try {
      return getValType(type);
    } catch (e) {
      throw FieldSpecException(field, e.toString());
    }
  }
}

class ParsedBean extends UnAssociatedBean {
  /// A map of bean to [BelongsToAssociationByRelation]
  final Map<DartType, BelongsToAssociationByRelation> associationsWithRelations;

  /// A map of association to [BelongToAssociationWithoutRelation]
  final Map<DartType, BelongToAssociationWithoutRelation>
      associationsWithoutRelations;

  ParsedBean(
    String name, {
    @required String modelType,
    @required Map<String, ParsedField> fields,
    @required List<ParsedField> primary,
    @required Map<String, ReferencesSpec> references,
    @required List<Preload> preloads,
    @required Map<String, RelationSpec> relations,
    @required this.associationsWithRelations,
    @required this.associationsWithoutRelations,
  }) : super(name, modelType,
            fields: fields,
            primary: primary,
            references: references,
            relations: relations,
            preloads: preloads);

  factory ParsedBean.fromPreAssociated(
    UnAssociatedBean bean, {
    @required Map<DartType, BelongsToAssociationByRelation> belongTos,
    @required
        Map<DartType, BelongToAssociationWithoutRelation>
            beanedForeignAssociations,
  }) {
    return ParsedBean(bean.name,
        modelType: bean.modelType,
        fields: bean.fields,
        primary: bean.primary,
        references: bean.references,
        preloads: bean.preloads,
        relations: bean.relations,
        associationsWithRelations: belongTos,
        associationsWithoutRelations: beanedForeignAssociations);
  }

  BelongsToAssociationByRelation getMatchingManyToMany(
      BelongsToAssociationByRelation val) {
    for (BelongsToAssociationByRelation f in associationsWithRelations.values) {
      if (!f.belongsToMany) continue;

      if (f == val) continue;

      return f;
    }
    return null;
  }
}

String getValType(String type) {
  if (type == 'String') {
    return 'StrField';
  } else if (type == 'bool') {
    return 'BoolField';
  } else if (type == 'int') {
    return 'IntField';
  } else if (type == 'num' || type == 'double') {
    return 'DoubleField';
  } else if (type == 'DateTime') {
    return 'DateTimeField';
  }

  throw Exception('Field type not recognised: $type!');
}

class UnAssociatedBean {
  final String name;

  final String modelType;

  final Map<String, ParsedField> fields;

  final List<ParsedField> primary;

  final List<Preload> preloads;

  final Map<String, ReferencesSpec> references;

  /// Map of field name to relation.
  final Map<String, RelationSpec> relations;

  UnAssociatedBean(this.name, this.modelType,
      {@required this.fields,
      @required this.primary,
      @required this.relations,
      @required this.references,
      @required this.preloads});

  Preload findHasXByAssociation(DartType association) {
    return preloads.firstWhere((p) => p.bean == association,
        orElse: () => null);
  }

  ParsedField fieldByColName(String colName) => fields.values
      .firstWhere((ParsedField f) => f.colName == colName, orElse: () => null);
}
