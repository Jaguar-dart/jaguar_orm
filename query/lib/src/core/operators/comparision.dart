part of query;

/// Relational comparision operator
class Op {
  /// Identification code for this comparision operator
  final int id;

  /// String representation of this comparision operator
  final String string;

  const Op._(this.id, this.string);

  /// 'is equal to' relational comparision operator
  static const Op Eq = const Op._(0, '=');

  /// 'is not equal to' relational comparision operator
  static const Op Ne = const Op._(1, '<>');

  /// 'is greater than' relational comparision operator
  static const Op Gt = const Op._(2, '>');

  /// 'is greater than or equal to' relational comparision operator
  static const Op GtEq = const Op._(3, '>=');

  /// 'is less than or equal to' relational comparision operator
  static const Op LtEq = const Op._(4, '<=');

  /// 'is less than' relational comparision operator
  static const Op Lt = const Op._(5, '<');

  /// 'is like' relational comparision operator
  static const Op Like = const Op._(6, 'LIKE');

  /// 'IS' relational comparision operator
  static const Op Is = const Op._(7, 'IS');

  /// 'IS NOT' relational comparision operator
  static const Op IsNot = const Op._(8, 'IS NOT');
}
