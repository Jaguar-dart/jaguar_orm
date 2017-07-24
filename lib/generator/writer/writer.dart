library jaguar_orm.generator.writer;

import 'package:jaguar_orm/generator/model/model.dart';

class Writer {
  final StringBuffer _w = new StringBuffer();

  final Bean _b;

  Writer(this._b) {
    _generate();
  }

  String toString() => _w.toString();

  void _generate() {
    _w.writeln('abstract class _${_b.name} extends Bean<${_b.modelType}> {');
    _w.writeln();

    _writeConstructor();

    _writeTableName();

    _b.fields.forEach(_writeFields);

    _writeFromMap();

    _writeToSetColumns();

    _writeCurd();

    _b.finds.forEach(_writeFindMethod);

    _b.updates.forEach(_writeUpdateMethod);

    _b.deletes.forEach(_writeDeleteMethod);

    _w.writeln('}');
  }

  void _writeConstructor() {
    _w.writeln('_${_b.name}(Adapter adapter) : super(adapter);');
    _w.writeln();
  }

  void _writeTableName() {
    _w.writeln('String get tableName => ${_b.modelType}.tableName;');
    _w.writeln();
  }

  void _writeFields(Field field) {
    _w.writeln(
        "${field.vType} get ${field.field} => new ${field.vType}('${field.key}');");
    _w.writeln();
  }

  void _writeFromMap() {
    _w.writeln('${_b.modelType} fromMap(Map map) {');
    _w.writeln('${_b.modelType} model = new ${_b.modelType}();');
    _w.writeln();

    _b.fields.forEach((Field field) {
      _w.writeln("model.${field.field} = map['${field.key}'];");
    });

    _w.writeln();
    _w.writeln('return model;');
    _w.writeln('}');
  }

  void _writeToSetColumns() {
    _w.writeln('List<SetColumn> toSetColumns(${_b.modelType} model) {');
    _w.writeln('List<SetColumn> ret = [];');
    _w.writeln();

    _b.fields.forEach((Field field) {
      _w.writeln("ret.add(${field.field}.set(model.${field.field}));");
    });

    _w.writeln();
    _w.writeln('return ret;');
    _w.writeln('}');
  }

  void _writeCurd() {
    _writeCreate();
    _writeUpdate();
    _writeFind();
    _writeDelete();
  }

  void _writeCreate() {
    _w.writeln('Future<dynamic> create(${_b.modelType} model) async {');
    _w.write('final Insert insert = inserter');
    _w.writeln('.setMany(toSetColumns(model));');
    _w.writeln('return execInsert(insert);');
    _w.writeln('}');
  }

  void _writeUpdate() {
    if (_b.primary == null) {
      return;
    }

    _w.writeln('Future<int> update(${_b.modelType} model) async {');
    _w.write('final Update update = updater.where(${_b.primary.field}');
    _w.writeln('.eq(model.${_b.primary.field})).setMany(toSetColumns(model));');
    _w.writeln('return execUpdate(update);');
    _w.writeln('}');
  }

  void _writeFind() {
    if (_b.primary == null) {
      return;
    }

    _w.writeln(
        'Future<${_b.modelType}> find(${_b.primary.type} ${_b.primary.field}) async {');
    _w.writeln(
        'final Find find = finder.where(this.${_b.primary.field}.eq(${_b.primary.field}));');
    _w.writeln('return await execFindOne(find);');
    _w.writeln('}');
  }

  void _writeDelete() {
    if (_b.primary == null) {
      return;
    }

    _w.writeln(
        'Future<int> delete(${_b.primary.type} ${_b.primary.field}) async {');
    _w.writeln(
        'final Delete delete = deleter.where(this.${_b.primary.field}.eq(${_b.primary.field}));');
    _w.writeln('return execDelete(delete);');
    _w.writeln('}');
  }

  void _writeFindMethod(Find find) {
    _w.write(find.prototype);
    _w.writeln(' async {');

    _w.writeln('final Find find = finder');

    find.wheres.forEach((Where where) {
      _w.write('.where(this.${where.field}.${where.op}(${where.field}))');
    });
    _w.writeln(';');

    _w.writeln('return execFind(find);');
    _w.writeln('}');
    _w.writeln();
  }

  void _writeUpdateMethod(Update update) {
    _w.write(update.prototype);
    _w.writeln(' async {');

    _w.writeln('Update update = updater');

    update.wheres.forEach((Where where) {
      _w.write('.where(this.${where.field}.${where.op}(${where.field}))');
    });

    update.sets.forEach((SetColumn set) {
      _w.write('.set(this.${set.field}.set(${set.field}))');
    });
    _w.writeln(';');

    _w.writeln('return execUpdate(update);');
    _w.writeln('}');
    _w.writeln();
  }

  void _writeDeleteMethod(Delete delete) {
    _w.write(delete.prototype);
    _w.writeln(' async {');

    _w.writeln('final Delete delete = deleter');

    delete.wheres.forEach((Where where) {
      _w.write('.where(this.${where.field}.${where.op}(${where.field}))');
    });
    _w.writeln(';');

    _w.writeln('return execDelete(delete);');
    _w.writeln('}');
    _w.writeln();
  }
}
