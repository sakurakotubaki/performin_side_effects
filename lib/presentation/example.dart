import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:performin_side_effects/application/todo_list.dart';
import 'package:performin_side_effects/domain/todo.dart';
import 'package:performin_side_effects/infra/api/todo_api.dart';
import 'package:performin_side_effects/infra/get_todo_list.dart';

// class Example extends ConsumerWidget {
//   const Example({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return Scaffold(
//         appBar: AppBar(
//           title: const Text('Example'),
//         ),
//         body: Center(
//           child: Column(
//             children: [
//               ElevatedButton(
//                 onPressed: () {
//                   // Using "ref.read" combined with "myProvider.notifier", we can
//                   // obtain the class instance of our notifier. This enables us
//                   // to call the "addTodo" method.
//                   ref
//                       .read(todoListProvider.notifier)
//                       .addTodo(const Todo(description: 'This is a new todo'));

//                   // ここで、getTodoListProviderをinvalidateすることで、再度データを取得する
//                   // ref.invalidate(getTodoListProvider);
//                 },
//                 child: const Text('Add todo'),
//               ),
//               // Expandedで、wrapしないと表示できない!
//               const Expanded(child: GetTodoListView()),
//             ],
//           ),
//         ));
//   }
// }

// mockのデータを表示するコンポーネント
class GetTodoListView extends ConsumerWidget {
  const GetTodoListView({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final todoList = ref.watch(getTodoListProvider);
    // riverpod2.0からは、switch文を使うらしい
    return switch (todoList) {
      AsyncData(:final value) => ListView.builder(
          itemCount: value.length,
          itemBuilder: (context, index) {
            final todo = value[index];
            return ListTile(
              title: Text(todo.description),
              trailing: Checkbox(
                value: todo.completed,
                onChanged: (newValue) {
                  // 今回はロジック書かない
                },
              ),
            );
          },
        ),
      AsyncError(:final error) => Text('Error: $error'),
      _ => const Text('ロード中...'),
    };
  }
}

class Example extends ConsumerStatefulWidget {
  const Example({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExampleState();
}

class _ExampleState extends ConsumerState<Example> {
  // The pending addTodo operation. Or null if none is pending.
  Future<void>? _pendingAddTodo;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Example'),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          await TodoAPI().addTodo(
            const Todo(
              description: 'hi minn',
              completed: false,
            ),
          );
        },
        child: const Icon(Icons.add),
      ),
      body: FutureBuilder(
        // We listen to the pending operation, to update the UI accordingly.
        future: _pendingAddTodo,
        builder: (context, snapshot) {
          // Compute whether there is an error state or not.
          // The connectionState check is here to handle when the operation is retried.
          final isErrored = snapshot.hasError &&
              snapshot.connectionState != ConnectionState.waiting;

          return Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(
                style: ButtonStyle(
                  // If there is an error, we show the button in red
                  backgroundColor: MaterialStateProperty.all(
                    isErrored ? Colors.red : null,
                  ),
                ),
                onPressed: () {
                  // We keep the future returned by addTodo in a variable
                  final future = ref
                      .read(todoListProvider.notifier)
                      .addTodo(const Todo(description: 'This is a new todo'));

                  // We store that future in the local state
                  setState(() {
                    _pendingAddTodo = future;
                  });
                },
                child: const Text('Add todo'),
              ),
              // The operation is pending, let's show a progress indicator
              if (snapshot.connectionState == ConnectionState.waiting) ...[
                const SizedBox(width: 8),
                const CircularProgressIndicator(),
              ]
            ],
          );
        },
      ),
    );
  }
}
