part of jaguar_orm.annotation;

abstract class Relation {}

class HasOne implements Relation {
  final Type bean;
  final String foreignKeyColumn;

  const HasOne(this.bean, {this.foreignKeyColumn = 'id'});
}

class HasMany implements Relation {
  final Type bean;
  final String foreignKeyColumn;

  const HasMany(this.bean, {this.foreignKeyColumn = 'id'});
}

class ManyToMany implements Relation {
  final Type pivotBean;

  final Type targetBean;

  const ManyToMany(this.pivotBean, this.targetBean);
}
