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
    _w.writeln(
        'abstract class _\$' + _b.name + ' extends Bean<${_b.modelType}> {');
    _w.writeln();

    _writeConstructor();

    _writeTableName();

    _b.fields.forEach(_writeFields);

    _writeFromMap();

    _writeToSetColumns();

    _w.writeln('}');
  }

  void _writeConstructor() {
    _w.writeln('_\$${_b.name}(Adapter adapter) : super(adapter);');
    _w.writeln();
  }

  void _writeTableName() {
    _w.writeln('String get tableName => ${_b.modelType}.tableName;');
    _w.writeln();
  }

  void _writeFields(Field field) {
    _w.writeln(
        "${field.type} get ${field.field} => new ${field.type}('${field.key}');");
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
    _w.write('List<SetColumn> toSetColumns(${_b.modelType} model) {');
    _w.write('List<SetColumn> ret = [];');
    _w.writeln();

    _b.fields.forEach((Field field) {
      _w.writeln("ret.add(${field.field}.set(model.${field.field}));");
    });

    _w.writeln();
    _w.write('return ret;');
    _w.write('}');
  }
}
