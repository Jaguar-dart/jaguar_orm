// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Find find = Sql
      .find('posts')
      .sel('message')
      .where(col('likes').eq(10) & Col.int('replies').eq(5))
      .where(eq('author', 'teja') | like('author', 'kleak*'))
      .orderBy('author', true)
      .limit(10)
      .groupByMany(['message', 'likes']);

  print(composeFind(find));

  Insert insert = Sql
      .insert('posts')
      .setIdValue('id', 1)
      .setValue('message', 'How are you?')
      .setValue('author', 'teja')
      .setValues({'likes': 0, 'replies': 0});

  print(composeInsert(insert));

  Update update = Sql.update('posts').eq('author', 'teja').setValue('likes', 1);

  print(composeUpdate(update));

  Remove delete = Sql.remove('posts').where(eq('author', 'teja'));

  print(composeRemove(delete));

  Update update1 = Sql.update('posts').eq('likes', 5).setValue('likes', 1);

  print(composeUpdate(update1));

  Find find1 = Sql
      .find('posts')
      .where(eqCol('author', col('id', 'authors')))
      .orderBy('author', true)
      .limit(10)
      .groupByMany(['message', 'likes']);

  print(composeFind(find1));
}
