import 'dart:async';
import 'dart:collection';
import 'package:quiver/core.dart';

class HashableValues {
  final UnmodifiableListView items;

  HashableValues(Iterable items) : items = UnmodifiableListView(items);

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

/// Returns the list of association keys given the [model].
typedef List<dynamic> AssociationKeysGetter<Model>(Model model);

typedef Future<List<Child>> OneToXChildrenGetterForAll<Parent, Child>(
    List<Parent> models,
    {bool preload,
    bool cascade});

typedef void AssociationSetter<Parent, Child>(Parent p, Child c);

/// Helper functions for one-to-many relationship
class OneToXHelper {
  /// Preload all of [parents] given a one-to-one or one-to-many relationship
  /// between [Parent] and [Child].
  ///
  /// [parentAssociationGetter] is a function that returns list of association
  /// keys between [Parent] and [Child] given an instance of [Parent].
  ///
  /// [childAssociationGetter] is a function that returns list of association
  /// keys between [Child] and [Parent] given an instance of [Child].
  ///
  /// [childFetcher] fetches all the children for the given list of parents.
  static Future<void> preloadAll<Parent, Child>(
      List<Parent> parents,
      AssociationKeysGetter<Parent> parentAssociationGetter,
      OneToXChildrenGetterForAll<Parent, Child> childFetcher,
      AssociationKeysGetter<Child> childAssociationGetter,
      AssociationSetter<Parent, Child> setter,
      {bool cascade = false}) async {
    if (parents.length == 0) return;

    final Map<HashableValues, Parent> map = {};
    List<List>? args;
    for (Parent parent in parents) {
      final List key = parentAssociationGetter(parent);
      if (args == null) {
        args = new List.filled(key.length, [], growable: false);
      }
      map[new HashableValues(key)] = parent;
      for (int i = 0; i < key.length; i++) {
        args[i].add(key[i]);
      }
    }

    final List<Child> children =
        await childFetcher(parents, preload: cascade, cascade: cascade);

    for (Child child in children) {
      final key = new HashableValues(childAssociationGetter(child));
      final Parent? parent = map[key];
      if (parent == null) continue;
      setter(parent, child);
    }
  }
}
