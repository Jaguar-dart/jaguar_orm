import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

part 'example.jorm.dart';

class CartItem {
  @primaryKey
  int id;

  double amount;

  @Column(notNull: true)
  String product;

  int quantity;

  @BelongsTo.many(CartBean, references: 'id')
  int cartId;

  CartItem({this.amount, this.product, this.quantity, this.id});
  CartItem.make(this.amount, this.product, this.quantity);

  @override
  String toString() =>
      'id=$id, amount=$amount, quantity=$quantity, product=$product, cartId=$cartId';

  CartItem copy({int id, int quantity, String product, double amount}) {
    return CartItem(
      amount: amount ?? this.amount,
      product: product ?? this.product,
      quantity: quantity ?? this.quantity,
      id: id ?? this.id,
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is CartItem &&
          runtimeType == other.runtimeType &&
          amount == other.amount &&
          product == other.product &&
          quantity == other.quantity;

  @override
  int get hashCode => amount.hashCode ^ product.hashCode ^ quantity.hashCode;
}

@GenBean()
class CartItemBean extends Bean<CartItem> with _CartItemBean {
  final BeanRepo beanRepo;

  CartItemBean(Adapter adapter, this.beanRepo) : super(adapter);

  @override
  String get tableName => 'cartItem';
}

class Cart {
  @primaryKey
  int id;

  @HasMany(CartItemBean)
  List<CartItem> items;

  double amount;

  Cart({this.id, this.amount = 0.0, this.items = const []});

  Cart copy({id, amount, items}) {
    return Cart(
      id: id ?? this.id,
      amount: amount ?? this.amount,
      items: items ?? this.items,
    );
  }

  @override
  String toString() => 'id=$id, amount=$amount, items=$items';

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Cart &&
          runtimeType == other.runtimeType &&
          items == other.items &&
          amount == other.amount;

  @override
  int get hashCode => items.hashCode ^ amount.hashCode;
}

@GenBean()
class CartBean extends Bean<Cart> with _CartBean {
  final BeanRepo beanRepo;

  CartBean(Adapter adapter, this.beanRepo) : super(adapter);

  @override
  String get tableName => 'cart';
}
