# Changelog

## 2.2.30

+ Update dependencies to be ok with last flutter stable

## 2.2.29

+ Fix upsert that wsa not doing on cascade upsert when foreign key used

## 2.2.28

+ Fix upsert when foreign keys are enabled by adding a flag on the generated method

## 2.2.24

+ Fixed bugs related to or expression in generated methods

## 2.2.23

+ `onlyNonNull` for set columns, insert, upsert and update

## 2.2.22

+ Deduplication in attach during upsert
+ `attach` gets amn optional `upsert` parameter to control upsert or insert

## 2.2.21

+ `newModel` instead of `model` is used in generated `upsert` code

## 2.2.16

+ Fixed `builder.dart` library name

## 2.2.10

+ `fetchBy*` bug fix when pivots are empty

## 2.2.8

+ Immutability
+ Fixes for reflexive relations

## 2.2.6

+ Fixed autoincrement

## 2.2.5

+ Reflexive relations

## 2.1.20

+ `IgnoreColumn` on getters fix

## 2.1.17

+ Better exception printing for field parse exceptions

## 2.1.16

+ Dart2 fixes

## 2.1.15

+ Relations without associations

## 2.1.14

+ Generate `preloadAll` for many-to-many relations
+ Do not generate tableName

## 2.1.12

+ Added `only` to `update`

## 2.1.10

+ Removed `findWhere` and `removeWhere`. They are now in `Bean`.

## 2.1.9

+ Added `findOneWhere`

## 2.1.8

+ Autoincrement cascading

## 2.1.6

+ Return insert id for associations

## 2.1.5

+ Changed `NumField` to `DoubleField`

## 2.1.4

+ Using `parseValue` for parsing value from Database

## 2.1.2

+ Fixed bug where `BoolField` is generated as `BitField`

## 2.1.1

+ Dart2 support
