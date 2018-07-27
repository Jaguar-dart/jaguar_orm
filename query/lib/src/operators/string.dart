part of jaguary_query.operators;

/// DSL to create 'is equal to' relational condition
Cond<String> eqStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.Eq, rhs);

/// DSL to create 'is not equal to' relational condition
Cond<String> neStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.Ne, rhs);

/// DSL to create 'is greater than' relational condition
Cond<String> gtStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.Gt, rhs);

/// DSL to create 'is greater than or equal to' relational condition
Cond<String> gtEqStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.GtEq, rhs);

/// DSL to create 'is less than or equal to' relational condition
Cond<String> ltEqStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.LtEq, rhs);

/// DSL to create 'is less than' relational condition
Cond<String> ltStr(String field, String rhs, {String tableName}) =>
    new Cond<String>(new Field<String>.inTable(tableName, field), Op.Lt, rhs);

/// DSL to create 'in-between' relational condition
Between<String> inBetweenStr(String field, String low, String high,
        {String tableName}) =>
    new Between<String>(new Field<String>.inTable(tableName, field), low, high);
