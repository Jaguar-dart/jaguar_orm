library jaguar_orm.generator.model;

import 'package:source_gen_help/source_gen_help.dart';

import 'package:jaguar_orm/generator/parser/parser.dart';

import 'package:jaguar_orm/src/annotations/annotations.dart' as ant;

class Field {
  final String field;

  final String type;

  final String vType;

  final String key;

  Field(this.type, this.vType, this.field, this.key);

  static Field fromParsed(ParsedColumn col) => new Field(
      col.fieldType.name, _getValType(col.fieldType), col.name, col.key);
}

class Bean {
  final String name;

  final String modelType;

  final List<Field> fields;

  final Field primary;

  final List<Find> finds;

  final List<Update> updates;

  final List<Delete> deletes;

  Bean(this.name, this.modelType, this.fields, this.primary, this.finds,
      this.updates, this.deletes);
}

class Where {
  final String field;

  final String op;

  Where(this.field, this.op);
}

class SetColumn {
  final String field;

  SetColumn(this.field);
}

class Find {
  final String prototype;

  final List<Where> wheres;

  Find(this.prototype, this.wheres);

  static Find fromParsed(ParsedFind f) {
    final List<Where> wheres = f.wheres
        .map((ParsedWhere where) =>
            new Where(where.name, _getWhereOp(where.instantiated)))
        .toList();
    return new Find(f.methodHeader, wheres);
  }
}

class Update {
  final String prototype;

  final List<Where> wheres;

  final List<SetColumn> sets;

  Update(this.prototype, this.wheres, this.sets);

  static Update fromParsed(ParsedUpdate f) {
    final List<Where> wheres = f.wheres
        .map((ParsedWhere where) =>
            new Where(where.name, _getWhereOp(where.instantiated)))
        .toList();
    final List<SetColumn> sets =
        f.sets.map((ParsedSetColumn set) => new SetColumn(set.name)).toList();
    return new Update(f.methodHeader, wheres, sets);
  }
}

class Delete {
  final String prototype;

  final List<Where> wheres;

  Delete(this.prototype, this.wheres);

  static Delete fromParsed(ParsedDelete f) {
    final List<Where> wheres = f.wheres
        .map((ParsedWhere where) =>
            new Where(where.name, _getWhereOp(where.instantiated)))
        .toList();
    return new Delete(f.methodHeader, wheres);
  }
}

class ToModel {
  final ParsedBean _parsed;

  Bean _model;

  ToModel(this._parsed) {
    final List<Field> fields = [];
    final List<Find> finds = [];
    final List<Update> updates = [];
    final List<Delete> deletes = [];

    _parsed.columns.map(Field.fromParsed).forEach(fields.add);

    _parsed.finds.map(Find.fromParsed).forEach(finds.add);

    _parsed.updates.map(Update.fromParsed).forEach(updates.add);

    _parsed.deletes.map(Delete.fromParsed).forEach(deletes.add);

    _model = new Bean(_parsed.name, _parsed.model.name, fields,
        Field.fromParsed(_parsed.primary), finds, updates, deletes);
  }

  Bean get model => _model;
}

String _getValType(DartTypeWrap type) {
  if (type.isString) {
    return 'StrField';
  } else if (type.isBool) {
    return 'BitField';
  } else if (type.isInt) {
    return 'IntField';
  } else if (type.isNum || type.isDouble) {
    return 'NumField';
  } else if (type.isDateTime) {
    return 'DateTimeField';
  }

  throw new Exception('Field type not recognised!');
}

String _getWhereOp(ant.Where wh) {
  if (wh is ant.WhereEq) {
    return 'eq';
  } else if (wh is ant.WhereNe) {
    return 'ne';
  } else if (wh is ant.WhereGt) {
    return 'gt';
  } else if (wh is ant.WhereLt) {
    return 'lt';
  } else if (wh is ant.WhereGtEq) {
    return 'gtEq';
  } else if (wh is ant.WhereLtEq) {
    return 'ltEq';
  } else if (wh is ant.WhereLike) {
    return 'like';
  }

  throw new Exception('Unknown where clause!');
}
