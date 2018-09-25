// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'complex.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

/*
Exception while parsing field: items!
Unsupported operation: Null
#0      _NullConstant.read (package:source_gen/src/constants/reader.dart:154:29)
#1      ParsedBean._parseFields (package:jaguar_orm_gen/src/parser/parser.dart:265:31)
#2      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:75:5)
#3      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:88:16)
#4      ParsedBean.parseRelation (package:jaguar_orm_gen/src/parser/parser.dart:416:60)
#5      ParsedBean._relation (package:jaguar_orm_gen/src/parser/parser.dart:368:5)
#6      ParsedBean._parseFields (package:jaguar_orm_gen/src/parser/parser.dart:332:16)
#7      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:75:5)
#8      BeanGenerator.generateForAnnotatedElement (package:jaguar_orm_gen/src/hook/hook.dart:38:56)
<asynchronous suspension>
#9      GeneratorForAnnotation.generate (package:source_gen/src/generator_for_annotation.dart:47:28)
<asynchronous suspension>
#10     _generate (package:source_gen/src/builder.dart:253:35)
<asynchronous suspension>
#11     _Builder._generateForLibrary (package:source_gen/src/builder.dart:72:15)
<asynchronous suspension>
#12     _Builder.build (package:source_gen/src/builder.dart:66:11)
<asynchronous suspension>
#13     runBuilder.buildForInput (package:build/src/generate/run_builder.dart:43:21)
<asynchronous suspension>
#14     MappedListIterable.elementAt (dart:_internal/iterable.dart:414:29)
#15     ListIterator.moveNext (dart:_internal/iterable.dart:343:26)
#16     Future.wait (dart:async/future.dart:392:26)
#17     runBuilder.<anonymous closure> (package:build/src/generate/run_builder.dart:49:36)
#18     _rootRun (dart:async/zone.dart:1124:13)
#19     _CustomZone.run (dart:async/zone.dart:1021:19)
#20     _runZoned (dart:async/zone.dart:1516:10)
#21     runZoned (dart:async/zone.dart:1500:12)
#22     scopeLogAsync (package:build/src/builder/logging.dart:22:3)
#23     runBuilder (package:build/src/generate/run_builder.dart:49:9)
<asynchronous suspension>
#24     _SingleBuild._runForInput.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:454:17)
#25     _NoOpBuilderActionTracker.track (package:build_runner_core/src/generate/performance_tracker.dart:314:73)
#26     _SingleBuild._runForInput.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:453:21)
<asynchronous suspension>
#27     new Future.sync (dart:async/future.dart:224:31)
#28     Pool.withResource.<anonymous closure> (package:pool/pool.dart:126:18)
#29     _rootRunUnary (dart:async/zone.dart:1132:38)
#30     _CustomZone.runUnary (dart:async/zone.dart:1029:19)
#31     _FutureListener.handleValue (dart:async/future_impl.dart:129:18)
#32     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:642:45)
#33     Future._propagateToListeners (dart:async/future_impl.dart:671:32)
#34     Future._completeWithValue (dart:async/future_impl.dart:486:5)
#35     Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:516:7)
#36     _rootRun (dart:async/zone.dart:1124:13)
#37     _CustomZone.run (dart:async/zone.dart:1021:19)
#38     _CustomZone.runGuarded (dart:async/zone.dart:923:7)
#39     _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:963:23)
#40     _microtaskLoop (dart:async/schedule_microtask.dart:41:21)
#41     _startMicrotaskLoop (dart:async/schedule_microtask.dart:50:5)
#42     _runPendingImmediateCallback (dart:isolate/runtime/libisolate_patch.dart:115:13)
#43     _RawReceivePortImpl._handleMessage (dart:isolate/runtime/libisolate_patch.dart:172:5)


#0      ParsedBean._parseFields (package:jaguar_orm_gen/src/parser/parser.dart:344:9)
#1      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:75:5)
#2      BeanGenerator.generateForAnnotatedElement (package:jaguar_orm_gen/src/hook/hook.dart:38:56)
<asynchronous suspension>
#3      GeneratorForAnnotation.generate (package:source_gen/src/generator_for_annotation.dart:47:28)
<asynchronous suspension>
#4      _generate (package:source_gen/src/builder.dart:253:35)
<asynchronous suspension>
#5      _Builder._generateForLibrary (package:source_gen/src/builder.dart:72:15)
<asynchronous suspension>
#6      _Builder.build (package:source_gen/src/builder.dart:66:11)
<asynchronous suspension>
#7      runBuilder.buildForInput (package:build/src/generate/run_builder.dart:43:21)
<asynchronous suspension>
#8      MappedListIterable.elementAt (dart:_internal/iterable.dart:414:29)
#9      ListIterator.moveNext (dart:_internal/iterable.dart:343:26)
#10     Future.wait (dart:async/future.dart:392:26)
#11     runBuilder.<anonymous closure> (package:build/src/generate/run_builder.dart:49:36)
#12     _rootRun (dart:async/zone.dart:1124:13)
#13     _CustomZone.run (dart:async/zone.dart:1021:19)
#14     _runZoned (dart:async/zone.dart:1516:10)
#15     runZoned (dart:async/zone.dart:1500:12)
#16     scopeLogAsync (package:build/src/builder/logging.dart:22:3)
#17     runBuilder (package:build/src/generate/run_builder.dart:49:9)
<asynchronous suspension>
#18     _SingleBuild._runForInput.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:454:17)
#19     _NoOpBuilderActionTracker.track (package:build_runner_core/src/generate/performance_tracker.dart:314:73)
#20     _SingleBuild._runForInput.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:453:21)
<asynchronous suspension>
#21     new Future.sync (dart:async/future.dart:224:31)
#22     Pool.withResource.<anonymous closure> (package:pool/pool.dart:126:18)
#23     _rootRunUnary (dart:async/zone.dart:1132:38)
#24     _CustomZone.runUnary (dart:async/zone.dart:1029:19)
#25     _FutureListener.handleValue (dart:async/future_impl.dart:129:18)
#26     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:642:45)
#27     Future._propagateToListeners (dart:async/future_impl.dart:671:32)
#28     Future._completeWithValue (dart:async/future_impl.dart:486:5)
#29     Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:516:7)
#30     _rootRun (dart:async/zone.dart:1124:13)
#31     _CustomZone.run (dart:async/zone.dart:1021:19)
#32     _CustomZone.runGuarded (dart:async/zone.dart:923:7)
#33     _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:963:23)
#34     _microtaskLoop (dart:async/schedule_microtask.dart:41:21)
#35     _startMicrotaskLoop (dart:async/schedule_microtask.dart:50:5)
#36     _runPendingImmediateCallback (dart:isolate/runtime/libisolate_patch.dart:115:13)
#37     _RawReceivePortImpl._handleMessage (dart:isolate/runtime/libisolate_patch.dart:172:5)

*/

