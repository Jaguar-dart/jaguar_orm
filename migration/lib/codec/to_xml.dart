/// Converts [Create] statement to XML snapshot
library migration.toxml;

import 'package:xml/xml.dart';
import 'package:jaguar_query/jaguar_query.dart';

Map<Type, String> types = {
  CreateInt: 'int',
  CreateDouble: 'double',
  CreateStr: 'varstr',
  CreateBool: 'bool',
  CreateDateTime: 'datetime',
};

XmlElement columnToXml(CreateColumn col) {
  List<XmlAttribute> attr = [
    XmlAttribute(XmlName('name'), col.colName),
    XmlAttribute(XmlName('type'), types[col.runtimeType]),
  ];
  if (!col.isNullable) attr.add(XmlAttribute(XmlName('not-null'), 'true'));
  if (col.isPrimaryKey) attr.add(XmlAttribute(XmlName('primary'), 'true'));

  if (col is CreateInt) {
    if (col.autoIncrement) attr.add(XmlAttribute(XmlName('auto-inc'), 'true'));
  } else if (col is CreateStr) {
    attr.add(XmlAttribute(XmlName('length'), col.length.toString()));
  }

  // TODO unique
  // TODO primary key
  // TODO foreign key

  final table = XmlElement(XmlName('col'), attr, []);
  return table;
}

XmlElement tableToXml(Create statement) {
  QueryCreateInfo info = statement.info;
  final table = XmlElement(
      XmlName('table'),
      [
        XmlAttribute(XmlName('name'), info.tableName),
      ],
      info.columns.values.map(columnToXml).toList());
  return table;
}

XmlDocument projectToXml(String name, List<Create> tables, {DateTime time}) {
  time ??= DateTime.now();

  List<XmlElement> elements = tables.map(tableToXml).toList();

  var snapshot = XmlElement(
      XmlName('snapshot'),
      [
        XmlAttribute(XmlName('project'), name),
        XmlAttribute(XmlName('time'), time.toUtc().toIso8601String()),
      ],
      elements);

  final doc = XmlDocument([snapshot]);
  return doc;
}

String generateSnapshot(String name, List<Create> tables, {DateTime time}) {
  XmlDocument doc = projectToXml(name, tables, time: time);
  return doc.toXmlString(pretty: true, indent: '\t');
}
