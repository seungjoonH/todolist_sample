import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todolist/level2/model/todo.dart';

/// class
class FirebaseController {
  /// static accessors
  static get collection => FirebaseFirestore.instance.collection('todos');
  static get ordered => collection.orderBy('createTime');
  static get get => ordered.get();
  static get snapshots => ordered.snapshots();

  /// static methods
  // firebase query methods (add, update & delete)
  static void add(Todo todo) => collection.add(todo.toJson());
  static void update(Todo todo) => collection.doc(todo.id).set(todo.toJson());
  static void delete(String id) => collection.doc(id).delete();
}

// dialog display function
// returns the string that entered by user
Future<String?> showMyDialog(BuildContext context, [Todo? todo]) async {
  TextEditingController controller = TextEditingController(
    // if the TO-DO passed (edit),
    // the title will be shown in the input field
    // otherwise (add), not.
    text: todo?.title ?? '',
  );
  String? resultText;

  await showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: const Text('Enter your TODO'),
      content: TextFormField(controller: controller),
      actions: [
        TextButton(
          onPressed: () {
            resultText = controller.text;
            controller.clear();
            Navigator.of(context).pop();
          },
          child: const Text('Submit'),
        ),
      ],
    ),
  );
  return resultText;
}

class Level2Page extends StatefulWidget {
  const Level2Page({Key? key}) : super(key: key);

  @override
  State<Level2Page> createState() => _Level2PageState();
}

class _Level2PageState extends State<Level2Page> {
  bool isFuture = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        leading: IconButton(
          onPressed: () => setState(() => isFuture = !isFuture),
          icon: Icon(isFuture ? Icons.toggle_off : Icons.toggle_on),
        ),
        title: Text('${isFuture ? 'Future' : 'Stream'} Todo List'),
        actions: [
          if (isFuture)
          IconButton(
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            onPressed: () async {
              // text from dialog input field
              String? inputText = await showMyDialog(context);
              if (inputText == null) return;
              // TO-DO item would be added on firebase
              FirebaseController.add(Todo(title: inputText));
              setState(() {});
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),

      body: isFuture
          ? FutureBuilder<QuerySnapshot>(
        future: FirebaseController.get,
        builder: _builder,
      ) : StreamBuilder<QuerySnapshot>(
        stream: FirebaseController.snapshots,
        builder: _builder,
      ),
    );
  }
}

// builder function
// to eliminates duplication of code
Widget _builder(BuildContext context, AsyncSnapshot snapshot) {
  if (snapshot.data == null) return const Scaffold();

  List<Todo> todolist = snapshot.data?.docs.map<Todo>((data) {
    Todo todo = Todo.fromJson(data.data() as Map<String, dynamic>);
    todo.id = data.id;
    return todo;
  }).toList() ?? [];

  return TodoListView(list: todolist);
}

// user-defined widget
// to eliminates duplication of code
class TodoListView extends StatefulWidget {
  const TodoListView({
    Key? key,
    // 'list' must be passed
    required this.list,
  }) : super(key: key);

  final List<Todo> list;

  @override
  State<TodoListView> createState() => _TodoListViewState();
}

class _TodoListViewState extends State<TodoListView> {
  @override
  Widget build(BuildContext context) {
    // parent state
    // use when reload and rebuild the parent widget
    _Level2PageState? parent = context.findAncestorStateOfType<_Level2PageState>();

    return ListView(
      shrinkWrap: true,
      children: widget.list.map((todo) {
        return ListTile(
          contentPadding: const EdgeInsets.all(20.0),
          leading: IconButton(
            onPressed: () async {
              todo.toggleDone();
              // TO-DO item would be updated on firebase
              FirebaseController.update(todo);
              // reload and rebuild the parent widget
              parent?.setState(() {});
            },
            icon: Icon(todo.done
                ? Icons.check_box
                : Icons.check_box_outline_blank,
            ),
          ),
          title: Text(todo.title,
            style: Theme.of(context).textTheme.titleLarge,
          ),
          subtitle: Text(todo.createTime),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              IconButton(
                onPressed: () async {
                  // text from dialog input field4
                  String? inputText = await showMyDialog(context, todo);
                  if (inputText == null) return;
                  todo.title = inputText;
                  // TO-DO item would be updated on firebase
                  FirebaseController.update(todo);
                  // reload and rebuild the parent widget
                  parent?.setState(() {});
                },
                icon: const Icon(Icons.edit),
              ),
              IconButton(
                onPressed: () {
                  // TO-DO item would be deleted on firebase
                  FirebaseController.delete(todo.id!);
                  // reload and rebuild the parent widget
                  parent?.setState(() {});
                },
                icon: const Icon(Icons.delete),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }
}