abstract class _ProductItemsPivotBean implements Bean<ProductItemsPivot> {
  final productId = new StrField('product_id');
  final productListId = new StrField('product_list_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        productId.name: productId,
        productListId.name: productListId,
      };
  ProductItemsPivot fromMap(Map map) {
    ProductItemsPivot model = ProductItemsPivot();

    model.productId = adapter.parseValue(map['product_id']);
    model.productListId = adapter.parseValue(map['product_list_id']);

    return model;
  }

  List<SetColumn> toSetColumns(ProductItemsPivot model,
      {bool update = false, Set<String> only}) {
    List<SetColumn> ret = [];

    if (only == null) {
      ret.add(productId.set(model.productId));
      ret.add(productListId.set(model.productListId));
    } else {
      if (only.contains(productId.name))
        ret.add(productId.set(model.productId));
      if (only.contains(productListId.name))
        ret.add(productListId.set(model.productListId));
    }

    return ret;
  }

  Future<void> createTable() async {
    final st = Sql.create(tableName);
    st.addStr(productId.name,
        foreignTable: productBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    st.addStr(productListId.name,
        foreignTable: productItemsBean.tableName,
        foreignCol: 'id',
        isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(ProductItemsPivot model) async {
    final Insert insert = inserter.setMany(toSetColumns(model));
    return adapter.insert(insert);
  }

  Future<void> insertMany(List<ProductItemsPivot> models) async {
    final List<List<SetColumn>> data =
        models.map((model) => toSetColumns(model)).toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(ProductItemsPivot model) async {
    final Upsert upsert = upserter.setMany(toSetColumns(model));
    return adapter.upsert(upsert);
  }

  Future<void> upsertMany(List<ProductItemsPivot> models) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<void> updateMany(List<ProductItemsPivot> models) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model).toList());
      where.add(null);
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<List<ProductItemsPivot>> findByProduct(String productId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.productId.eq(productId));
    return findMany(find);
  }

  Future<List<ProductItemsPivot>> findByProductList(List<Product> models,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder;
    for (Product model in models) {
      find.or(this.productId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByProduct(String productId) async {
    final Remove rm = remover.where(this.productId.eq(productId));
    return await adapter.remove(rm);
  }

  void associateProduct(ProductItemsPivot child, Product parent) {
    child.productId = parent.id;
  }

  Future<int> detachProduct(Product model) async {
    final dels = await findByProduct(model.id);
    await removeByProduct(model.id);
    final exp = new Or();
    for (final t in dels) {
      exp.or(productItemsBean.id.eq(t.productListId));
    }
    return await productItemsBean.removeWhere(exp);
  }

  Future<List<ProductItems>> fetchByProduct(Product model) async {
    final pivots = await findByProduct(model.id);
    final exp = new Or();
    for (final t in pivots) {
      exp.or(productItemsBean.id.eq(t.productListId));
    }
    return await productItemsBean.findWhere(exp);
  }

  Future<List<ProductItemsPivot>> findByProductItems(String productListId,
      {bool preload: false, bool cascade: false}) async {
    final Find find = finder.where(this.productListId.eq(productListId));
    return findMany(find);
  }

  Future<List<ProductItemsPivot>> findByProductItemsList(
      List<ProductItems> models,
      {bool preload: false,
      bool cascade: false}) async {
    final Find find = finder;
    for (ProductItems model in models) {
      find.or(this.productListId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByProductItems(String productListId) async {
    final Remove rm = remover.where(this.productListId.eq(productListId));
    return await adapter.remove(rm);
  }

  void associateProductItems(ProductItemsPivot child, ProductItems parent) {
    child.productListId = parent.id;
  }

  Future<int> detachProductItems(ProductItems model) async {
    final dels = await findByProductItems(model.id);
    await removeByProductItems(model.id);
    final exp = new Or();
    for (final t in dels) {
      exp.or(productBean.id.eq(t.productId));
    }
    return await productBean.removeWhere(exp);
  }

  Future<List<Product>> fetchByProductItems(ProductItems model) async {
    final pivots = await findByProductItems(model.id);
    final exp = new Or();
    for (final t in pivots) {
      exp.or(productBean.id.eq(t.productId));
    }
    return await productBean.findWhere(exp);
  }

  Future<dynamic> attach(ProductItems one, Product two) async {
    final ret = new ProductItemsPivot();
    ret.productListId = one.id;
    ret.productId = two.id;
    return insert(ret);
  }

  ProductBean get productBean;
  ProductItemsBean get productItemsBean;
}

/*
Unsupported operation: Null
#0      _NullConstant.read (package:source_gen/src/constants/reader.dart:154:29)
#1      ParsedBean._parseFields (package:jaguar_orm_gen/src/parser/parser.dart:265:31)
#2      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:75:5)
#3      ParsedBean.detect (package:jaguar_orm_gen/src/parser/parser.dart:88:16)
#4      BeanGenerator.generateForAnnotatedElement (package:jaguar_orm_gen/src/hook/hook.dart:38:56)
<asynchronous suspension>
#5      GeneratorForAnnotation.generate (package:source_gen/src/generator_for_annotation.dart:47:28)
<asynchronous suspension>
#6      _generate (package:source_gen/src/builder.dart:253:35)
<asynchronous suspension>
#7      _Builder._generateForLibrary (package:source_gen/src/builder.dart:72:15)
<asynchronous suspension>
#8      _Builder.build (package:source_gen/src/builder.dart:66:11)
<asynchronous suspension>
#9      runBuilder.buildForInput (package:build/src/generate/run_builder.dart:43:21)
<asynchronous suspension>
#10     MappedListIterable.elementAt (dart:_internal/iterable.dart:414:29)
#11     ListIterator.moveNext (dart:_internal/iterable.dart:343:26)
#12     Future.wait (dart:async/future.dart:392:26)
#13     runBuilder.<anonymous closure> (package:build/src/generate/run_builder.dart:49:36)
#14     _rootRun (dart:async/zone.dart:1124:13)
#15     _CustomZone.run (dart:async/zone.dart:1021:19)
#16     _runZoned (dart:async/zone.dart:1516:10)
#17     runZoned (dart:async/zone.dart:1500:12)
#18     scopeLogAsync (package:build/src/builder/logging.dart:22:3)
#19     runBuilder (package:build/src/generate/run_builder.dart:49:9)
<asynchronous suspension>
#20     _SingleBuild._runForInput.<anonymous closure>.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:454:17)
#21     _NoOpBuilderActionTracker.track (package:build_runner_core/src/generate/performance_tracker.dart:314:73)
#22     _SingleBuild._runForInput.<anonymous closure> (package:build_runner_core/src/generate/build_impl.dart:453:21)
<asynchronous suspension>
#23     new Future.sync (dart:async/future.dart:224:31)
#24     Pool.withResource.<anonymous closure> (package:pool/pool.dart:126:18)
#25     _rootRunUnary (dart:async/zone.dart:1132:38)
#26     _CustomZone.runUnary (dart:async/zone.dart:1029:19)
#27     _FutureListener.handleValue (dart:async/future_impl.dart:129:18)
#28     Future._propagateToListeners.handleValueCallback (dart:async/future_impl.dart:642:45)
#29     Future._propagateToListeners (dart:async/future_impl.dart:671:32)
#30     Future._completeWithValue (dart:async/future_impl.dart:486:5)
#31     Future._asyncComplete.<anonymous closure> (dart:async/future_impl.dart:516:7)
#32     _rootRun (dart:async/zone.dart:1124:13)
#33     _CustomZone.run (dart:async/zone.dart:1021:19)
#34     _CustomZone.runGuarded (dart:async/zone.dart:923:7)
#35     _CustomZone.bindCallbackGuarded.<anonymous closure> (dart:async/zone.dart:963:23)
#36     _microtaskLoop (dart:async/schedule_microtask.dart:41:21)
#37     _startMicrotaskLoop (dart:async/schedule_microtask.dart:50:5)
#38     _runPendingImmediateCallback (dart:isolate/runtime/libisolate_patch.dart:115:13)
#39     _RawReceivePortImpl._handleMessage (dart:isolate/runtime/libisolate_patch.dart:172:5)

*/
