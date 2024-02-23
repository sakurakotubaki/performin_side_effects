import 'dart:convert';

import 'package:performin_side_effects/domain/todo.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:http/http.dart' as http;
part 'todo_list.g.dart';

@riverpod
class TodoList extends _$TodoList {
  @override
  Future<List<Todo>> build() async => [];

  Future<List<Todo>> addTodo(Todo todo) async {
    final response = await http.post(
      Uri.parse('http://localhost:3000/todo'),
      headers: {'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode(todo),
    );
    // status code 200 or 201でない場合は、例外が出てしまう!
    if (response.statusCode == 200 || response.statusCode == 201) {
      return [Todo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)))];
    } else {
      throw Exception('Failed to add todo');
    }
  }

  // Future<void> addTodo(Todo todo) async {
  //   // The POST request will return a List<Todo> matching the new application state
  //   final response = await http.post(
  //     // （localhost:3000）は通常、SSL/TLS証明書を提供していないため、
  //     // https -> httpに修正
  //     Uri.http('localhost:3000', '/todo'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(todo.toJson()),
  //   );

  //   Map<String, dynamic> todoMap = jsonDecode(response.body);
  //   Todo newTodos = Todo.fromJson(todoMap);

  //   // newTodosは単一のインスタンスであるためリストで包む必要がある
  //   state = AsyncData([newTodos]);
  // }

  //   Future<void> addTodo(Todo todo) async {
  //   // We don't care about the API response
  //   await http.post(
  //     Uri.http('localhost:3000', '/todo'),
  //     headers: {'Content-Type': 'application/json'},
  //     body: jsonEncode(todo.toJson()),
  //   );

  //   // ポストリクエストが完了したら、ローカルキャッシュをダーティとしてマークすることができる。
  //   // これにより、ノーティファイアの "build "が非同期で再度呼び出されます、
  //   // その際、リスナーに通知されます。
  //   ref.invalidateSelf();

  //   // オプション）その後、新しい状態が計算されるのを待つことができる。
  //   // これにより、新しい状態が利用可能になるまで // "addTodo "が完了しないようにします。
  //   await future;
  // }

  // Future<void> addTodo(Todo todo) async {
  // // We don't care about the API response
  // await http.post(
  //   Uri.http('localhost:3000', '/todo'),
  //   headers: {'Content-Type': 'application/json'},
  //   body: jsonEncode(todo.toJson()),
  // );

  // その後、手動でローカルキャッシュを更新することができる。そのためには
  // 以前の状態を取得する。
  // 注意： 前の状態はまだロード中かエラー状態かもしれない。
  // これを処理する優雅な方法は、 `this.state` の代わりに `this.future` を読み込むことである。
  // の代わりに `this.future` を読み込むことである。
  // エラー状態の場合はエラーを投げる。
  // final previousState = await future;

  // 新しい状態オブジェクトを作成することで、状態を更新できる。
  // これはすべてのリスナーに通知されます。
  // state = AsyncData([...previousState, todo]);
  // }
}
