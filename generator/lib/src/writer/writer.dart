library jaguar_orm.generator.writer;

import 'package:jaguar_orm_gen/src/model/model.dart';

class Writer {
  final _w = StringBuffer();

  final ParsedBean _b;

  Writer(this._b) {
    _generate();
  }

  void _generate() {
    _w.writeln('abstract class _${_b.name} implements Bean<${_b.modelType}> {');

    for (ParsedField field in _b.fields.values) {
      _writeln(
          "final ${field.field} = ${field.vType}('${_camToSnak(field.colName)}');");
    }

    _writeFieldsMap();

    _writeFromMap();

    _writeToSetColumns();

    _writeCreate();

    _writeCrud();

    // TODO get by foreign for non-beaned

    // TODO remove by foreign for non-beaned

    for (AssociationByRelation ass in _b.associationsWithRelations.values) {
      _writeFindOneByBeanedAssociation(ass);
      _writeFindListByBeanedAssociationList(ass);
      _removeByForeign(ass);

      _writeAssociate(ass);

      if (ass.isManyToMany) {
        _writeManyToManyDetach(ass);
        _writeManyToManyFetchOther(ass);
      } else {
        if (!ass.toMany) {
          _writeOneToOneFetch(ass);
        } else {
          _writeOneToManyFetch(ass);
        }
      }
    }

    for (AssociationWithoutRelation ass
        in _b.associationsWithoutRelations.values) {
      _writeFindOneByBeanedAssociation(ass);
      _writeFindListByBeanedAssociationList(ass);
      // TODO remove
    }

    _writeAttach();

    _writePreload();

    _writePreloadAll();

    _writeBeans();

    _w.writeln('}');
  }

  void _writeFieldsMap() {
    _w.writeln('Map<String, Field> _fields;');

    _w.writeln('Map<String, Field> get fields => _fields ??= {');
    for (ParsedField f in _b.fields.values) {
      _w.writeln('${f.field}.name: ${f.field},');
    }
    _w.writeln('};');
  }

  void _writeFromMap() {
    _w.writeln('${_b.modelType} fromMap(Map map) {');
    _w.write('${_b.modelType} model = ${_b.modelType}(');
    _b.fields.values.forEach((ParsedField field) {
      if (field.isFinal) {
        _w.write(
            '${field.field}: adapter.parseValue(map[\'${_camToSnak(field.colName)}\']),');
      }
    });
    _w.writeln(');');

    _b.fields.values.forEach((ParsedField field) {
      if (!field.isFinal) {
        _w.writeln(
            "model.${field.field} = adapter.parseValue(map['${_camToSnak(field.colName)}']);");
      }
    });

    _w.writeln();
    _w.writeln('return model;');
    _w.writeln('}');
  }

  void _writeCreate() {
    _w.writeln(
        'Future<void> createTable({bool ifNotExists = false, Connection withConn}) async {');
    _writeln('final st = Sql.create(tableName, ifNotExists: ifNotExists);');
    for (final ParsedField f in _b.fields.values) {
      _write('st.addByType(${f.field}.name, ${f.dataTypeDecl},');
      if (f.column.isPrimary) _write('isPrimary: true,');
      if (f.column.notNull) _write('notNull: ${f.column.notNull},');
      if (f.foreign != null) {
        final foreign = f.foreign;
        if (foreign is BelongsToSpec) {
          _write(
              'foreign: References(${foreign.beanInstanceName}.tableName, "${foreign.references}"');
          if (foreign.link != null) {
            _write(', name: "${foreign.link}"');
          }
          _write('),');
        } else if (foreign is ReferencesSpec) {
          _write(
              'foreign: References("${foreign.table}", "${foreign.references}"');
          if (foreign.link != null) {
            _write(', name: "${foreign.link}"');
          }
          _write('),');
        } else {
          throw Exception('Unimplemented!');
        }
      }
      if (f.constraints.isNotEmpty)
        _write('constraints: [${f.constraints.join(',')}],');
      _writeln(');');
    }
    _writeln('return adapter.createTable(st, withConn: withConn);');
    _w.writeln('}');
  }

  void _writeToSetColumns() {
    _w.writeln(
        'List<SetColumn> toSetColumns(${_b.modelType} model, {bool update = false, Set<String> only, bool onlyNonNull = false}) {');
    _w.writeln('List<SetColumn> ret = [];');
    _w.writeln();

    _w.writeln('if(only == null && !onlyNonNull) {');

    _b.fields.values.forEach((ParsedField field) {
      if (field.isAuto) {
        _w.writeln("if(!update && model.${field.field} != null) {");
      }
      _w.writeln("ret.add(${field.field}.set(model.${field.field}));");
      if (field.isAuto) {
        _w.writeln("}");
      }
    });

    _w.writeln('} else if (only != null) {');

    _b.fields.values.forEach((ParsedField field) {
      if (field.isAuto) {
        _w.writeln("if(model.${field.field} != null) {");
      }
      _w.writeln(
          "if(only.contains(${field.field}.name)) ret.add(${field.field}.set(model.${field.field}));");
      if (field.isAuto) {
        _w.writeln("}");
      }
    });

    _w.writeln('} else /* if (onlyNonNull) */ {');

    _b.fields.values.forEach((ParsedField field) {
      _w.writeln("if(model.${field.field} != null) {");
      _w.writeln("ret.add(${field.field}.set(model.${field.field}));");
      _w.writeln("}");
    });

    _w.writeln('}');

    _w.writeln();
    _w.writeln('return ret;');
    _w.writeln('}');
  }

