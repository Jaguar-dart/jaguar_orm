import 'package:migration/migration.dart';

main(List<String> arguments) {
  String snapshot = generateSnapshot('TaskList', [
    Create()
        .named('tasks')
        .addInt('id', primary: true, autoIncrement: true)
        .addStr('message', length: 50),
  ]);
  print(snapshot);
}
