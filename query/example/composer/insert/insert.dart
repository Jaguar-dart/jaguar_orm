// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Insert insert = Sql.insert('posts')
      .setInt('id', 1)
      .setValue('message', 'How are you?')
      .setValue('author', 'teja')
      .setValues({'likes': 0, 'replies': 0});
  print(composeInsert(insert));
}
