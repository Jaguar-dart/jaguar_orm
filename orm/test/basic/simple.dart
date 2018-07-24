import 'package:test/test.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../example/model/basic/simple.dart';

final adapter =
    new PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

void main() {
  group('Basic', () {
    final userBean = new UserBean(adapter);

    setUpAll(() async {
      await adapter.connect();
    });

    tearDownAll(() async {
      await adapter.close();
    });

    setUp(() async {
      await userBean.drop();
      await userBean.createTable();
    });

    test('Insert', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = new User(id: '1', name: 'teja', age: 29);
      final insert2 = new User(id: '2', name: 'kleak', age: 24);
      final insert3 = new User(id: '3', name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      users = await userBean.getAll();
      expect(users, [insert1, insert2, insert3]);
    });

    test('Find', () async {
      User user = await userBean.find('1');
      expect(user, null);
      final insert1 = new User(id: '1', name: 'teja', age: 29);
      final insert2 = new User(id: '2', name: 'kleak', age: 24);
      final insert3 = new User(id: '3', name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      user = await userBean.find('2');
      expect(user, insert2);
    });

    test('Update', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = new User(id: '1', name: 'teja', age: 29);
      final insert2 = new User(id: '2', name: 'kleak', age: 24);
      final insert3 = new User(id: '3', name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      insert2.age = 26;
      expect(await userBean.update(insert2), 1);
      users = await userBean.getAll();
      expect(users, [insert1, insert3, insert2]);
    });

    test('RemoveOne', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = new User(id: '1', name: 'teja', age: 29);
      final insert2 = new User(id: '2', name: 'kleak', age: 24);
      final insert3 = new User(id: '3', name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      expect(await userBean.remove('2'), 1);
      users = await userBean.getAll();
      expect(users, [insert1, insert3]);
    });

    test('RemoveMany', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = new User(id: '1', name: 'teja', age: 29);
      final insert2 = new User(id: '2', name: 'kleak', age: 24);
      final insert3 = new User(id: '3', name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      expect(await userBean.removeMany([insert1, insert2]), 2);
      users = await userBean.getAll();
      expect(users, [insert3]);
    });
  });
}
