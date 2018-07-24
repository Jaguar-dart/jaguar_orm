import 'package:build_runner/build_runner.dart' as _i1;
import 'package:jaguar_orm_gen/builder.dart' as _i2;
import 'dart:isolate' as _i3;

final _builders = <_i1.BuilderApplication>[
  _i1.apply('jaguar_orm_gen|jaguar_orm_gen', [_i2.jaguarOrm], _i1.toRoot(),
      hideOutput: false)
];
main(List<String> args, [_i3.SendPort sendPort]) async {
  var result = await _i1.run(args, _builders);
  sendPort?.send(result);
}
