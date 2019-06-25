import 'package:jaguar_orm/jaguar_orm.dart';

abstract class Relation {
  /// Links to [References] or [BelongsTo] by name.
  ///
  /// This is usually not needed, if there is only one foreign relation
  /// between two table.
  ///
  /// If there are multiple foreign relations between two tables, disambiguate
  /// them by matching [Relation.linkByName] and [References.name] or
  /// [BelongsTo.name].
  ///
  /// TODO example
  String get linkByName;
}

/// TODO example
class HasOne implements Relation {
  final Type bean;

  final String linkByName;

  const HasOne(this.bean, {this.linkByName});
}

class HasMany implements Relation {
  final Type bean;

  final String linkByName;

  const HasMany(this.bean, {this.linkByName});
}

class ManyToMany implements Relation {
  final Type pivotBean;

  final Type targetBean;

  final String linkByName;

  const ManyToMany(this.pivotBean, this.targetBean, {this.linkByName});
}
