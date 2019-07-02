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

class Tuple {
  final List<dynamic> items;

  @override
  final int hashCode;

  Tuple(this.items) : hashCode = hashObjects(items);

  dynamic operator [](int index) => items[index];
}
