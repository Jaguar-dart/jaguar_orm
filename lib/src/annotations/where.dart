part of jaguar_orm.annotation;

/// Annotation on parameter of bean method to declare them as condition
abstract class Where {}

/// Annotation on parameter of bean method to declare them as 'is equal to' condition
class WhereEq implements Where {
  const WhereEq();
}

/// Annotation on parameter of bean method to declare them as 'is not equal to' condition
class WhereNe implements Where {
  const WhereNe();
}

/// Annotation on parameter of bean method to declare them as 'is less than' condition
class WhereLt implements Where {
  const WhereLt();
}

/// Annotation on parameter of bean method to declare them as 'is greater than' condition
class WhereGt implements Where {
  const WhereGt();
}

/// Annotation on parameter of bean method to declare them as 'is greater than or equal to'
/// condition
class WhereGtEq implements Where {
  const WhereGtEq();
}

/// Annotation on parameter of bean method to declare them as 'is less than or equal to'
/// condition
class WhereLtEq implements Where {
  const WhereLtEq();
}

/// Annotation on parameter of bean method to declare them as 'is like' condition
class WhereLike implements Where {
  const WhereLike();
}