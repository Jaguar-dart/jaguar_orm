/*
import 'package:analyzer/dart/element/type.dart';
import 'package:jaguar_orm_gen/src/model/model.dart';
import 'parser.dart';

void _parseBelongsToAssociation(
    Field f, Map<DartType, BelongsToAssociation> beanedAssociations) {
  final BelongsToForeign foreign = f.foreign;
  final DartType bean = foreign.bean;
  BelongsToAssociation current = beanedAssociations[bean];

  final WriterModel info =
      ParsedBean(bean.element, doRelations: false, doAssociation: false)
          .detect();

  final Preload other = info.findHasXByAssociation(clazz.type);

  if (other == null) return;

  if (current == null) {
    bool byHasMany = foreign.byHasMany;
    if (byHasMany != null) {
      if (byHasMany != other.hasMany) {
        throw Exception('Mismatching association type!');
      }
    } else {
      byHasMany = other.hasMany;
    }
    current = BelongsToAssociation(bean, [], [], other, byHasMany);
    beanedAssociations[bean] = current;
  } else if (current is BelongsToAssociation) {
    if (current.byHasMany != other.hasMany) {
      throw Exception('Mismatching association type!');
    }
    if (current.belongsToMany != other is PreloadManyToMany) {
      throw Exception('Mismatching association type!');
    }
  } else {
    throw Exception('Table and bean associations mixed!');
  }
  beanedAssociations[bean].fields.add(f);
}
*/
