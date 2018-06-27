// Copyright (c) 2016, Ravi Teja Gudapati. All rights reserved. Use of this source code
// is governed by a BSD-style license that can be found in the LICENSE file.

/// NOTE: This is experimentation. jaguar_query doesn't support foreign keys yet

library example.has_one;

/* TODO
import 'dart:async';
import 'package:jaguar_query/jaguar_query.dart';
import 'package:jaguar_orm/jaguar_orm.dart';
import 'package:jaguar_orm/src/relations/relations.dart';

part 'associations.g.dart';

class Games {
	@PrimaryKey()
	String id;

	@ForeignKey('player', association: 'player')
	String playerId;

	@ForeignKey('player', refCol: '_id2', association: 'player')
	String playerId2;

	static const String tableName = 'games';
}

class Score {
	@PrimaryKey()
	String id;

	@BelongsTo(PlayerBean, association: 'player')
	String playerId;

	@BelongsTo(PlayerBean, refCol: '_id2', association: 'player')
	String playerId2;

	int score;

	static const String tableName = 'score';
}

class Player {
	@PrimaryKey()
	String id;

	@PrimaryKey(col: '_id2')
	String id2;

	String name;

	@HasOne(AddressBean, association: 'player')
	Address address;

	@HasMany(ScoreBean, association: 'player')
	List<Score> scores;

	static const String tableName = 'player';

	String toString() => "Author($id, $name, $address)";
}

class Address {
	@PrimaryKey()
	String id;

	@BelongsTo(PlayerBean, association: 'player')
	String playerId;

	@BelongsTo(PlayerBean, refCol: '_id2', association: 'player')
	String playerId2;

	String street;

	@HasOne(AreaBean, association: 'address')
	Area area;

	static String tableName = 'address';

	String toString() => "Post($id, $playerId, $street)";
}

class Area {
	@PrimaryKey()
	String id;

	String city;

	String country;

	@BelongsTo(AddressBean, association: 'address')
	String addressId;

	static String tableName = 'area';
}

@GenBean()
class PlayerBean extends Bean<Player> with _PlayerBean {
	PlayerBean(Adapter adapter)
			: addressBean = new AddressBean(adapter),
				scoreBean = new ScoreBean(adapter),
				super(adapter);

	final AddressBean addressBean;

	final ScoreBean scoreBean;
}

@GenBean()
class AddressBean extends Bean<Address> with _AddressBean {
	AddressBean(Adapter adapter)
			: areaBean = new AreaBean(adapter),
				super(adapter);

	final AreaBean areaBean;
}

@GenBean()
class AreaBean extends Bean<Area> with _AreaBean {
	AreaBean(Adapter adapter) : super(adapter);
}

@GenBean()
class ScoreBean extends Bean<Score> with _ScoreBean {
	ScoreBean(Adapter adapter) : super(adapter);
}

@GenBean()
class GamesBean extends Bean<Games> with _GamesBean {
	GamesBean(Adapter adapter) : super(adapter);
}

main() {}
*/
