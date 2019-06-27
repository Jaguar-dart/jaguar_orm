import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'simple.jorm.dart';

class Category {
  @primaryKey
  @Str(length: 50)
  String id;

  @Str(length: 50)
  String name;

  @ManyToMany(PivotBean, TodoListBean)
  List<TodoList> todolists;

  String toString() => "Category($id, $name, $todolists)";
}

class TodoList {
  @primaryKey
  @Str(length: 50)
  String id;

  @Str(length: 50)
  String description;

  @ManyToMany(PivotBean, CategoryBean)
  List<Category> categories;

  String toString() => "Post($id, $description, $categories)";
}

class Pivot {
  @BelongsTo.many(TodoListBean, references: 'id')
  @Str(length: 50)
  String todolistId;

  @BelongsTo.many(CategoryBean, references: 'id')
  @Str(length: 50)
  String categoryId;
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
