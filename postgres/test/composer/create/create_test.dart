import 'package:test/test.dart';
import 'package:jaguar_query_postgres/composer.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';

void main() {
  group('composer.create', () {
    setUp(() {});

    test('Composite ForeignKey', () {
      expect(
          composeCreate(Create('Person')
              .addStr('name')
              .addInt('addressId', foreign: References('address', 'id'))
              .addStr('addressType', foreign: References('address', 'type'))),
          "CREATE TABLE Person (name TEXT, addressId INT, addressType TEXT, FOREIGN KEY (addressId, addressType) REFERENCES address(id, type))");
    });
  });
}
