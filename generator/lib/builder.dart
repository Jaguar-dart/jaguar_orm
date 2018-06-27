library jaguar_serializer_cli;

import 'package:build/build.dart';
import 'src/hook/hook.dart';
import 'package:source_gen/source_gen.dart';

Builder jaguarSerializerPartBuilder({String header}) =>
    new PartBuilder([new BeanGenerator()],
        header: header, generatedExtension: '.jorm.dart');

Builder jaguarOrm(BuilderOptions options) =>
    jaguarSerializerPartBuilder(header: options.config['header'] as String);
