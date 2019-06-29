// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Find find = Sql.find(Find('post').selAll())
      .where(eq(col('likes'), 10) & eq(col('replies'), 5))
      .orderBy('author', desc: false);
  print(composeFind(find));
}
