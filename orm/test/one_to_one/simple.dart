import 'package:test/test.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../example/model/associations/one_to_one/simple.dart';

final adapter =
    PgAdapter('postgres', username: 'postgres', password: 'dart_jaguar');

void main() {
  group('OneToOne', () {
    final userBean = UserBean(adapter);
    final addressBean = AddressBean(adapter);

    setUpAll(() async {
      await adapter.connect();
    });

    tearDownAll(() async {
      await adapter.close();
    });

    setUp(() async {
      await addressBean.drop();
      await userBean.drop();
      await userBean.createTable();
      await addressBean.createTable();
    });

    test('InsertNoCascade', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = User(id: '1', name: 'teja');
      final insert2 = User(id: '2', name: 'kleak');
      final insert3 = User(id: '3', name: 'lejard');
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      users = await userBean.getAll();
      expect(users, [insert1, insert2, insert3]);
    });

    test('InsertCascade', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final addr1 = Address(id: '1', street: 'teja');
      final addr2 = Address(id: '2', street: 'kleak');
      final addr3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addr1);
      final insert2 = User(id: '2', name: 'kleak', address: addr2);
      final insert3 = User(id: '3', name: 'lejard', address: addr3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);
      users = await userBean.getAll();
      await userBean.preloadAll(users);
      expect(users, [insert1, insert2, insert3]);
      addresses = await addressBean.getAll();
      expect(addresses, [addr1, addr2, addr3]);
    });

    test('FindPreload', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final addrInsert1 = Address(id: '1', street: 'teja');
      final addrInsert2 = Address(id: '2', street: 'kleak');
      final addrInsert3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addrInsert1);
      final insert2 = User(id: '2', name: 'kleak', address: addrInsert2);
      final insert3 = User(id: '3', name: 'lejard', address: addrInsert3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);
      User user = await userBean.find('1');
      insert1.address = null;
      expect(user, insert1);
      user = await userBean.find('1', preload: true);
      insert1.address = addrInsert1;
      expect(user, insert1);
    });

    test('RemoveNoCascade', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      expect(addresses, []);
      final addrInsert1 = Address(id: '1', street: 'teja');
      final addrInsert3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addrInsert1);
      final insert2 = User(id: '2', name: 'kleak');
      final insert3 = User(id: '3', name: 'lejard', address: addrInsert3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);

      await userBean.remove('2');

      users = await userBean.getAll();
      await userBean.preloadAll(users);
      expect(users, [insert1, insert3]);
      addresses = await addressBean.getAll();
      expect(addresses, [addrInsert1, addrInsert3]);
    });

    test('RemoveCascade', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      final addrInsert1 = Address(id: '1', street: 'teja');
      final addrInsert2 = Address(id: '2', street: 'kleak');
      final addrInsert3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addrInsert1);
      final insert2 = User(id: '2', name: 'kleak', address: addrInsert2);
      final insert3 = User(id: '3', name: 'lejard', address: addrInsert3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);

      await userBean.remove('2', cascade: true);

      users = await userBean.getAll();
      await userBean.preloadAll(users);
      expect(users, [insert1, insert3]);
      addresses = await addressBean.getAll();
      expect(addresses, [addrInsert1, addrInsert3]);
    });

    test('RemoveMany', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final insert1 = User(id: '1', name: 'teja');
      final insert2 = User(id: '2', name: 'kleak');
      final insert3 = User(id: '3', name: 'lejard');
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);

      await userBean.removeMany([insert1, insert2]);

      users = await userBean.getAll();
      await userBean.preloadAll(users);
      expect(users, [insert3]);
    });

    test('UpdateCascade', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final addrInsert1 = Address(id: '1', street: 'teja');
      final addrInsert2 = Address(id: '2', street: 'kleak');
      final addrInsert3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addrInsert1);
      final insert2 = User(id: '2', name: 'kleak', address: addrInsert2);
      final insert3 = User(id: '3', name: 'lejard', address: addrInsert3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);
      User user = await userBean.find('2', preload: true);
      expect(user, insert2);
      user.name = 'Kleak';
      user.address.street = 'Kleak';
      await userBean.update(user, cascade: true);
      addrInsert2.street = 'Kleak';
      insert2.name = 'Kleak';
      expect(user, insert2);
    });

    test('Preload', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final addrInsert1 = Address(id: '1', street: 'teja');
      final addrInsert2 = Address(id: '2', street: 'kleak');
      final addrInsert3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addrInsert1);
      final insert2 = User(id: '2', name: 'kleak', address: addrInsert2);
      final insert3 = User(id: '3', name: 'lejard', address: addrInsert3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);
      User user = await userBean.find('1');
      insert1.address = null;
      expect(user, insert1);
      await userBean.preload(user);
      insert1.address = addrInsert1;
      expect(user, insert1);
    });

    test('PreloadALl', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      List<Address> addresses = await addressBean.getAll();
      expect(addresses, []);
      final addr1 = Address(id: '1', street: 'teja');
      final addr2 = Address(id: '2', street: 'kleak');
      final addr3 = Address(id: '3', street: 'lejard');
      final insert1 = User(id: '1', name: 'teja', address: addr1);
      final insert2 = User(id: '2', name: 'kleak', address: addr2);
      final insert3 = User(id: '3', name: 'lejard', address: addr3);
      await userBean.insert(insert1, cascade: true);
      await userBean.insert(insert2, cascade: true);
      await userBean.insert(insert3, cascade: true);
      users = await userBean.getAll();
      await userBean.preloadAll(users);
      expect(users, [insert1, insert2, insert3]);
      addresses = await addressBean.getAll();
      expect(addresses, [addr1, addr2, addr3]);
    });
  });
}
