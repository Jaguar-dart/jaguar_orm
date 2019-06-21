import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  print(composeCreate(Create('Person')
      .addStr('name')
      .addInt('addressId', foreign: References('address', 'id'))
      .addStr('addressType', foreign: References('address', 'type'))));
}
