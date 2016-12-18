library serialize.generator.generator;

import 'package:build/build.dart';

import 'package:jaguar_orm/generator/phase/phase.dart';

void _launchWatch() {
  watch(phaseGroup(), deleteFilesByDefault: true);
}

start(List<String> args) {
  if (args.length > 0) {
    if (args[0] == 'watch') {
      _launchWatch();
    } else if (args[0] == 'build') {
      build(phaseGroup(), deleteFilesByDefault: true);
    } else {
      print("Invalid command!");
    }
  } else {
    print("Invalid command!");
  }
}
