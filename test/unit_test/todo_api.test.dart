import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:performin_side_effects/domain/todo.dart';
import 'package:performin_side_effects/infra/api/todo_api.dart';
import 'package:http/http.dart' as http;

import 'todo_api.test.mocks.dart';
// flutter pub run build_runner watch --delete-conflicting-outputs
@GenerateMocks([http.Client])
void main() {
  late TodoAPI todoAPI;
  late MockClient mockClient;

  setUp(() {
    mockClient = MockClient();
    todoAPI = TodoAPI(); // モックの http.Client を注入
  });

  group('todoAPI - ', () {
    group('POS API function', () {
      test(
        'POST API 関数が正常にPOSTリクエストを送信し、Todoを返すことを確認する。',
        () async {
          final todo = Todo(completed: true, description: 'モックを注入しちゃうもんね!');
          // Arrange
          when(mockClient.post(
            any,
            headers: anyNamed('headers'),
            body: anyNamed('body'),
          )).thenAnswer((_) async => http.Response(
              '{"description": "モックを注入しちゃうもんね!", "completed": true}', 200));
          // Act
          final result = await todoAPI.addTodo(todo);

          expect(result, isA<Todo>());
          expect(result.description, equals('モックを注入しちゃうもんね!')); // 修正
          expect(result.completed, equals(true)); // 修正
        },
      );
    });
  });
}
