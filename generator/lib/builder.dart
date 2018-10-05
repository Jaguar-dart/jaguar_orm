library jaguar_orm_gen;

import 'package:build/build.dart';
import 'src/hook/hook.dart';
import 'package:source_gen/source_gen.dart';

Builder jaguarSerializerPartBuilder({String header}) =>
    PartBuilder([BeanGenerator()], '.jorm.dart', header: header);

Builder jaguarOrm(BuilderOptions options) =>
    jaguarSerializerPartBuilder(header: options.config['header'] as String);
