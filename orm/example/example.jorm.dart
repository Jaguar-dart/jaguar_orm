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
      ret.add(id.set(model.id));
      ret.add(amount.set(model.amount));
      ret.add(product.set(model.product));
      ret.add(quantity.set(model.quantity));
      ret.add(cartId.set(model.cartId));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
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

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      Int(),
      isPrimary: true,
    );
    st.addByType(
      amount.name,
      Double(),
    );
    st.addByType(
      product.name,
      Str(),
      notNull: true,
    );
    st.addByType(
      quantity.name,
      Int(),
    );
    st.addByType(
      cartId.name,
      Int(),
      foreign: References(cartBean.tableName, "id"),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<void> insert(CartItem model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.insert(insert, withConn: withConn);
  }

  Future<void> insertMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = models
        .map((model) =>
            toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
        .toList();
    final InsertMany insert = insertser.addAll(data);
    await adapter.insertMany(insert, withConn: withConn);
    return;
  }

  Future<void> upsert(CartItem model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    return adapter.upsert(upsert, withConn: withConn);
  }

  Future<void> upsertMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(
          toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());
    }
    final UpsertMany upsert = upsertser.addAll(data);
    await adapter.upsertMany(upsert, withConn: withConn);
    return;
  }

  Future<int> update(CartItem model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Update update = updater.where(this.id.eq(model.id)).setMany(
        toSetColumns(model,
            only: only, onlyNonNull: onlyNonNull, update: true));
    return adapter.update(update, withConn: withConn);
  }

  Future<void> updateMany(List<CartItem> models,
      {bool onlyNonNull = false, Set<String> only, Connection withConn}) async {
    final List<List<SetColumn>> data = [];
    final List<Expression> where = [];
    for (var i = 0; i < models.length; ++i) {
      var model = models[i];
      data.add(toSetColumns(model,
              only: only, onlyNonNull: onlyNonNull, update: true)
          .toList());
      where.add(this.id.eq(model.id));
    }
    final UpdateMany update = updateser.addAll(data, where);
    await adapter.updateMany(update, withConn: withConn);
    return;
  }

  Future<CartItem> find(int id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    return await findOne(find, withConn: withConn);
  }

  Future<int> remove(int id, {Connection withConn}) async {
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<CartItem> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<List<CartItem>> findByCart(int cartId,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.cartId.eq(cartId));
    return findMany(find, withConn: withConn);
  }

  Future<List<CartItem>> findByCartList(List<Cart> models,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
// Return if models is empty. If this is not done, all the records will be returned!
    if (models == null || models.isEmpty) return [];
    final Find find = finder;
    for (Cart model in models) {
      find.or(this.cartId.eq(model.id));
    }
    return findMany(find, withConn: withConn);
  }

  Future<int> removeByCart(int cartId, {Connection withConn}) async {
    final Remove rm = remover.where(this.cartId.eq(cartId));
    return await adapter.remove(rm, withConn: withConn);
  }

  void associateCart(CartItem child, Cart parent) {
    child.cartId = parent.id;
  }

  Future<List<Cart>> fetchCart(CartItem model, {Connection withConn}) async {
    return cartBean.findWhere(cartBean.id.eq(model.cartId), withConn: withConn);
  }

  CartBean get cartBean => beanRepo[CartBean];
  BeanRepo get beanRepo;
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
      ret.add(id.set(model.id));
      ret.add(amount.set(model.amount));
    } else if (only != null) {
      if (only.contains(id.name)) ret.add(id.set(model.id));
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

  Future<void> createTable(
      {bool ifNotExists = false, Connection withConn}) async {
    final st = Sql.create(tableName, ifNotExists: ifNotExists);
    st.addByType(
      id.name,
      Int(),
      isPrimary: true,
    );
    st.addByType(
      amount.name,
      Double(),
    );
    return adapter.createTable(st, withConn: withConn);
  }

  Future<dynamic> insert(Cart model,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    final Insert insert = inserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.insert(insert, withConn: withConn);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        newModel ??= await find(model.id, withConn: withConn);
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
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(insert(model, cascade: cascade, withConn: withConn));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = models
          .map((model) =>
              toSetColumns(model, only: only, onlyNonNull: onlyNonNull))
          .toList();
      final InsertMany insert = insertser.addAll(data);
      await adapter.insertMany(insert, withConn: withConn);
      return;
    }
  }

  Future<dynamic> upsert(Cart model,
      {bool cascade = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Upsert upsert = upserter
        .setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));
    var retId = await adapter.upsert(upsert, withConn: withConn);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        newModel ??= await find(model.id, withConn: withConn);
        model.items.forEach((x) => cartItemBean.associateCart(x, newModel));
        for (final child in model.items) {
          await cartItemBean.upsert(child,
              cascade: cascade, withConn: withConn);
        }
      }
    }
    return retId;
  }

  Future<void> upsertMany(List<Cart> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(upsert(model, cascade: cascade, withConn: withConn));
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
      final UpsertMany upsert = upsertser.addAll(data);
      await adapter.upsertMany(upsert, withConn: withConn);
      return;
    }
  }

  Future<int> update(Cart model,
      {bool cascade = false,
      bool associate = false,
      Set<String> only,
      bool onlyNonNull = false,
      Connection withConn}) async {
    final Update update = updater.where(this.id.eq(model.id)).setMany(
        toSetColumns(model,
            only: only, onlyNonNull: onlyNonNull, update: true));
    final ret = adapter.update(update, withConn: withConn);
    if (cascade) {
      Cart newModel;
      if (model.items != null) {
        if (associate) {
          newModel ??= await find(model.id, withConn: withConn);
          model.items.forEach((x) => cartItemBean.associateCart(x, newModel));
        }
        for (final child in model.items) {
          await cartItemBean.update(child,
              cascade: cascade, associate: associate, withConn: withConn);
        }
      }
    }
    return ret;
  }

  Future<void> updateMany(List<Cart> models,
      {bool cascade = false,
      bool onlyNonNull = false,
      Set<String> only,
      Connection withConn}) async {
    if (cascade) {
      final List<Future> futures = [];
      for (var model in models) {
        futures.add(update(model, cascade: cascade, withConn: withConn));
      }
      await Future.wait(futures);
      return;
    } else {
      final List<List<SetColumn>> data = [];
      final List<Expression> where = [];
      for (var i = 0; i < models.length; ++i) {
        var model = models[i];
        data.add(toSetColumns(model,
                only: only, onlyNonNull: onlyNonNull, update: true)
            .toList());
        where.add(this.id.eq(model.id));
      }
      final UpdateMany update = updateser.addAll(data, where);
      await adapter.updateMany(update, withConn: withConn);
      return;
    }
  }

  Future<Cart> find(int id,
      {bool preload = false, bool cascade = false, Connection withConn}) async {
    final Find find = finder.where(this.id.eq(id));
    final Cart model = await findOne(find, withConn: withConn);
    if (preload && model != null) {
      await this.preload(model, cascade: cascade, withConn: withConn);
    }
    return model;
  }

  Future<int> remove(int id,
      {bool cascade = false, Connection withConn}) async {
    if (cascade) {
      final Cart newModel = await find(id, withConn: withConn);
      if (newModel != null) {
        await cartItemBean.removeByCart(newModel.id, withConn: withConn);
      }
    }
    final Remove remove = remover.where(this.id.eq(id));
    return adapter.remove(remove, withConn: withConn);
  }

  Future<int> removeMany(List<Cart> models, {Connection withConn}) async {
// Return if models is empty. If this is not done, all records will be removed!
    if (models == null || models.isEmpty) return 0;
    final Remove remove = remover;
    for (final model in models) {
      remove.or(this.id.eq(model.id));
    }
    return adapter.remove(remove, withConn: withConn);
  }

  Future<Cart> preload(Cart model,
      {bool cascade = false, Connection withConn}) async {
    model.items = await cartItemBean.findByCart(model.id,
        preload: cascade, cascade: cascade, withConn: withConn);
    return model;
  }

  Future<List<Cart>> preloadAll(List<Cart> models,
      {bool cascade = false, Connection withConn}) async {
    models.forEach((Cart model) => model.items ??= []);
    await OneToXHelper.preloadAll<Cart, CartItem>(
        models,
        (Cart model) => [model.id],
        cartItemBean.findByCartList,
        (CartItem model) => [model.cartId],
        (Cart model, CartItem child) =>
            model.items = List.from(model.items)..add(child),
        cascade: cascade,
        withConn: withConn);
    return models;
  }

  CartItemBean get cartItemBean => beanRepo[CartItemBean];
  BeanRepo get beanRepo;
}