  void _writeCrud() {
    _writeInsert();
    _writeInsertMany();
    _writeUpsert();
    _writeUpsertMany();
    _writeUpdate();
    _writeUpdateMany();
    _writeFind();
    _writeRemove();
    _writeRemoveMany();
  }

  void _writeInsert() {
    if (_b.preloads.isEmpty && !_b.primary.any((f) => f.isAuto)) {
      _w.writeln(
          'Future<dynamic> insert(${_b.modelType} model, {bool cascade = false, bool onlyNonNull = false, Set<String> only, Connection withConn}) async {');
      _w.write('final Insert insert = inserter');
      _w.writeln(
          '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));');
      _w.writeln('return adapter.insert(insert, withConn: withConn);');
      _w.writeln('}');
      return;
    }

    _w.writeln(
        'Future<dynamic> insert(${_b.modelType} model, {bool cascade = false, bool onlyNonNull = false, Set<String> only, Connection withConn}) async {');
    _w.write('final Insert insert = inserter');
    _w.write(
        '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))');
    for (ParsedField f in _b.primary) {
      if (f.isAuto) _w.write('.id(${f.field}.name)');
    }
    _w.writeln(';');
    _w.writeln('var retId = await adapter.insert(insert, withConn: withConn);');

    _w.writeln('if(cascade) {');
    _w.writeln('${_b.modelType} newModel;');
    for (Preload p in _b.preloads) {
      _w.writeln('if(model.${p.property} != null) {');
      _w.writeln('newModel ??= await find(');
      _write(_b.primary.map((f) {
        if (f.isAuto) return 'retId';
        return 'model.${f.field}';
      }).join(','));
      _writeln(', withConn: withConn);');

      if (!p.hasMany) {
        _write(_uncap(p.beanInstanceName));
        _write('.associate${_b.modelType}');
        if (p.linkBy != null) _write('_for${p.linkBy}');
        _write('(model.' + p.property + ', newModel);');
        _write('await ' +
            _uncap(p.beanInstanceName) +
            '.insert(model.' +
            p.property +
            ', cascade: cascade, withConn: withConn);');
      } else {
        if (p is PreloadOneToX) {
          _write('model.' + p.property + '.forEach((x) => ');
          _write(_uncap(p.beanInstanceName));
          _write('.associate${_b.modelType}');
          if (p.linkBy != null) _write('_for${p.linkBy}');
          _write('(x, newModel));');
          _writeln('for(final child in model.${p.property}) {');
          _writeln('await ' +
              _uncap(p.beanInstanceName) +
              '.insert(child, cascade: cascade);');
          _writeln('}');
        } else if (p is PreloadManyToMany) {
          _writeln('for(final child in model.${p.property}) {');
          _writeln(
              'await ${p.targetBeanInstanceName}.insert(child, cascade: cascade, withConn: withConn);');
          if (_b.modelType.compareTo(p.targetInfo.modelType) > 0) {
            _write('await ${p.beanInstanceName}.attach');
            if (p.linkBy != null) _write('_for${p.linkBy}');
            _writeln('(newModel, child);');
          } else {
            _write('await ${p.beanInstanceName}.attach');
            if (p.linkBy != null) _write('_for${p.linkBy}');
            _writeln('(child, newModel, withConn: withConn);');
          }
          _writeln('}');
        }
      }
      _w.writeln('}');
    }
    _w.writeln('}');
    _w.writeln('return retId;');
    _w.writeln('}');
  }

  void _writeInsertMany() {
    var cascade = '';
    if (_b.preloads.length > 0) {
      cascade = 'bool cascade = false,';
    }
    _w.writeln(
        'Future<void> insertMany(List<${_b.modelType}> models, {${cascade}bool onlyNonNull = false, Set<String> only, Connection withConn}) async {');
    if (cascade.isNotEmpty) {
      _w.write('if(cascade)  {');
      _w.write('final List<Future> futures = [];');
      _w.write('for (var model in models) {');
      _w.write(
          'futures.add(insert(model, cascade: cascade, withConn: withConn));');
      _w.write('}');
      _w.writeln('await Future.wait(futures);');
      _w.writeln('return;');
      _w.write('}');
      _w.write('else {');
    }

    _w.write(
        'final List<List<SetColumn>> data = models.map((model) => toSetColumns(model, only: only, onlyNonNull: onlyNonNull)).toList();');
    _w.writeln('final InsertMany insert = insertser.addAll(data);');
    _w.writeln('await adapter.insertMany(insert, withConn: withConn);');
    _w.writeln('return;');

    if (cascade.isNotEmpty) {
      _w.writeln('}');
    }

    _w.writeln('}');
  }

