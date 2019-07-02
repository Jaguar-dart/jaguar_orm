import 'package:jaguar_query/jaguar_query.dart';

abstract class ToDialect {
  /* String | Sql */ toDialect(String dialect, Composer composer);
}


abstract class Composer {
  String find(Find st);

  String expression(Expression expr);
}