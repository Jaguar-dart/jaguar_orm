// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet

import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';

class Player {
  @PrimaryKey()
  String id;

  @PrimaryKey()
  String id2;

  String name;

  @HasOneBean(AddressBean)
  Address address;

  static const String tableName = 'player';

  String toString() => "Author($id, $name, $address)";
}

class Address {
  @PrimaryKey()
  String id;

  @ForeignKeyBean(PlayerBean)
  String playerId;

  @ForeignKeyBean(PlayerBean, foreign: 'id2')
  String playerId2;

  String message;

  static String tableName = 'address';

  String toString() => "Post($id, $playerId, $message)";
}

class PlayerBean extends Bean<Player> with _PlayerBean {
  StrField id;

  StrField name;

  AddressBean address;

  PlayerBean(Adapter adapter) : super(adapter);

  Future<Player> findById(String id, {bool preload: false}) async {
    final Find find = finder.where(this.id - id);
    final Player player = await execFindOne(find);

    if (preload) {
      await this.preload(player);
    }

    return player;
  }

  Future preload(Player player) async {
    player.address = await address.findByPlayer(player.id, player.id2);
  }
}

class AddressBean extends Bean<Address> with _AddressBean {
  StrField id;

  StrField playerId;

  StrField playerId2;

  StrField message;

  AddressBean(Adapter adapter) : super(adapter);

  Future<Address> findByPlayer(String id, String id2) async {
    final Find find =
        finder.where(this.playerId.eq(id))
            .where(this.playerId2.eq(id2));
    return await execFindOne(find);
  }
}

main() {}
