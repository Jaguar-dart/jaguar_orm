library jaguar_orm.generator.hook;

import 'dart:async';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/src/builder/build_step.dart';
import 'package:source_gen/source_gen.dart';

import 'package:jaguar_orm/src/annotations/annotations.dart' as ant;

import 'package:jaguar_orm/generator/parser/parser.dart';
import 'package:jaguar_orm/generator/writer/writer.dart';
import 'package:jaguar_orm/generator/model/model.dart';

import 'package:source_gen_help/source_gen_help.dart';

/// source_gen hook to generate serializer
class BeanGenerator extends GeneratorForAnnotation<ant.GenBean> {
  const BeanGenerator();

  /// This method is called when build finds an element with
  /// [GenSerializer] annotation.
  ///
  /// [element] is the element annotated with [Api]
  /// [api] is an instantiation of the [Api] annotation
  @override
  Future<String> generateForAnnotatedElement(
      Element element, ant.GenBean annot, BuildStep buildStep) async {
    if (element is! ClassElement) {
      throw new Exception("GenBean annotation can only be defined on a class.");
    }

    ClassElementWrap clazz = new ClassElementWrap(element);
    String className = clazz.name;

    print("Generating bean for $className ...");

    ParsedBean parsed = ParsedBean.detect(clazz, annot);

    Bean bean = new ToModel(parsed).model;

    Writer writer = new Writer(bean);

    return writer.toString();
  }
}
