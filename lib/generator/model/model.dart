library jaguar_orm.generator.model;

import 'package:source_gen_help/source_gen_help.dart';

import 'package:jaguar_orm/generator/parser/parser.dart';

class Field {
  final String field;

  final String type;

  final String key;

  Field(this.type, this.field, this.key);
}

class Bean {
  final String name;

  final String modelType;

  final List<Field> fields;

  Bean(this.name, this.modelType, List<Field> fields) : fields = fields ?? [];
}

class ToModel {
  final ParsedBean _parsed;

  Bean _model;

  ToModel(this._parsed) {
    List<Field> fields = [];

    _parsed.columns
        .map((ParsedColumn col) =>
            new Field(_getValType(col.fieldType), col.name, col.key))
        .forEach(fields.add);

    _model = new Bean(_parsed.name, _parsed.model.name, fields);
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
