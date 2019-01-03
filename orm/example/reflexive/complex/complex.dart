// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

library example.has_one;

import 'dart:io';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../model/reflexive/complex/complex.dart';

/// The adapter
final adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

main() async {
  // Connect to database
  await adapter.connect();

  // Create beans
  final cBean = CategoryBean(adapter);
  final piBean = ProductItemsBean(adapter);
  final ppBean = ProductItemsPivotBean(adapter);
  final pBean = ProductBean(adapter);

  // Drop old tables
  await ppBean.drop();
  await piBean.drop();
  await pBean.drop();
  await cBean.drop();

  // Create new tables
  await cBean.createTable();
  await pBean.createTable();
  await piBean.createTable();
  await ppBean.createTable();

  {
    final cat = Category(id: 1);
    await cBean.insert(cat);
  }

  // Cascaded Many-To-Many insert
  {
    final product = Product.make(id: '1', sku: "1", name: "P1", categoryId: 1)
      ..lists = <ProductItems>[
        ProductItems.make(id: '1', name: 'PI1'),
        ProductItems.make(id: '2', name: 'PI2')
      ];
    await pBean.insert(product, cascade: true);
  }

  // Fetch Many-To-Many preloaded
  {
    final products = await pBean.find('1', preload: true);
    print(products);
  }

  // Manual Many-To-Many insert
  {
    var product = Product.make(id: '2', sku: "2", name: "P2");
    await pBean.insert(product, cascade: true);

    product = await pBean.find('2');

    final item1 = ProductItems.make(id: '3', name: 'PI3');
    await piBean.insert(item1);
    await ppBean.attach(item1, product);

    final item2 = ProductItems.make(id: '4', name: 'PI4');
    await piBean.insert(item2);
    await ppBean.attach(item2, product);
  }

  // Manual Many-To-Many preload
  {
    final product = await pBean.find('2');
    print(product);
    product.lists = await ppBean.fetchByProduct(product);
    print(product);
  }

  // preload many
  {
    final products = await pBean.getAll();
    await pBean.preloadAll(products);
    print(products);
  }

  /*


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
  await todolistBean.remove('1', true);

  // Debug print out
  {
    final user = await todolistBean.getAll();
    print(user);
    final categories = await categoryBean.getAll();
    print(categories);
  }
  */

  exit(0);
}
