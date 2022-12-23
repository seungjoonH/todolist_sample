import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';

// 할일 리스트 클래스
class StreamTodos {
  List<Todo> list = [];
  FirebaseFirestore f = FirebaseFirestore.instance;

  void add(Todo todo) => list.add(todo);
  void update(int index, Todo todo) => list[index] = todo;
  void delete(int index) => list.removeAt(index);
}

class StreamBuilderExamplePage extends StatelessWidget {
  const StreamBuilderExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Stream Builder')),
    );
  }
}
