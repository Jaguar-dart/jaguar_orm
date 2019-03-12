// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'example.dart';

// **************************************************************************
// BeanGenerator
// **************************************************************************

abstract class _CartItemBean implements Bean<CartItem> {
  final id = IntField('id');
  final amount = DoubleField('amount');
  final product = StrField('product');
  final quantity = IntField('quantity');
  final cartId = IntField('cart_id');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        amount.name: amount,
        product.name: product,
        quantity.name: quantity,
        cartId.name: cartId,
      };
  CartItem fromMap(Map map) {
    CartItem model = CartItem();
    model.id = adapter.parseValue(map['id']);
    model.amount = adapter.parseValue(map['amount']);
    model.product = adapter.parseValue(map['product']);
    model.quantity = adapter.parseValue(map['quantity']);
    model.cartId = adapter.parseValue(map['cart_id']);

    return model;
  }

  List<SetColumn> toSetColumns(CartItem model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(amount.set(model.amount));
      ret.add(product.set(model.product));
      ret.add(quantity.set(model.quantity));
      ret.add(cartId.set(model.cartId));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(amount.name)) ret.add(amount.set(model.amount));
      if (only.contains(product.name)) ret.add(product.set(model.product));
      if (only.contains(quantity.name)) ret.add(quantity.set(model.quantity));
      if (only.contains(cartId.name)) ret.add(cartId.set(model.cartId));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.amount != null) {
        ret.add(amount.set(model.amount));
      }
      if (model.product != null) {
        ret.add(product.set(model.product));
      }
      if (model.quantity != null) {
        ret.add(quantity.set(model.quantity));
      }
      if (model.cartId != null) {
        ret.add(cartId.set(model.cartId));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addDouble(amount.name, isNullable: false);
    st.addStr(product.name, isNullable: true);
    st.addInt(quantity.name, isNullable: false);
    st.addInt(cartId.name,
        foreignTable: cartBean.tableName, foreignCol: 'id', isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(CartItem model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      CartItem newModel;
    }
    return retId;
  }

  Future<void> insertMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = inserters.addAll(data);
    await adapter.insertMany(insert);
    return;
  }

  Future<dynamic> upsert(CartItem model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      CartItem newModel;
    }
    return retId;
  }

  Future<void> upsertMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upserters.addAll(data);
    await adapter.upsertMany(upsert);
    return;
  }

  Future<int> update(CartItem model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.update(update);
  }

  Future<void> updateMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updaters.addAll(data, where);
    await adapter.updateMany(update);
    return;
  }

  Future<CartItem> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find);
  }

  Future<int> remove(int id) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<CartItem> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<List<CartItem>> findByCart(int cartId,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.cartId.eq(cartId));
    return findMany(find);
  }

  Future<List<CartItem>> findByCartList(List<Cart> models,
      {bool preload = false, bool cascade = false}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Cart model in models) {
      find.or(this.cartId.eq(model.id));
    }
    return findMany(find);
  }

  Future<int> removeByCart(int cartId) async {
    final Remove rm = remover.where(this.cartId.eq(cartId));
    return await adapter.remove(rm);
  }

  void associateCart(CartItem child, Cart parent) {
    child.cartId = parent.id;
  }

  CartBean get cartBean;
}

abstract class _CartBean implements Bean<Cart> {
  final id = IntField('id');
  final amount = DoubleField('amount');
  Map<String, Field> _fields;
  Map<String, Field> get fields => _fields ??= {
        id.name: id,
        amount.name: amount,
      };
  Cart fromMap(Map map) {
    Cart model = Cart();
    model.id = adapter.parseValue(map['id']);
    model.amount = adapter.parseValue(map['amount']);

    return model;
  }

  List<SetColumn> toSetColumns(Cart model,
      {bool update = false, Set<String> only, bool onlyNonNull = false}) {
    List<SetColumn> ret = [];

    if (only == null && !onlyNonNull) {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      ret.add(amount.set(model.amount));
    } else if (only != null) {
      if (model.id != null) {
        if (only.contains(id.name)) ret.add(id.set(model.id));
      }
      if (only.contains(amount.name)) ret.add(amount.set(model.amount));
    } else /* if (onlyNonNull) */ {
      if (model.id != null) {
        ret.add(id.set(model.id));
      }
      if (model.amount != null) {
        ret.add(amount.set(model.amount));
      }
    }

    return ret;
  }

  Future<void> createTable({bool ifNotExists = false}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addInt(id.name, primary: true, autoIncrement: true, isNullable: false);
    st.addDouble(amount.name, isNullable: false);
    return adapter.createTable(st);
  }

  Future<dynamic> insert(Cart model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.insert(insert);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        newModel ??= await find(retId);
        model.items.forEach((x) => cartItemBean.associateCart(x, newModel));
        for (final child in model.items) {
          await cartItemBean.insert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> insertMany(List<Cart> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = inserters.addAll(data);
      await adapter.insertMany(insert);
      return;
    }
  }

  Future<dynamic> upsert(Cart model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .id(id.name);
    var retId = await adapter.upsert(upsert);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        newModel ??= await find(retId);
        model.items.forEach((x) => cartItemBean.associateCart(x, newModel));
        for (final child in model.items) {
          await cartItemBean.upsert(child, cascade: cascade);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Cart> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
      }
      final UpsertMany upsert = upserters.addAll(data);
      await adapter.upsertMany(upsert);
      return;
    }
  }

  Future<int> update(Cart model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false}) async {
    final Update update = updater
        .where(this.id.eq(model.id))
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    final ret = adapter.update(update);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        if (associate) {
          newModel ??= await find(model.id);
          model.items.forEach((x) => cartItemBean.associateCart(x, newModel));
        }
        for (final child in model.items) {
          await cartItemBean.update(child,
              cascade: cascade, associate: associate);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Cart> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updaters.addAll(data, where);
      await adapter.updateMany(update);
      return;
    }
  }

  Future<Cart> find(int id,
      {bool preload = false, bool cascade = false}) async {
    final Find find = finder.where(this.id.eq(id));
    final Cart model = await findOne(find);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade);
    }
    return model;
  }

  Future<int> remove(int id, {bool cascade = false}) async {
    if (cascade) {
      final Cart newModel = await find(id);
      if (newModel != null) {
        await cartItemBean.removeByCart(newModel.id);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove);
  }

  Future<int> removeMany(List<Cart> models) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove);
  }

  Future<Cart> preload(Cart model, {bool cascade = false}) async {
    model.items = await cartItemBean.findByCart(model.id,
        preload: cascade, cascade: cascade);
    return model;
  }

  Future<List<Cart>> preloadAll(List<Cart> models,
      {bool cascade = false}) async {
    models.forEach((Cart model) => model.items ??= []);
    await OneToXHelper.preloadAll<Cart, CartItem>(
        models,
        (Cart model) => [model.id],
        cartItemBean.findByCartList,
        (CartItem model) => [model.cartId],
        (Cart model, CartItem child) =>
            model.items = List.from(model.items)..add(child),
        cascade: cascade);
    return models;
  }

  CartItemBean get cartItemBean;
}
