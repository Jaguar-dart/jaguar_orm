library example.many_to_many;

import 'dart:io';
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'many_to_many.jorm.dart';

class Category {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 50)
  String name;

  @ManyToMany(PivotBean, TodoListBean)
  List<TodoList> todolists;

  String toString() => "Category($id, $name, $todolists)";
}

class TodoList {
  @PrimaryKey(length: 50)
  String id;

  @Column(length: 50)
  String description;

  @ManyToMany(PivotBean, CategoryBean)
  List<Category> categories;

  String toString() => "Post($id, $description, $categories)";
}

class Pivot {
  @BelongsTo.many(TodoListBean, length: 50)
  String todolistId;

  @BelongsTo.many(CategoryBean, length: 50)
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

/// The adapter
final PgAdapter _adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await _adapter.connect();

  // Create beans
  final todolistBean = TodoListBean(_adapter);
  final categoryBean = CategoryBean(_adapter);
  final pivotBean = PivotBean(_adapter);

  // Drop old tables
  await pivotBean.drop();
  await categoryBean.drop();
  await todolistBean.drop();

  // Create new tables
  await todolistBean.createTable();
  await categoryBean.createTable();
  await pivotBean.createTable();

  // Cascaded Many-To-Many insert
  {
    final todolist = TodoList()
      ..id = '1'
      ..description = 'List 1'
      ..categories = <Category>[
        Category()
          ..id = '10'
          ..name = 'Cat 10',
        Category()
          ..id = '11'
          ..name = 'Cat 11'
      ];
    await todolistBean.insert(todolist, cascade: true);
  }

  // Fetch Many-To-Many preloaded
  {
    final todolist = await todolistBean.find('1', preload: true);
    print(todolist);
  }

  // Manual Many-To-Many insert
  {
    TodoList todolist = TodoList()
      ..id = '2'
      ..description = 'List 2';
    await todolistBean.insert(todolist, cascade: true);

    todolist = await todolistBean.find('2');

    final category1 = Category()
      ..id = '20'
      ..name = 'Cat 20';
    await categoryBean.insert(category1);
    await pivotBean.attach(todolist, category1);

    final category2 = Category()
      ..id = '21'
      ..name = 'Cat 21';
    await categoryBean.insert(category2);
    await pivotBean.attach(todolist, category2);
  }

  // Manual Many-To-Many preload
  {
    final todolist = await todolistBean.find('2');
    print(todolist);
    todolist.categories = await pivotBean.fetchByTodoList(todolist);
    print(todolist);
  }

  // TODO preload many

  // Cascaded Many-To-Many update
  {
    TodoList todolist = await todolistBean.find('1', preload: true);
    todolist.description += '!';
    todolist.categories[0].name += '!';
    todolist.categories[1].name += '!';
    await todolistBean.update(todolist, cascade: true);
  }

  // Debug print out
  {
    final user = await todolistBean.find('1', preload: true);
    print(user);
  }

  // Cascaded removal of Many-To-Many relation
  await todolistBean.remove('1', cascade: true);

  // Debug print out
  {
    final user = await todolistBean.getAll();
    print(user);
    final categories = await categoryBean.getAll();
    print(categories);
  }

  exit(0);
}
