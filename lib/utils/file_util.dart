import 'dart:convert';
import 'dart:io';

import 'package:path_provider/path_provider.dart';
import 'package:todo/models/todo.dart';

class TodoStorage {
  Future<String> get _localPath async {
    final directory = await getApplicationDocumentsDirectory();

    return directory.path;
  }

  Future<File> get _localFile async {
    final path = await _localPath;
    return File('$path/todo.txt');
  }

  Future<List<Todo>> readTodoList() async {
    try {
      final file = await _localFile;

      String contents = await file.readAsString();

      dynamic decodedTodos = jsonDecode(contents);

      List<Todo> todos = [];

      for (var todo in decodedTodos) {
        todos.add(new Todo(title: todo['title'], items: todo['items']));
      }

      return todos;
    } catch (e) {
      print("ERROR: " + e.toString());
      return <Todo>[];
    }
  }

  Future<File> writeTodo(List<Todo> todo) async {
    final file = await _localFile;

    String encoded = jsonEncode(todo);

    return file.writeAsString(encoded);
  }
}
