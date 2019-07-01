// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

String insertAuthor(String name) {
  Insert insert = Sql.insert('author').set('name', name);
  return composeInsert(insert);
}

String insertPost(int authorId, String message, int likes, int dislikes) {
  Insert insert = Sql.insert('post')
      .set('authorId', authorId)
      .set('message', message)
      .setValues({'likes': likes, 'dislikes': dislikes});
  return composeInsert(insert);
}

main() {
  print(insertAuthor('Teja'));

  print(insertPost(1, 'Message1', 15, 15));
  print(insertPost(1, 'Message2', 16, 17));
}
