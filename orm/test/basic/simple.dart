import 'package:test/test.dart';
import 'package:jaguar_query_postgres/jaguar_query_postgres.dart';
import '../../example/model/basic/simple.dart';

final adapter =
    PgAdapter('example', username: 'postgres', password: 'dart_jaguar');

void main() {
  group('Basic', () {
    final userBean = UserBean(adapter);

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
      final insert1 = User(name: 'teja', age: 29);
      final insert2 = User(name: 'kleak', age: 24);
      final insert3 = User(name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2);
      await userBean.insert(insert3);
      users = await userBean.getAll();
      expect(users, [insert1, insert2, insert3]);
    });

    test('Find', () async {
      final insert1 = User(name: 'teja', age: 29);
      final insert2 = User(name: 'kleak', age: 24);
      final insert3 = User(name: 'lejard', age: 25);
      await userBean.insert(insert1);
      int id = await userBean.insert(insert2);
      await userBean.insert(insert3);
      User user = await userBean.find(id);
      expect(user, insert2);
    });

    test('Update', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = User(name: 'teja', age: 29);
      final insert2 = User(name: 'kleak', age: 24);
      final insert3 = User(name: 'lejard', age: 25);
      await userBean.insert(insert1);
      int id = await userBean.insert(insert2);
      await userBean.insert(insert3);
      insert2.id = id;
      insert2.age = 26;
      expect(await userBean.update(insert2), 1);
      users = await userBean.getAll();
      expect(users, [insert1, insert3, insert2]);
    });

    test('RemoveOne', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = User(name: 'teja', age: 29);
      final insert2 = User(name: 'kleak', age: 24);
      final insert3 = User(name: 'lejard', age: 25);
      await userBean.insert(insert1);
      int id = await userBean.insert(insert2);
      await userBean.insert(insert3);
      expect(await userBean.remove(id), 1);
      users = await userBean.getAll();
      expect(users, [insert1, insert3]);
    });

    test('RemoveMany', () async {
      List<User> users = await userBean.getAll();
      expect(users, []);
      final insert1 = User(name: 'teja', age: 29);
      final insert2 = User(name: 'kleak', age: 24);
      final insert3 = User(name: 'lejard', age: 25);
      await userBean.insert(insert1);
      await userBean.insert(insert2).then((id) => insert2.id = id);
      await userBean.insert(insert3).then((id) => insert3.id = id);
      expect(await userBean.removeMany([insert1, insert2]), 2);
      users = await userBean.getAll();
      expect(users, [insert3]);
    });
  });
}
