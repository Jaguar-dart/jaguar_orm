// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Update update1 = Sql.update('posts').eq('likes', 5).setValue('likes', 1);
  print(composeUpdate(update1));
}