  void _writeUpsert() {
    if (_b.preloads.isEmpty && !_b.primary.any((f) => f.isAuto)) {
      _w.writeln(
          'Future<dynamic> upsert(${_b.modelType} model, {bool cascade = false, Set<String> only, bool onlyNonNull = false, Connection withConn}) async {');
      _w.write('final Upsert upsert = upserter');
      _w.writeln(
          '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull));');
      _w.writeln('return adapter.upsert(upsert, withConn: withConn);');
      _w.writeln('}');
      return;
    }

    _w.writeln(
        'Future<dynamic> upsert(${_b.modelType} model, {bool cascade = false, Set<String> only, bool onlyNonNull = false, Connection withConn}) async {');
    _w.write('final Upsert upsert = upserter');
    _w.write(
        '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull))');
    for (ParsedField f in _b.primary) {
      if (f.isAuto) _w.write('.id(${f.field}.name)');
    }
    _w.writeln(';');
    _w.writeln('var retId = await adapter.upsert(upsert, withConn: withConn);');

    _w.writeln('if(cascade) {');
    _w.writeln('${_b.modelType} newModel;');
    for (Preload p in _b.preloads) {
      _w.writeln('if(model.${p.property} != null) {');
      _w.writeln('newModel ??= await find(');
      _write(_b.primary.map((f) {
        if (f.isAuto) return 'retId';
        return 'model.${f.field}';
      }).join(','));
      _writeln(', withConn: withConn);');

      if (!p.hasMany) {
        _write(_uncap(p.beanInstanceName));
        _write('.associate${_b.modelType}');
        if (p.linkBy != null) _write('_for${p.linkBy}');
        _write('(model.' + p.property + ', newModel);');
        _write('await ' +
            _uncap(p.beanInstanceName) +
            '.upsert(model.' +
            p.property +
            ', cascade: cascade, withConn: withConn);');
      } else {
        if (p is PreloadOneToX) {
          _write('model.' + p.property + '.forEach((x) => ');
          _write(_uncap(p.beanInstanceName));
          _write('.associate${_b.modelType}');
          if (p.linkBy != null) _write('_for${p.linkBy}');
          _writeln('(x, newModel));');
          _writeln('for(final child in model.${p.property}) {');
          _writeln('await ' +
              _uncap(p.beanInstanceName) +
              '.upsert(child, cascade: cascade, withConn: withConn);');
          _writeln('}');
        } else if (p is PreloadManyToMany) {
          _writeln('for(final child in model.${p.property}) {');
          _writeln(
              'await ${p.targetBeanInstanceName}.upsert(child, cascade: cascade, withConn: withConn);');
          if (_b.modelType.compareTo(p.targetInfo.modelType) > 0) {
            _write('await ${p.beanInstanceName}.attach');
            if (p.linkBy != null) _write('_for${p.linkBy}');
            _writeln('(newModel, child, upsert: true, withConn: withConn);');
          } else {
            _write('await ${p.beanInstanceName}.attach');
            if (p.linkBy != null) _write('_for${p.linkBy}');
            _writeln('(child, newModel, upsert: true, withConn: withConn);');
          }
          _writeln('}');
        }
      }
      _w.writeln('}');
    }
    _w.writeln('}');
    _w.writeln('return retId;');
    _w.writeln('}');
  }

  void _writeUpsertMany() {
    var cascade = '';
    if (_b.preloads.length > 0) {
      cascade = 'bool cascade = false, ';
    }
    _w.writeln(
        'Future<void> upsertMany(List<${_b.modelType}> models, {${cascade} bool onlyNonNull = false, Set<String> only, Connection withConn}) async {');
    if (cascade.isNotEmpty) {
      _w.write('if(cascade)  {');
      _w.write('final List<Future> futures = [];');
      _w.write('for (var model in models) {');
      _w.write(
          'futures.add(upsert(model, cascade: cascade, withConn: withConn));');
      _w.write('}');
      _w.writeln('await Future.wait(futures);');
      _w.writeln('return;');
      _w.write('}');
      _w.write('else {');
    }

    _w.write('final List<List<SetColumn>> data = [];');
    _w.write('for (var i = 0; i < models.length; ++i) {');
    _w.write('var model = models[i];');
    _w.write(
        'data.add(toSetColumns(model, only: only, onlyNonNull: onlyNonNull).toList());');

    _w.write('}');
    _w.write('final UpsertMany upsert = upsertser.addAll(data);');
    _w.writeln('await adapter.upsertMany(upsert, withConn: withConn);');
    _w.writeln('return;');

    if (cascade.isNotEmpty) {
      _w.writeln('}');
    }

    _w.writeln('}');
  }

