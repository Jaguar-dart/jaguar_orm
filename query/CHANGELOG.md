# Changelog

## 0.2.8

- Added `drop` method to `Bean`

## 0.2.7

- Added `getAll` and `removeAll` to `Bean`

## 0.2.6

- Bug fix in cascading `Or` and `And` expressions

## 0.2.5

- Functional map based where clauses on `Find`, `Remove` and `Update` statements
    - `andMap`
    - `orMap`

## 0.2.4

- Renamed `dropDatabase` method to `dropDb` in `Adapter`

## 0.2.3

- All statements have `exec` method
- `BuiltFind` renamed to `FindExecutor`
- Made `mapper` method specific in `BuiltFind`

## 0.2.2

- Flexible where clause building for `Find`, `Remove` and `Delete` statements
    - Added `or` method
- Removed ambiguous `Field` operators

## 0.2.0

- Changed `Delete` to `Remove`

## 0.1.7

- Auto-increment for null int and double fields

## 0.1.6

- `Sql` methods take table name as parameter

## 0.1.4

### Breaking change

- `set` method of `Insert` and `Update` uses `Field`

## 0.1.3

- `BuiltFind`

## 0.1.0

- Shorter class names

## 0.0.25

- Unique constraint to `CreateCol`

## 0.0.11

- Create Database statement
- Create table if not exists

## 0.0.1

- Initial version, created by Stagehand
