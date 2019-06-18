library example.many_to_many;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../model/associations/many_to_many/simple.dart';

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
