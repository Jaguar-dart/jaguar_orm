import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  print(composeAlter(
      Alter('people').addInt('id').addString('name').modifyString('zipcode')));
}