  void _writeUpdate() {
    if (_b.primary.length == 0) return;

    if (_b.preloads.length == 0) {
      _w.writeln(
          'Future<int> update(${_b.modelType} model, {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false, Connection withConn}) async {');
      _w.write('final Update update = updater.');
      final String wheres = _b.primary
          .map((ParsedField f) => 'where(this.${f.field}.eq(model.${f.field}))')
          .join('.');
      _w.write(wheres);
      _w.writeln(
          '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull, update:true));');
      _w.writeln('return adapter.update(update, withConn: withConn);');
      _w.writeln('}');
      return;
    }

    _w.writeln(
        'Future<int> update(${_b.modelType} model, {bool cascade = false, bool associate = false, Set<String> only, bool onlyNonNull = false, Connection withConn}) async {');
    _w.write('final Update update = updater.');
    final String wheres = _b.primary
        .map((ParsedField f) => 'where(this.${f.field}.eq(model.${f.field}))')
        .join('.');
    _w.write(wheres);
    _w.writeln(
        '.setMany(toSetColumns(model, only: only, onlyNonNull: onlyNonNull, update:true));');
    _w.writeln('final ret = adapter.update(update, withConn: withConn);');

    _w.writeln('if(cascade) {');
    _w.writeln('${_b.modelType} newModel;');
    for (Preload p in _b.preloads) {
      _w.writeln('if(model.${p.property} != null) {');
      if (p is PreloadOneToX) {
        _writeln('if(associate) {');
        _w.writeln('newModel ??= await find(');
        _write(_b.primary.map((f) {
          return 'model.${f.field}';
        }).join(','));
        _writeln(', withConn: withConn);');

        if (!p.hasMany) {
          _write(_uncap(p.beanInstanceName));
          _write('.associate${_b.modelType}');
          if (p.linkBy != null) _write('_for${p.linkBy}');
          _writeln('(model.' + p.property + ', newModel);');
        } else {
          _write('model.' + p.property + '.forEach((x) => ');
          _write(_uncap(p.beanInstanceName));
          _write('.associate${_b.modelType}');
          if (p.linkBy != null) _write('_for${p.linkBy}');
          _writeln('(x, newModel));');
        }
        _writeln('}');
      }

      if (!p.hasMany) {
        _write('await ' +
            _uncap(p.beanInstanceName) +
            '.update(model.' +
            p.property +
            ', cascade: cascade, associate: associate, withConn: withConn);');
      } else {
        _writeln('for(final child in model.${p.property}) {');
        if (p is PreloadOneToX) {
          _writeln('await ' +
              _uncap(p.beanInstanceName) +
              '.update(child, cascade: cascade, associate: associate, withConn: withConn);');
        } else if (p is PreloadManyToMany) {
          _writeln(
              'await ${p.targetBeanInstanceName}.update(child, cascade: cascade, associate: associate, withConn: withConn);');
        }
        _writeln('}');
      }
      _w.writeln('}');
    }
    _w.writeln('}');

    _w.writeln('return ret;');
    _w.writeln('}');
  }

  void _writeUpdateMany() {
    var cascade = '';
    if (_b.preloads.length > 0) {
      cascade = 'bool cascade = false, ';
    }
    _w.writeln(
        'Future<void> updateMany(List<${_b.modelType}> models, {${cascade} bool onlyNonNull = false, Set<String> only, Connection withConn}) async {');
    if (cascade.isNotEmpty) {
      _w.write('if(cascade)  {');
      _w.write('final List<Future> futures = [];');
      _w.write('for (var model in models) {');
      _w.write(
          'futures.add(update(model, cascade: cascade, withConn: withConn));');
      _w.write('}');
      _w.writeln('await Future.wait(futures);');
      _w.writeln('return;');
      _w.write('}');
      _w.write('else {');
    }

    _w.write('final List<List<SetColumn>> data = [];');
    _w.write('final List<Expression> where = [];');
    _w.write('for (var i = 0; i < models.length; ++i) {');
    _w.write('var model = models[i];');
    _w.write(
        'data.add(toSetColumns(model, only: only, onlyNonNull: onlyNonNull, update:true).toList());');

    String wheres;
    for (var prim in _b.primary) {
      if (wheres == null) {
        wheres = 'this.${prim.field}.eq(model.${prim.field})';
      } else {
        wheres = '$wheres.and(this.${prim.field}.eq(model.${prim.field}))';
      }
    }
    _w.write('where.add($wheres);');
    _w.write('}');
    _w.write('final UpdateMany update = updateser.addAll(data, where);');
    _w.writeln('await adapter.updateMany(update, withConn: withConn);');
    _w.writeln('return;');

    if (cascade.isNotEmpty) {
      _w.writeln('}');
    }

    _w.writeln('}');
  }

  void _writeFind() {
    if (_b.primary.length == 0) return;

    _write('Future<${_b.modelType}> find(');
    final String args =
        _b.primary.map((ParsedField f) => '${f.type} ${f.field}').join(',');
    _write(args);
    _write(
        ', {bool preload = false, bool cascade = false, Connection withConn}');
    _writeln(') async {');
    _writeln('final Find find = finder.');
    final String wheres = _b.primary
        .map((ParsedField f) => 'where(this.${f.field}.eq(${f.field}))')
        .join('.');
    _write(wheres);
    _writeln(';');

    if (_b.preloads.length > 0) {
      _writeln(
          'final ${_b.modelType} model = await findOne(find, withConn: withConn);');
      _writeln('if (preload && model != null) {');
      _writeln(
          'await this.preload(model, cascade: cascade, withConn: withConn);');
      _writeln('}');
      _writeln('return model;');
    } else {
      _writeln('return await findOne(find, withConn: withConn);');
    }
    _writeln('}');
  }

