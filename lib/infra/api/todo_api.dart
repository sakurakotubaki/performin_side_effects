import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:performin_side_effects/domain/todo.dart';
import 'package:http/http.dart' as http;

class TodoAPI {

  Future<Todo> addTodo(Todo todo) async {
    try {
 final response = await http.post(
        Uri.http('localhost:3000', '/todo'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(todo.toJson()),
      );
      switch (response.statusCode) {
        case 200:
        case 201:
        final result = Todo.fromJson(jsonDecode(utf8.decode(response.bodyBytes)));
          return result;
        default:
          throw Exception(response.reasonPhrase);
      }
    } on Exception catch (e) {
      debugPrint('api call error: $e');
      rethrow;
    }
  }
}
// abstract interface class TodoAPI {
//   Future<Todo> addTodo(Todo todo);
// }

// @Riverpod(keepAlive: true)
// TodoImpl todoImpl(TodoImplRef ref) {
//   final client = http.Client();
//   return TodoImpl(client: client);
// }

// class TodoImpl implements TodoAPI {
//   final http.Client client;
//   TodoImpl({required this.client});
//   @override
//   Future<Todo> addTodo(Todo todo) async {
//     try {
//       final response = await http.post(
//         Uri.http('localhost:3000', '/todo'),
//         headers: {'Content-Type': 'application/json'},
//         body: jsonEncode(todo.toJson()),
//       );
//       if (response.statusCode == 200) {
//         return Todo.fromJson(jsonDecode(response.body));
//       } else {
//         throw Exception('Failed to add todo');
//       }
//     } on Exception catch (e) {
//       throw Exception('api call error: $e');
//     }
//   }
// }
