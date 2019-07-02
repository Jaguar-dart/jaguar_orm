import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

main() {
  print(composeCreate(
      Create('Person').addStr('name').addByType('scores', Array<int>(Int()))));

  print(composeInsert(Insert('Person')
      .set('name', 'Teja')
      .set('score', A.from([99, 100, 98, 95, 100]))));
  print(composeUpdate(Update('Person').set('score', A.from([1, 2, 3, 4, 5]))));
  //ArrayField('scores').set([1, 2, 3, 4, 5])));
}
