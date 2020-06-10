import 'package:flutter_test/flutter_test.dart';
import 'package:sides/models/option.dart';
import 'package:sides/models/question.dart';

main() {
  test('Test null question options', () {
    final q = Question()
      ..name = 'Hello, World!'
      ..category = 'Category X';

    expect(0, q.options.length);
  });

  test('Test question votes', () {
    final q = Question()
      ..name = 'Hello, World!'
      ..category = 'Category X';

    final option1 = Option()
      ..name = 'Option 1'
      ..votes = 10;

    final option2 = Option()
      ..name = 'Option 2'
      ..votes = 0;

    final option3 = Option()
      ..name = 'Option 3'
      ..votes = 1;

    q.options.add(option1);
    q.options.add(option2);
    q.options.add(option3);

    expect(3, q.options.length);
    expect(11, q.votes);
  });
}
