library jaguar_orm.generator.parser;

import 'package:jaguar_orm_gen/src/parser/unassociated/unassociated_parser.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

import 'package:jaguar_orm_gen/src/model/model.dart';
import 'package:jaguar_orm/jaguar_orm.dart' hide Field;

/// Parses the `@GenBean()` into `WriterModel` so that `Model` can be used
/// to generate the code by `Writer`.
class BeanParser {
  UnAssociatedBean _unassociated;

  /// The [ClassElement] element of the `GenBean` spec.
  final ClassElement clazz;

  final bool doRelations;

  DartType get curBean => clazz.type;

  /// Parsed fields are stored here while being parsed.
  ///
  /// This is part of the state of the parser.
  Map<String, ParsedField> get fields => _unassociated.fields;

  Map<String, RelationSpec> get relations => _unassociated.relations;

  List<Preload> get preloads => _unassociated.preloads;

  final associationsWithRelations = <DartType, AssociationByRelation>{};

  final associationsWithoutRelations = <DartType, AssociationWithoutRelation>{};

  BeanParser(this.clazz, {this.doRelations: true});

  ParsedBean parse() {
    _unassociated = UnassociatedBeanParser(clazz).parse();

    // Collect [BelongsToAssociation] from [BelongsToForeign]
    associate();

    for (AssociationByRelation m in associationsWithRelations.values) {
      final UnAssociatedBean info =
          UnassociatedBeanParser(m.bean.element, associatePreloads: false)
              .parse();

      for (ParsedField f in m.fields) {
        // TODO linkByName

        ParsedField ff = info.fieldByColName(f.foreign.references);

        if (ff == null) {
          throw Exception(
              'Foreign key ${f.foreign.references} in foreign model not found!');
        }

        m.foreignFields.add(ff);
      }
    }

    for (AssociationWithoutRelation m in associationsWithoutRelations.values) {
      final UnAssociatedBean info =
          UnassociatedBeanParser(m.bean.element, associatePreloads: false)
              .parse();

      for (ParsedField f in m.fields) {
        ParsedField ff = info.fieldByColName(f.foreign.references);

        if (ff == null)
          throw Exception('Foreign key in foreign model not found!');

        m.foreignFields.add(ff);
      }
    }

    final ret = ParsedBean.fromPreAssociated(_unassociated,
        belongTos: associationsWithRelations,
        beanedForeignAssociations: associationsWithoutRelations);

    if (doRelations) {
      for (Preload p in preloads) {
        if (p.bean == clazz.type) {
          p.foreignFields.addAll(associationsWithRelations[p.bean].fields);
        }
        for (ParsedField f in p.foreignFields) {
          ParsedField ff = ret.fieldByColName(f.foreign.references);
          if (ff == null)
            throw Exception('Foreign key in foreign model not found!');
          p.fields.add(ff);
        }
      }
    }

    return ret;
  }

  /// Associates [BelongsTo] columns with [Relation] properties.
  void associate() {
    _associateBelongsTosWithRelation();
    _associateBelongsTosWithoutRelation();
    // TODO associate reference
  }

  /// Make [BelongsToAssociation] from [BelongsToSpec]
  void _associateBelongsTosWithRelation() {
    for (ParsedField f in fields.values) {
      if (f.foreign is! BelongsToSpec) continue;

      final BelongsToSpec foreign = f.foreign;
      final DartType bean = foreign.bean;
      AssociationByRelation current = associationsWithRelations[bean];

      final UnAssociatedBean info =
          UnassociatedBeanParser(bean.element, associatePreloads: false)
              .parse();

      final Preload otherPreload = info.findHasXByAssociation(clazz.type);

      // Skip [BelongTo]s without complementing [Relation]
      if (otherPreload == null) continue;

      if (current == null) {
        bool byHasMany = otherPreload.hasMany;
        if (byHasMany != null) {
          if (byHasMany != otherPreload.hasMany) {
            throw Exception('Mismatching association type!');
          }
        } else {
          byHasMany = otherPreload.hasMany;
        }
        AssociationManyToManyInfo other;

        if (otherPreload is PreloadManyToMany) {
          other = AssociationManyToManyInfo(
              targetBeanInstanceName: otherPreload.targetBeanInstanceName,
              targetModelName: otherPreload.targetModelName);
        }
        current = AssociationByRelation(bean, [], [], other, byHasMany);
        associationsWithRelations[bean] = current;
      } else if (current is AssociationByRelation) {
        if (current.toMany != otherPreload.hasMany) {
          throw Exception('Mismatching association type!');
        }
        if (current.isManyToMany != otherPreload is PreloadManyToMany) {
          throw Exception('Mismatching association type!');
        }
      } else {
        throw Exception('Table and bean associations mixed!');
      }
      associationsWithRelations[bean].fields.add(f);
    }
  }

  void _associateBelongsTosWithoutRelation() {
    // Collect [BeanedForeignAssociation] from [BelongsToForeign]
    for (ParsedField f in fields.values) {
      if (f.foreign is! BelongsToSpec) continue;

      final BelongsToSpec foreign = f.foreign;
      final DartType bean = foreign.bean;

      {
        final UnAssociatedBean info =
            UnassociatedBeanParser(bean.element, associatePreloads: false)
                .parse();
        final Preload other = info.findHasXByAssociation(clazz.type);

        // Skip [BelongTo]s with complementing [Relation]
        if (other != null) continue;
      }

      AssociationWithoutRelation current = associationsWithoutRelations[bean];

      if (current == null) {
        current =
            AssociationWithoutRelation(bean, [], [], foreign.belongsToMany);
        associationsWithoutRelations[bean] = current;
      } else if (current is AssociationWithoutRelation) {
        if (current.toMany != foreign.belongsToMany) {
          throw Exception('Mismatching association type!');
        }
      } else {
        throw Exception('Table and bean associations mixed!');
      }
      associationsWithoutRelations[bean].fields.add(f);
    }
  }
}
