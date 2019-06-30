// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// Support for doing something awesome.
///
/// More dartdocs go here.
library query;

import 'package:quiver_hashcode/hashcode.dart';

export 'src/adapter/adapter.dart';
export 'src/bean/bean.dart';
export 'src/core/core.dart';
export 'src/operators/operators.dart';

class Tuple {
  final List<dynamic> items;

  @override
  final int hashCode;

  Tuple(this.items) : hashCode = hashObjects(items);

  dynamic operator [](int index) => items[index];
}

/*
  Future<List<Category>> fetchByTodoList(TodoList model,
      {Connection withConn}) async {
    final pivots = await findByTodoList(model.id);
// Return if model has no pivots. If this is not done, all records will be removed!
    if (pivots.isEmpty) return [];

    final duplicates = <Tuple, int>{};

    final exp = Or();
    for (final t in pivots) {
      final tup = Tuple([t.categoryId, t.categoryId2]);
      if (duplicates[tup] == null) {
        exp.or(categoryBean.id.eq(t.categoryId) &
            categoryBean.id2.eq(t.categoryId2));

        duplicates[tup] = 1;
      } else {
        duplicates[tup] += 1;
      }
    }

    final returnList = await categoryBean.findWhere(exp, withConn: withConn);
    if (duplicates.length != pivots.length) {
      for (Tuple tup in duplicates.keys) {
        int n = duplicates[tup] - 1;
        for (int i = 0; i < n; i++) {
          returnList
              .add(await categoryBean.find(tup[0], tup[1], withConn: withConn));
        }
      }
    }

    return returnList;
  }
 */