import 'package:jaguar_orm/jaguar_orm.dart';

abstract class Relation {
  /// Links to [References] or [BelongsTo] by name.
  ///
  /// This is usually not needed, if there is only one foreign relation
  /// between two table.
  ///
  /// If there are multiple foreign relations between two tables, disambiguate
  /// them by matching [Relation.linkBy] and [References.link] or
  /// [BelongsTo.link].
  ///
  /// TODO example
  String get linkBy;
}

/// TODO example
class HasOne implements Relation {
  final Type bean;

  final String linkBy;

  const HasOne(this.bean, {this.linkBy});
}

class HasMany implements Relation {
  final Type bean;

  final String linkBy;

  const HasMany(this.bean, {this.linkBy});
}

class ManyToMany implements Relation {
  final Type pivotBean;

  final Type targetBean;

  final String linkBy;

  const ManyToMany(this.pivotBean, this.targetBean, {this.linkBy});
}
