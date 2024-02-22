import 'dart:convert';

import 'package:performin_side_effects/domain/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'get_todo_list.g.dart';

// HTTP GETリクエストを送信する。todoというListを持っているJSONから
// POSTしたデータを取得する
@riverpod
Future<List<Todo>> getTodoList(GetTodoListRef ref) async {
  try {
    final response = await http.get(
      Uri.http('localhost:3000', '/todo'),
    );

    if (response.statusCode == 200) {
      final List<dynamic> todoList = jsonDecode(response.body);
      return todoList.map((e) => Todo.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load todo list');
    }
  } on Exception catch (e) {
    throw Exception('api call error: $e');
  }
}