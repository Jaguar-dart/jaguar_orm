import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'composite.jorm.dart';

class Category {
  @primaryKey
  String id;

  @primaryKey
  String id2;

  String name;

  @ManyToMany(PivotBean, TodoListBean)
  List<TodoList> todolists;

  String toString() => "Category($id, $name, $todolists)";
}

class TodoList {
  @primaryKey
  String id;

  String description;

  @ManyToMany(PivotBean, CategoryBean)
  List<Category> categories;

  String toString() => "Post($id, $description, $categories)";
}

class Pivot {
  @BelongsTo.many(TodoListBean, references: 'id')
  String todolistId;

  @BelongsTo.many(CategoryBean, references: 'id')
  String categoryId;

  @BelongsTo.many(CategoryBean, references: 'id2')
  String categoryId2;
}

@GenBean()
class TodoListBean extends Bean<TodoList> with _TodoListBean {
  final BeanRepo beanRepo;

  TodoListBean(Adapter adapter, this.beanRepo) : super(adapter);

  String get tableName => 'mtm_simple_todolist';
}

@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  final BeanRepo beanRepo;

  CategoryBean(Adapter adapter, this.beanRepo) : super(adapter);

  String get tableName => 'mtm_simple_category';
}

@GenBean()
class PivotBean extends Bean<Pivot> with _PivotBean {
  final BeanRepo beanRepo;

  PivotBean(Adapter adapter, this.beanRepo) : super(adapter);

  String get tableName => 'mtm_simple_pivot';
}
