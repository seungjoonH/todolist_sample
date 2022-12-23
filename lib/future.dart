import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/model/todo.dart';

// 할일 리스트 클래스
class FutureTodos {
  /// attributes
  // 로컬 할일 리스트
  List<Todo> list = [];

  /// methods
  // 로컬 리스트에 항목 추가
  void add(Todo todo) async {
    Map<String, dynamic> json = todo.toJson();
    var data = await collection.add(json);
    json['id'] = data.id;
    list.add(todo);
  }

  // 로컬 리스트에 항목 수정
  void update(Todo todo) async {
    int index = list.indexWhere((e) => e.id == todo.id);
    list[index] = todo;

    Map<String, dynamic> json = todo.toJson();
    await collection.doc(todo.id).set(json);
  }

  // 로컬 리스트에 항목 삭제
  void delete(String id) {
    list.removeWhere((todo) => todo.id == id);
    collection.doc(id).delete();
  }

  /// static
  static get collection => FirebaseFirestore.instance.collection('todos');
  static get ordered => collection.orderBy('done');
  static get snapshot => ordered.get();

}

class FutureBuilderExamplePage extends StatefulWidget {
  const FutureBuilderExamplePage({Key? key}) : super(key: key);

  @override
  State<FutureBuilderExamplePage> createState() => _FutureBuilderExamplePageState();
}

class _FutureBuilderExamplePageState extends State<FutureBuilderExamplePage> {
  @override
  Widget build(BuildContext context) {
    final controller = TextEditingController();

    return FutureBuilder<QuerySnapshot>(
      future: FutureTodos.snapshot,
      builder: (context, snapshot) {
        if (snapshot.data == null) return const Scaffold();

        FutureTodos todos = FutureTodos();
        todos.list = snapshot.data?.docs.map((data) {
          Todo todo = Todo.fromJson(data.data() as Map<String, dynamic>);
          todo.id = data.id;
          return todo;
        }).toList() ?? [];

        return Scaffold(
          appBar: AppBar(
            title: const Text('Future Builder'),
            actions: [
              IconButton(
                onPressed: () async {
                  await showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: const Text('할일을 입력하세요'),
                      content: TextFormField(
                        controller: controller,
                      ),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () {
                            if (controller.text.isEmpty) return;
                            Todo addTodo = Todo(title: controller.text);
                            todos.add(addTodo);
                            setState(() {});
                            Navigator.of(context).pop();
                          },
                          child: const Text('확인'),
                        ),
                      ],
                    ),
                  );
                },
                icon: const Icon(Icons.add),
              ),
            ],
          ),
          body: ListView(
            children: todos.list.map((todo) {
              return ListTile(
                contentPadding: const EdgeInsets.all(20.0),
                leading: IconButton(
                  onPressed: () {
                    todo.toggleDone();
                    todos.update(todo);
                    setState(() {});
                  },
                  icon: Icon(todo.done
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  ),
                ),
                title: Text(todo.title,
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        await showDialog(
                          context: context,
                          builder: (context) => AlertDialog(
                            title: const Text('할일을 입력하세요'),
                            content: TextFormField(
                              controller: controller,
                            ),
                            actions: <Widget>[
                              TextButton(
                                onPressed: () {
                                  if (controller.text.isEmpty) return;
                                  todo.title = controller.text;
                                  todos.update(todo);
                                  setState(() {});
                                  Navigator.of(context).pop();
                                },
                                child: const Text('확인'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        todos.delete(todo.id!);
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        );
      }
    );
  }
}
