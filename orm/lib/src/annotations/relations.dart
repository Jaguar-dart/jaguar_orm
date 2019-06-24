abstract class Relation {
  /// Links reference by name
  String get linkByName;
}

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