  void _writeRemove() {
    if (_b.primary.length == 0) return;

    if (_b.preloads.length == 0) {
      _w.writeln('Future<int> remove(');
      final String args =
          _b.primary.map((ParsedField f) => '${f.type} ${f.field}').join(',');
      _w.write(args);
      _write(', {Connection withConn}');
      _w.writeln(') async {');
      _w.writeln('final Remove remove = remover.');
      final String wheres = _b.primary
          .map((ParsedField f) => 'where(this.${f.field}.eq(${f.field}))')
          .join('.');
      _w.write(wheres);
      _w.writeln(';');
      _w.writeln('return adapter.remove(remove, withConn: withConn);');
      _w.writeln('}');
      return;
    }

    _w.writeln('Future<int> remove(');
    final String args =
        _b.primary.map((ParsedField f) => '${f.type} ${f.field}').join(',');
    _w.write(args);
    _w.writeln(', {bool cascade = false, Connection withConn}) async {');

    _writeln('if (cascade) {');
    _w.writeln('final ${_b.modelType} newModel = ');
    _w.writeln('await find(');
    _write(_b.primary.map((f) {
      return '${f.field}';
    }).join(','));
    _writeln(', withConn: withConn);');
    _w.writeln('if(newModel != null) {');
    for (Preload p in _b.preloads) {
      if (p is PreloadOneToX) {
        _write('await ' + p.beanInstanceName + '.removeBy' + _b.modelType);
        if (p.linkBy != null) _write('_for${p.linkBy}');
        _write('(');
        _write(p.fields.map((f) => 'newModel.' + f.field).join(', '));
        _writeln(', withConn: withConn);');
      } else if (p is PreloadManyToMany) {
        _write(
            'await ${p.beanInstanceName}.detach${_b.modelType}(newModel, withConn: withConn);');
      }
    }
    _w.writeln('}');
    _writeln('}');

    _w.writeln('final Remove remove = remover.');
    final String wheres = _b.primary
        .map((ParsedField f) => 'where(this.${f.field}.eq(${f.field}))')
        .join('.');
    _w.write(wheres);
    _w.writeln(';');
    _w.writeln('return adapter.remove(remove, withConn: withConn);');
    _w.writeln('}');
  }

