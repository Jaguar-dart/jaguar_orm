import 'package:build_runner/build_runner.dart' as _i1;
import 'package:build_test/builder.dart' as _i2;
import 'package:build_config/build_config.dart' as _i3;
import 'package:jaguar_orm_gen/builder.dart' as _i4;
import 'dart:isolate' as _i5;

final _builders = <_i1.BuilderApplication>[
  _i1.apply(
      'build_test|test_bootstrap',
      [_i2.debugIndexBuilder, _i2.debugTestBuilder, _i2.testBootstrapBuilder],
      _i1.toRoot(),
      hideOutput: true,
      defaultGenerateFor: const _i3.InputSet(include: const ['test/**'])),
  _i1.apply('jaguar_orm_gen|jaguar_orm_gen', [_i4.jaguarOrm], _i1.toRoot(),
      hideOutput: false)
];
main(List<String> args, [_i5.SendPort sendPort]) async {
  var result = await _i1.run(args, _builders);
  sendPort?.send(result);
}
