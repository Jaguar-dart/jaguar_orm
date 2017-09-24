part of jaguar_orm.annotation;

abstract class Relation {}

class HasOne implements Relation {
  final Type bean;

  const HasOne(this.bean);
}

class HasMany implements Relation {
  final Type bean;

  const HasMany(this.bean);
}

class ManyToMany implements Relation {
  final Type pivotBean;

  final Type targetBean;

  const ManyToMany(this.pivotBean, this.targetBean);
}
