// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Find find = Sql.find('posts')
      .sel('message')
      .where(IntField('likes').eq(10) & IntField('replies').eq(5))
      .orderBy('author')
      .limit(10)
      .groupByMany(['message', 'likes']);
  print(composeFind(find));

  Find colCompare = Sql.find('posts')
      .where(col('authors.id').eq(col('author')))
      .orderBy('author', desc: true)
      .offset(10)
      .groupByMany(['message', 'likes']);
  print(composeFind(colCompare));
}
