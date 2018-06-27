library jaguary_query.operators;

import 'dart:core';
import 'dart:core' as core;
import 'package:jaguar_query/src/core/core.dart';

part 'int.dart';
part 'string.dart';

part 'column.dart';

/// DSL to create 'is equal to' relational condition
Cond<ValType> eq<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.Eq, rhs);

/// DSL to create 'is not equal to' relational condition
Cond<ValType> ne<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.Ne, rhs);

/// DSL to create 'is greater than' relational condition
Cond<ValType> gt<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.Gt, rhs);

/// DSL to create 'is greater than or equal to' relational condition
Cond<ValType> gtEq<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.GtEq, rhs);

/// DSL to create 'is less than or equal to' relational condition
Cond<ValType> ltEq<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.LtEq, rhs);

/// DSL to create 'is less than' relational condition
Cond<ValType> lt<ValType>(String field, ValType rhs, [String tableAlias]) =>
    new Cond<ValType>(col<ValType>(field, tableAlias), Op.Lt, rhs);

/// DSL to create 'is like' relational condition
Cond<String> like(String field, String value, [String tableAlias]) =>
    new Cond<String>(col<String>(field, tableAlias), Op.Like, value);

/// DSL to create 'in-between' relational condition
Between<ValType> between<ValType>(String field, ValType low, ValType high,
        [String tableAlias]) =>
    new Between<ValType>(col<ValType>(field, tableAlias), low, high);
