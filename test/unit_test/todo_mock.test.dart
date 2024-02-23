import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:performin_side_effects/application/todo_list.dart';
import 'package:performin_side_effects/domain/todo.dart';
import 'package:mockito/annotations.dart';
import 'package:http/http.dart' as http;

import 'todo_api.test.mocks.dart';

@GenerateMocks([http.Client])
void main() {
  late TodoList target;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    final container = ProviderContainer();
    target = container.read(todoListProvider.notifier);
  });

  group('addTodo', () {
    test('should return a todo when the http call completes successfully',
        () async {
      final todo = Todo(completed: false, description: 'モックを注入!');
      when(mockClient.post(
        any,
        headers: anyNamed('headers'),
        body: anyNamed('body'),
      )).thenAnswer((_) async =>
          http.Response('{"description": "モックを注入!", "completed": false}', 200));
      final result = await target.addTodo(todo);
      // Notifierを使うとインスタンスが変わるので、値を比較する
      expect(result[0].description, todo.description);
      expect(result[0].completed, todo.completed);
    });
  });
}
