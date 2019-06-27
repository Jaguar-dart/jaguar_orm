import 'dart:async';

import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

part 'complex.jorm.dart';

class ProductItems {
  /// constructor
  ProductItems();

  ProductItems.make({this.id, this.name});

  /// fields
  @primaryKey
  String id;

  @Column(notNull: true)
  String name;

  @ManyToMany(ProductItemsPivotBean, ProductBean)
  List<Product> items;

  String toString() => {"id": id, "name": name, "items": items}.toString();
}

/// bean
@GenBean()
class ProductItemsBean extends Bean<ProductItems> with _ProductItemsBean {
  final BeanRepo beanRepo;

  ProductItemsBean(Adapter adapter, this.beanRepo) : super(adapter);

  String get tableName => "product_list";
}

class ProductItemsPivot {
  /// constructor
  ProductItemsPivot();

  ProductItemsPivot.make(this.productId, this.productListId);

  /// fields
  @BelongsTo.many(ProductBean, references: 'id')
  String productId;

  @BelongsTo.many(ProductItemsBean, references: 'id')
  String productListId;
}

@GenBean()
class ProductItemsPivotBean extends Bean<ProductItemsPivot>
    with _ProductItemsPivotBean {
  final BeanRepo beanRepo;

  ProductItemsPivotBean(Adapter adapter, this.beanRepo) : super(adapter);

  String get tableName => "product_list_pivot";
}

class Product {
  /// constructor
  Product();
  Product.make({this.id, this.name, this.sku, this.categoryId});

  /// fields
  @primaryKey
  String id;

  @Column(notNull: false)
  String sku;

  @Column(notNull: true)
  String name;

  @Column(notNull: true)
  @BelongsTo.many(CategoryBean, references: 'id')
  int categoryId;

  @ManyToMany(ProductItemsPivotBean, ProductItemsBean)
  List<ProductItems> lists = [];

  /// database
  String toString() =>
      {"id": id, "sku": sku, "name": name, "lists": lists}.toString();
}

/// bean
@GenBean()
class ProductBean extends Bean<Product> with _ProductBean {
  final BeanRepo beanRepo;

  ProductBean(Adapter adapter, this.beanRepo) : super(adapter);

  /// Table name for the model this bean manages
  String get tableName => "product";
}

class Category {
  @primaryKey
  int id;

  @HasMany(ProductBean)
  List<Product> products;

  Category({this.id});
}

/// bean
@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  final BeanRepo beanRepo;

  CategoryBean(Adapter adapter, this.beanRepo) : super(adapter);

  /// Table name for the model this bean manages
  String get tableName => "category";
}
