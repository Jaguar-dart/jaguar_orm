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
  PivotBean _pivotBean;

  CategoryBean _categoryBean;

  TodoListBean(Adapter adapter) : super(adapter);

  PivotBean get pivotBean {
    _pivotBean ??= new PivotBean(adapter);
    return _pivotBean;
  }

  CategoryBean get categoryBean {
    _categoryBean ??= new CategoryBean(adapter);
    return _categoryBean;
  }

  String get tableName => 'mtm_simple_todolist';
}

@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  final PivotBean pivotBean;

  final TodoListBean todoListBean;

  CategoryBean(Adapter adapter)
      : pivotBean = new PivotBean(adapter),
        todoListBean = new TodoListBean(adapter),
        super(adapter);

  String get tableName => 'mtm_simple_category';
}

@GenBean()
class PivotBean extends Bean<Pivot> with _PivotBean {
  CategoryBean _categoryBean;

  TodoListBean _todoListBean;

  PivotBean(Adapter adapter) : super(adapter);

  CategoryBean get categoryBean {
    _categoryBean ??= new CategoryBean(adapter);
    return _categoryBean;
  }

  TodoListBean get todoListBean {
    _todoListBean ??= new TodoListBean(adapter);
    return _todoListBean;
  }

  String get tableName => 'mtm_simple_pivot';
}
