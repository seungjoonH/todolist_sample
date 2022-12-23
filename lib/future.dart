import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';

// 할일 리스트 클래스
class FutureTodos {
  List<Todo> list = [];
  FirebaseFirestore f = FirebaseFirestore.instance;

  void add(Todo todo) => list.add(todo);
  void update(int index, Todo todo) => list[index] = todo;
  void delete(int index) => list.removeAt(index);
}

class FutureBuilderExamplePage extends StatelessWidget {
  const FutureBuilderExamplePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Future Builder'),
        actions: [
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      body: ListView(
        children: [
          ListTile(
            contentPadding: const EdgeInsets.all(20.0),
            leading: IconButton(
              onPressed: () {

              },
              icon: const Icon(Icons.check_box),
            ),
            title: Text('공부하기',
              style: Theme.of(context).textTheme.titleLarge,
            ),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(onPressed: () {}, icon: const Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: const Icon(Icons.delete)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
