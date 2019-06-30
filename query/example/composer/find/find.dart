// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Find find = Sql.find('post')
      .sel('authorId')
      .where((col('likes') > 10) & (col('dislikes') > 5))
      .groupBy('authorId')
      .orderBy('authorId', desc: true)
      .limit(10);
  print(composeFind(find));
}
