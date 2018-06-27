part of jaguary_query.operators;

/// DSL to create 'is equal to' relational condition
Cond<int> eqInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.Eq, rhs);

/// DSL to create 'is not equal to' relational condition
Cond<int> neInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.Ne, rhs);

/// DSL to create 'is greater than' relational condition
Cond<int> gtInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.Gt, rhs);

/// DSL to create 'is greater than or equal to' relational condition
Cond<int> gtEqInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.GtEq, rhs);

/// DSL to create 'is less than or equal to' relational condition
Cond<int> ltEqInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.LtEq, rhs);

/// DSL to create 'is less than' relational condition
Cond<int> ltInt(String field, int rhs, [String tableAlias]) =>
    new Cond<int>(col<int>(field, tableAlias), Op.Lt, rhs);

/// DSL to create 'in-between' relational condition
Between<int> inBetweenInt(String field, int low, int high,
        [String tableAlias]) =>
    new Between<int>(col<int>(field, tableAlias), low, high);
