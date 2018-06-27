// Copyright (c) 2017, teja. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.many_to_many;

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'many_to_many.jorm.dart';

class Category {
  @PrimaryKey()
  String id;

  String name;

  @ManyToMany(PivotBean, TodoListBean)
  List<TodoList> todolists;

  static const String tableName = 'category';

  String toString() => "Category($id, $name, $todolists)";
}

class TodoList {
  @PrimaryKey()
  String id;

  int id1;

  String description;

  @ManyToMany(PivotBean, CategoryBean)
  List<Category> categories;

  static String tableName = 'todolist';

  String toString() => "Post($id, $id1, $description, $categories)";
}

class Pivot {
  @BelongsToMany(TodoListBean)
  String todolistId;

  @BelongsToMany(TodoListBean, refCol: 'id1')
  int todolistId1;

  @BelongsToMany(CategoryBean)
  String categoryId;

  static String tableName = 'pivot';
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

  Future createTable() {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addInt('id1', primary: true)
        .addStr('description', length: 50);
    return execCreateTable(st);
  }
}

@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  final PivotBean pivotBean;

  final TodoListBean todoListBean;

  CategoryBean(Adapter adapter)
      : pivotBean = new PivotBean(adapter),
        todoListBean = new TodoListBean(adapter),
        super(adapter);

  Future createTable() {
    final st = Sql.create(tableName)
        .addStr('id', primary: true, length: 50)
        .addStr('name', length: 150);
    return execCreateTable(st);
  }
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

  Future createTable() {
    final st = Sql.create(tableName)
        .addStr('todolist_id',
            length: 50, foreignTable: TodoList.tableName, foreignCol: 'id')
        .addInt('todolist_id1',
            foreignTable: TodoList.tableName, foreignCol: 'id1')
        .addStr('category_id',
            length: 50, foreignTable: Category.tableName, foreignCol: 'id');
    return execCreateTable(st);
  }
}
