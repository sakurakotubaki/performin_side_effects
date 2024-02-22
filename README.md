# performin_side_effects

こちらを参考にnpmでインストールしてください!

[mock-serverを使う](https://zenn.dev/joo_hashi/books/20dd2274ba88a9/viewer/5514b7)


オニオンアーキテクチャ風にレイヤーを分けています。
```
lib
├── application
│   ├── todo_list.dart
│   └── todo_list.g.dart
├── domain
│   ├── todo.dart
│   ├── todo.freezed.dart
│   └── todo.g.dart
├── infra
│   ├── get_todo_list.dart
│   └── get_todo_list.g.dart
├── main.dart
└── presentation
    └── example.dart
```