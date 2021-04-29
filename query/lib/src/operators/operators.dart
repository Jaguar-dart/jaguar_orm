library jaguary_query.operators;

import 'dart:core';
import 'dart:core' as core;
import 'package:jaguar_query/src/core/core.dart';

part 'int.dart';
part 'string.dart';

/// DSL to create 'is equal to' relational condition
Cond<ValType> eq<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.Eq, rhs);

/// DSL to create 'is not equal to' relational condition
Cond<ValType> ne<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.Ne, rhs);

/// DSL to create 'is greater than' relational condition
Cond<ValType> gt<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.Gt, rhs);

/// DSL to create 'is greater than or equal to' relational condition
Cond<ValType> gtEq<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.GtEq, rhs);

/// DSL to create 'is less than or equal to' relational condition
Cond<ValType> ltEq<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.LtEq, rhs);

/// DSL to create 'is less than' relational condition
Cond<ValType> lt<ValType>(String field, ValType rhs, {String? tableName}) =>
    Cond<ValType>(Field<ValType>.inTable(tableName, field), Op.Lt, rhs);

/// DSL to create 'is like' relational condition
Cond<String> like(String field, String value, {String? tableName}) =>
    Cond<String>(Field<String>.inTable(tableName, field), Op.Like, value);

/// DSL to create 'in-between' relational condition
Between<ValType> between<ValType>(String field, ValType low, ValType high,
        {String? tableName}) =>
    Between<ValType>(Field<ValType>.inTable(tableName, field), low, high);