  void _writeFindOneByBeanedAssociation(Association m) {
    if (!m.toMany) {
      _w.write('Future<${_b.modelType}>');
    } else {
      _w.write('Future<List<${_b.modelType}>>');
    }
    _w.write(' findBy${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.write('(');
    final String args =
        m.fields.map((ParsedField f) => '${f.type} ${f.field}').join(',');
    _w.write(args);
    _write(
        ', {bool preload = false, bool cascade = false, Connection withConn}');
    _w.writeln(') async {');

    _w.writeln('final Find find = finder.');
    final String wheres = m.fields
        .map((ParsedField f) => 'where(this.${f.field}.eq(${f.field}))')
        .join('.');
    _w.write(wheres);
    _w.writeln(';');

    if (_b.preloads.length > 0) {
      if (!m.toMany) {
        _write('final ${_b.modelType} model = await ');
        _writeln('findOne(find, withConn: withConn);');

        _writeln('if (preload && model != null) {');
        _writeln(
            'await this.preload(model, cascade: cascade, withConn: withConn);');
        _writeln('}');

        _writeln('return model;');
      } else {
        _write('final List<${_b.modelType}> models = ');
        _writeln('await findMany(find, withConn: withConn);');

        _writeln('if (preload) {');
        _writeln(
            'await this.preloadAll(models, cascade: cascade, withConn: withConn);');
        _writeln('}');

        _writeln('return models;');
      }
    } else {
      _write('return ');
      if (!m.toMany) {
        _writeln('findOne(find, withConn: withConn);');
      } else {
        _writeln('findMany(find, withConn: withConn);');
      }
    }

    _w.writeln('}');
  }

  void _writeRemoveMany() {
    if (_b.primary.length == 0) return;

    _w.writeln(
        'Future<int> removeMany(List<${_b.modelType}> models, {Connection withConn}) async {');
    // Return if models is empty. If this is not done, all records will be removed!
    _w.writeln(
        "// Return if models is empty. If this is not done, all records will be removed! ");
    _w.writeln("if(models == null || models.isEmpty) return 0;");
    _w.writeln('final Remove remove = remover;');
    _writeln('for(final model in models) {');
    _write('remove.or(');
    final String wheres = _b.primary
        .map((ParsedField f) => 'this.${f.field}.eq(model.${f.field})')
        .join('|');
    _w.write(wheres);
    _writeln(');');
    _w.writeln('}');
    _w.writeln('return adapter.remove(remove, withConn: withConn);');
    _w.writeln('}');
    return;
  }

  void _removeByForeign(AssociationByRelation m) {
    _w.write('Future<int>');
    _w.write(' removeBy${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.write('(');
    final String args =
        m.fields.map((ParsedField f) => '${f.type} ${f.field}').join(',');
    _w.write(args);
    _write(', {Connection withConn}');
    _w.writeln(') async {');

    _w.writeln('final Remove rm = remover.');
    final String wheres = m.fields
        .map((ParsedField f) => 'where(this.${f.field}.eq(${f.field}))')
        .join('.');
    _w.write(wheres);
    _w.writeln(';');

    _write('return await adapter.remove(rm, withConn: withConn);');
    _w.writeln('}');
  }

  void _writeFindListByBeanedAssociationList(Association m) {
    _write('Future<List<${_b.modelType}>> findBy${_cap(m.modelName)}List');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.write('(');
    _write('List<${m.modelName}> models');
    _write(
        ', {bool preload = false, bool cascade = false, Connection withConn}');
    _writeln(') async {');
    // Return if models is empty. If this is not done, all the records will be returned!
    _writeln(
        "// Return if models is empty. If this is not done, all the records will be returned!");
    _writeln("if(models == null || models.isEmpty) return [];");
    _writeln('final Find find = finder;');
    _writeln('for (${m.modelName} model in models) {');
    _write('find.or(');
    final wheres = <String>[];
    for (int i = 0; i < m.fields.length; i++) {
      wheres.add(
          'this.${m.fields[i].field}.eq(model.${m.foreignFields[i].field})');
    }
    _w.write(wheres.join(' & '));
    _writeln(');');
    _writeln('}');

    if (_b.preloads.length > 0) {
      _writeln('final List<${_b.modelType}> retModels = await findMany(find);');
      _writeln('if (preload) {');
      _writeln(
          'await this.preloadAll(retModels, cascade: cascade, withConn: withConn);');
      _writeln('}');
      _writeln('return retModels;');
    } else {
      _writeln('return findMany(find, withConn: withConn);');
    }

    _w.writeln('}');
  }

  void _writePreload() {
    if (_b.preloads.length == 0) return;

    _writeln(
        'Future<${_b.modelType}> preload(${_b.modelType} model, {bool cascade = false, Connection withConn}) async {');
    for (Preload p in _b.preloads) {
      _write('model.');
      _write(p.property);
      _write(' = await ');

      if (p is PreloadOneToX) {
        _write(_uncap(p.beanInstanceName));
        _write('.findBy');
        _write(_b.modelType);
        if (p.linkBy != null) _write('_for${p.linkBy}');
        _write('(');
        final String args = p.foreignFields
            .map((ParsedField f) => f.foreign.references)
            .map(_b.fieldByColName)
            .map((ParsedField f) => 'model.${f.field}')
            .join(',');
        _write(args);
        _write(', preload: cascade, cascade: cascade, withConn: withConn');
        _writeln(');');
      } else if (p is PreloadManyToMany) {
        _write(
            '${p.beanInstanceName}.fetchBy${_b.modelType}(model, withConn: withConn);');
      }
    }
    _writeln('return model;');
    _writeln('}');
  }

  void _writePreloadAll() {
    if (_b.preloads.length == 0) return;

    _writeln(
        'Future<List<${_b.modelType}>> preloadAll(List<${_b.modelType}> models, {bool cascade = false, Connection withConn}) async {');
    for (Preload p in _b.preloads) {
      if (p is PreloadOneToX) {
        if (p.hasMany) {
          _writeln(
              'models.forEach((${_b.modelType} model) => model.${p.property} ??= []);');
        }

        _write('await OneToXHelper.');
        // Arg1: models
        _write('preloadAll<${_b.modelType}, ${p.modelName}>(models, ');
        // Arg2: ParentGetter
        _write('(${_b.modelType} model) => [');
        {
          final String args = p.foreignFields
              .map((ParsedField f) => f.foreign.references)
              .map(_b.fieldByColName)
              .map((ParsedField f) => 'model.${f.field}')
              .join(',');
          _write(args);
        }
        _write('], ');
        //Arg3: function
        _write(_uncap(p.beanInstanceName));
        _write('.findBy');
        _write(_b.modelType + 'List');
        if (p.linkBy != null) _write('_for${p.linkBy}');
        _write(', ');
        //Arg4: ChildGetter
        _write('(${p.modelName} model) => [');
        {
          final String args = p.foreignFields
              .map((ParsedField f) => 'model.${f.field}')
              .join(',');
          _write(args);
        }
        _write('], ');
        //Arg5: Setter
        if (!p.hasMany) {
          _write(
              '(${_b.modelType} model, ${p.modelName} child) => model.${p.property} = child, ');
        } else {
          _write(
              '(${_b.modelType} model, ${p.modelName} child) => model.${p.property} = List.from(model.${p.property})..add(child), ');
        }
        _writeln('cascade: cascade, withConn: withConn);');
      } else if (p is PreloadManyToMany) {
        _writeln('for(${_b.modelType} model in models) {');
        _writeln(
            'var temp = await ${p.beanInstanceName}.fetchBy${_b.modelType}(model, withConn: withConn);');
        _writeln('if(model.${p.property} == null) model.${p.property} = temp;');
        _writeln('else {');
        _writeln('model.${p.property}.clear();');
        _writeln('model.${p.property}.addAll(temp);');
        _writeln('}');
        _writeln('}');
      }
    }
    _writeln('return models;');
    _writeln('}');
  }

  void _writeBeans() {
    final written = Set<String>();

    for (Preload p in _b.preloads) {
      if (written.contains(p.beanInstanceName)) continue;
      written.add(p.beanInstanceName);

      _write(p.beanName);
      _write(' get ');
      _write(p.beanInstanceName);
      _write(' => beanRepo[${p.beanName}]');
      _writeln(';');
      if (p is PreloadManyToMany) {
        if (written.contains(p.targetBeanInstanceName)) continue;
        written.add(p.targetBeanInstanceName);

        _writeln('');
        _write(p.targetBeanName);
        _write(' get ');
        _write(p.targetBeanInstanceName);
        _write(' => beanRepo[${p.targetBeanName}]');
        _writeln(';');
      }
    }

    for (AssociationByRelation f in _b.associationsWithRelations.values) {
      if (f.isManyToMany) {
        if (written.contains(f.beanInstanceName)) continue;
        written.add(f.beanInstanceName);

        _write(f.beanName);
        _write(' get ');
        _write(f.beanInstanceName);
        _write(' => beanRepo[${f.beanName}]');
        _writeln(';');
      }
    }

    for (ParsedField f in _b.fields.values) {
      if (f.foreign is BelongsToSpec) {
        BelongsToSpec fb = f.foreign;
        if (written.contains(fb.beanInstanceName)) continue;
        written.add(fb.beanInstanceName);

        _write(fb.beanName);
        _write(' get ');
        _write(fb.beanInstanceName);
        _write(' => beanRepo[${fb.beanName}]');
        _writeln(';');
      }
    }

    if (written.isNotEmpty) _writeln("BeanRepo get beanRepo;");
  }

  void _writeAssociate(AssociationByRelation m) {
    _write('void associate${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.write('(');
    _write('${_b.modelType} child, ');
    _write('${m.modelName} parent');
    _writeln(') {');

    for (int i = 0; i < m.fields.length; i++) {
      _writeln(
          'child.${m.fields[i].field} = parent.${m.foreignFields[i].field};');
    }

    _writeln('}');
  }

  void _writeOneToOneFetch(AssociationByRelation m) {
    _write('Future<${m.modelName}> fetch${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _writeln('(${_b.modelType} model, {Connection withConn}) async {');
    _write('return ${m.beanInstanceName}.findOneWhere(');
    {
      final keys = <String>[];
      for (int i = 0; i < m.fields.length; i++) {
        keys.add(
            '${m.beanInstanceName}.${m.foreignFields[i].field}.eq(model.${m.fields[i].field})');
      }
      _write(keys.join('&'));
    }
    _writeln(', withConn: withConn);');
    _writeln('}');
  }

  void _writeOneToManyFetch(AssociationByRelation m) {
    _write('Future<List<${m.modelName}>> fetch${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _writeln('(${_b.modelType} model, {Connection withConn}) async {');
    _write('return ${m.beanInstanceName}.findWhere(');
    {
      final keys = <String>[];
      for (int i = 0; i < m.fields.length; i++) {
        keys.add(
            '${m.beanInstanceName}.${m.foreignFields[i].field}.eq(model.${m.fields[i].field})');
      }
      _write(keys.join('&'));
    }
    _writeln(', withConn: withConn);');
    _writeln('}');
  }

  void _writeManyToManyDetach(AssociationByRelation m) {
    _writeln('Future<int> detach${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.write('(${_cap(m.modelName)} model, {Connection withConn}) async {');
    _writeln('int ret = 0;');
    _write('final dels = await findBy${_cap(m.modelName)}(');
    _write(m.foreignFields.map((f) => 'model.' + f.field).join(', '));
    _writeln(', withConn: withConn);');
    _writeln('if(dels.isNotEmpty) {');
    _write('ret = await removeBy${_cap(m.modelName)}(');
    _write(m.foreignFields.map((f) => 'model.' + f.field).join(', '));
    _writeln(', withConn: withConn);');
    final String beanName = m.manyToManyTarget.beanInstanceName;
    _writeln('final exp = Or();');
    _writeln('for(final t in dels) {');
    _write('exp.or(');
    AssociationByRelation o = _b.getMatchingManyToMany(m);
    for (int i = 0; i < o.fields.length; i++) {
      _write(
          '$beanName.${o.foreignFields[i].field}.eq(t.${o.fields[i].field})');
      if (i < o.fields.length - 1) {
        _write('&');
      }
    }
    _writeln(');');
    _writeln('}');

    _write('return await $beanName.removeWhere(exp, withConn: withConn);');
    _writeln('}');
    _writeln('return ret;');
    _writeln('}');
  }

  void _writeManyToManyFetchOther(AssociationByRelation m) {
    final String beanName = m.manyToManyTarget.beanInstanceName;
    final String targetModel = m.manyToManyTarget.modelName;
    _writeln('Future<List<$targetModel>> fetchBy${_cap(m.modelName)}');
    if (m is AssociationByRelation && m.name != null) {
      _write('_for${m.name}');
    }
    _w.writeln('(${_cap(m.modelName)} model, {Connection withConn}) async {');
    _write('final pivots = await findBy${_cap(m.modelName)}(');
    _write(m.foreignFields.map((f) => 'model.' + f.field).join(', '));
    _writeln(');');
    // Return if model has no pivots. If this is not done, all records will be removed!
    _writeln(
        "// Return if model has no pivots. If this is not done, all records will be removed!");
    _writeln('if (pivots.isEmpty) return [];');
    _writeln();

    AssociationByRelation o = _b.getMatchingManyToMany(m);

    _writeln('final duplicates = <Tuple, int>{};');
    _writeln();

    _writeln('final exp = Or();');
    _writeln('for(final t in pivots) {');
    _write('final tup = Tuple([');
    _write(o.fields.map((f) => 't.${f.field}').join(','));
    _write(']);');
    _writeln('if (duplicates[tup] == null) {');
    _write('exp.or(');
    for (int i = 0; i < o.fields.length; i++) {
      _write(
          '$beanName.${o.foreignFields[i].field}.eq(t.${o.fields[i].field})');
      if (i < o.fields.length - 1) {
        _write('&');
      }
    }
    _writeln(');');
    _writeln('duplicates[tup] = 1;');
    _writeln('} else {');
    _writeln('duplicates[tup] += 1;');
    _writeln('}');
    _writeln();

    _writeln('}');
    _writeln();

    _writeln(
        'final returnList = await $beanName.findWhere(exp, withConn: withConn);');
    _writeln();

    _writeln('if (duplicates.length != pivots.length) {');
    _writeln('for (Tuple tup in duplicates.keys) {');
    _writeln('int n = duplicates[tup] - 1;');
    _writeln('for (int i = 0; i < n; i++) {');
    _write('returnList.add(await $beanName.find(');
    _write(List.generate(o.fields.length, (i) => 'tup[$i]').join(','));
    _writeln(', withConn: withConn));');
    _writeln('}');
    _writeln('}');
    _writeln('}');
    _writeln();

    _writeln('return returnList;');
    _writeln('}');
  }

  void _writeAttach() {
    final AssociationByRelation m = _b.associationsWithRelations.values
        .firstWhere(
            (AssociationByRelation f) =>
                f is AssociationByRelation && f.isManyToMany,
            orElse: () => null);
    if (m == null) return;

    final AssociationByRelation m1 = _b.getMatchingManyToMany(m);

    _writeln('Future<dynamic> attach(');
    if (m.modelName.compareTo(m1.modelName) > 0) {
      _write('${m.modelName} one, ${m1.modelName} two');
    } else {
      _write('${m1.modelName} one, ${_cap(m.modelName)} two');
    }
    _writeln(', {bool upsert = false, Connection withConn}) async {');
    _writeln('final ret = ${_b.modelType}();');

    if (m.modelName.compareTo(m1.modelName) > 0) {
      for (int i = 0; i < m.fields.length; i++) {
        _writeln('ret.${m.fields[i].field} = one.${m.foreignFields[i].field};');
      }
      for (int i = 0; i < m1.fields.length; i++) {
        _writeln(
            'ret.${m1.fields[i].field} = two.${m1.foreignFields[i].field};');
      }
    } else {
      for (int i = 0; i < m1.fields.length; i++) {
        _writeln(
            'ret.${m1.fields[i].field} = one.${m1.foreignFields[i].field};');
      }
      for (int i = 0; i < m.fields.length; i++) {
        _writeln('ret.${m.fields[i].field} = two.${m.foreignFields[i].field};');
      }
    }
    _writeln('''
    if(!upsert) {
      return insert(ret, withConn: withConn);
    } else {
      return this.upsert(ret, withConn: withConn);
    }
    ''');
    _writeln('}');
  }

  void _write(String str) => _w.write(str);

  void _writeln([String str]) => _w.writeln(str ?? '');

  String toString() => _w.toString();
}

String _cap(String str) => str.substring(0, 1).toUpperCase() + str.substring(1);

String _uncap(String str) =>
    str.substring(0, 1).toLowerCase() + str.substring(1);

String _camToSnak(String str) {
  final sb = StringBuffer();

  for (int i = 0; i < str.length; i++) {
    final int code = str.codeUnitAt(i);
    if (code >= 65 && code <= 90) {
      sb.write('_');
    }
    sb.writeCharCode(code);
  }

  return sb.toString().toLowerCase();
}
