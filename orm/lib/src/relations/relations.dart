import 'dart:async';
import 'dart:collection';
import 'package:quiver_hashcode/hashcode.dart';

class HashableValues {
  final UnmodifiableListView items;

  HashableValues(Iterable items) : items = new UnmodifiableListView(items);

  @override
  bool operator ==(other) {
    if (other is HashableValues) {
      if (other.items.length != items.length) return false;

      for (int i = 0; i < items.length; i++) {
        if (items[i] != other.items[i]) return false;
      }

      return true;
    }

    return false;
  }

  @override
  int get hashCode => hashObjects(items);
}

typedef AssociationGetter<Parent> = List Function(Parent p);

typedef AssociationSetter<Parent, Child> = void Function(Parent p, Child c);

typedef FindBelongsToByForeignList<Parent, Child> = Future<List<Child>>
    Function(List<Parent> models, {bool preload, bool cascade});

class PreloadHelper {
  static Future preload<Parent, Child>(
      List<Parent> parents,
      AssociationGetter<Parent> parentGetter,
      FindBelongsToByForeignList<Parent, Child> func,
      AssociationGetter<Child> childGetter,
      AssociationSetter<Parent, Child> setter,
      {bool cascade: false}) async {
    if (parents.length == 0) return;

    final Map<HashableValues, Parent> map = {};
    List<List> args;
    for (Parent parent in parents) {
      final List key = parentGetter(parent);
      if (args == null) {
        args = new List.filled(key.length, [], growable: false);
      }
      map[new HashableValues(key)] = parent;
      for (int i = 0; i < key.length; i++) {
        args[i].add(key[i]);
      }
    }

    final List<Child> children =
        await func(parents, preload: cascade, cascade: cascade);

    for (Child child in children) {
      final key = new HashableValues(childGetter(child));
      final Parent parent = map[key];
      if (parent == null) continue;
      setter(parent, child);
    }
  }
}
