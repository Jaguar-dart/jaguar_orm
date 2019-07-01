import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_query_postgres/composer.dart';

main() {
  Find find = Sql.find('post')
      .selMany([max(col('likes')), sum(col('likes'))]).groupBy('authorId');
  print(composeFind(find));
}
