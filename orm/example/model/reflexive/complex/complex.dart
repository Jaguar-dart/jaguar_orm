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
  @PrimaryKey()
  String id;

  @Column(isNullable: true)
  String name;

  @ManyToMany(ProductItemsPivotBean, ProductBean)
  List<Product> items;

  String toString() => {"id": id, "name": name, "items": items}.toString();
}

/// bean
@GenBean()
class ProductItemsBean extends Bean<ProductItems> with _ProductItemsBean {
  ProductItemsPivotBean _productItemsPivotBean;
  ProductItemsPivot productItemsPivot;
  ProductBean productBean;

  ProductItemsBean(Adapter adapter)
      : productItemsPivot = ProductItemsPivot(),
        productBean = ProductBean(adapter),
        super(adapter);

  ProductItemsPivotBean get productItemsPivotBean {
    _productItemsPivotBean ??= ProductItemsPivotBean(adapter);
    return _productItemsPivotBean;
  }

  String get tableName => "product_list";
}

class ProductItemsPivot {
  /// constructor
  ProductItemsPivot();

  ProductItemsPivot.make(this.productId, this.productListId);

  /// fields
  @BelongsTo.many(ProductBean)
  String productId;

  @BelongsTo.many(ProductItemsBean)
  String productListId;
}

@GenBean()
class ProductItemsPivotBean extends Bean<ProductItemsPivot>
    with _ProductItemsPivotBean {
  ProductItemsBean _productItemsBean;

  ProductBean _productBean;

  ProductItemsPivotBean(Adapter adapter) : super(adapter);

  ProductBean get productBean {
    _productBean ??= ProductBean(adapter);
    return _productBean;
  }

  ProductItemsBean get productItemsBean {
    _productItemsBean ??= ProductItemsBean(adapter);
    return _productItemsBean;
  }

  String get tableName => "product_list_pivot";
}

class Product {
  /// constructor
  Product();
  Product.make({this.id, this.name, this.sku, this.categoryId});

  /// fields
  @PrimaryKey()
  String id;

  @Column(isNullable: false)
  String sku;

  @Column(isNullable: true)
  String name;

  @BelongsTo(CategoryBean, isNullable: true, byHasMany: true)
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
  ProductItemsBean _productItemsBean;
  ProductItemsPivotBean _productPivotBean;
  ProductBean(Adapter adapter) : super(adapter);

  ProductItemsBean get productItemsBean {
    _productItemsBean ??= ProductItemsBean(adapter);
    return _productItemsBean;
  }

  ProductItemsPivotBean get productItemsPivotBean {
    _productPivotBean ??= ProductItemsPivotBean(adapter);
    return _productPivotBean;
  }

  /// Table name for the model this bean manages
  String get tableName => "product";

  @override
  CategoryBean get categoryBean => CategoryBean(adapter);
}

class Category {
  @PrimaryKey()
  int id;

  @HasMany(ProductBean)
  List<Product> products;

  Category({this.id});
}

/// bean
@GenBean()
class CategoryBean extends Bean<Category> with _CategoryBean {
  ProductBean get productBean => ProductBean(adapter);

  CategoryBean(Adapter adapter) : super(adapter);

  /// Table name for the model this bean manages
  String get tableName => "category";
}
