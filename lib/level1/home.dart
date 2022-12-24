import 'package:intl/intl.dart';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

/// This example is the sample of TO-DO List.
/// You can learn how to READ data from firebase,
/// and also ADD, UPDATE and DELETE.

class Level1Page extends StatefulWidget {
  const Level1Page({Key? key}) : super(key: key);

  @override
  State<Level1Page> createState() => _Level1PageState();
}

class _Level1PageState extends State<Level1Page> {
  TextEditingController controller = TextEditingController();
  bool isFuture = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: false,
        // leading widget of appBar: one widget should follow
        leading: IconButton(
          // right after the 'refresh button' pressed,
          // the future-stream mode toggled
          onPressed: () => setState(() => isFuture = !isFuture),
          icon: Icon(isFuture ? Icons.toggle_off : Icons.toggle_on),
        ),
        // title widget of appBar
        title: Text(
          '${isFuture ? 'Future' : 'Stream'} Todo List',
        ),
        // action widgets of appBar: widget list should follow
        actions: [
          // 'refresh button' displayed when 'isFuture' is true
          if (isFuture)
          IconButton(
            // right after the 'refresh button' pressed,
            // following function executes (refreshing screen)
            onPressed: () => setState(() {}),
            icon: const Icon(Icons.refresh),
          ),
          // TO-DO item can be added by pressing 'add button'
          IconButton(
            // right after the 'add button' pressed,
            // following function executes
            onPressed: () async {
              // asking TO-DO title dialog is displayed
              await showDialog(
                context: context,
                // build the dialog widget
                builder: (context) => AlertDialog(
                  title: const Text('Enter your TODO'),
                  content: TextFormField(controller: controller),
                  actions: [
                    TextButton(
                      // right after the 'submit button' pressed,
                      // following function executes
                      onPressed: () {
                        // TO-DO item would be added on firebase
                        FirebaseFirestore.instance.collection('todos').add({
                          'title': controller.text,
                          'done': false,
                          'createTime': Timestamp.now(),
                        });
                        // clear text editing controller:
                        // avoid remaining text in the input field later
                        controller.clear();
                        // close the dialog
                        Navigator.pop(context);
                        // recall and rebuild the screen
                        setState(() {});
                      },
                      child: const Text('Submit'),
                    ),
                  ],
                ),
              );
            },
            icon: const Icon(Icons.add),
          ),
        ],
      ),
      // according to the value of 'isFuture' variable,
      // FutureBuilder and StreamBuilder would be toggled
      body: isFuture
          ? FutureBuilder<QuerySnapshot>(
        // for the FutureBuilder, get() function is used
        future: FirebaseFirestore.instance
            .collection('todos').orderBy('createTime').get(),
        builder: (context, snapshot) {
          // when the snapshot has no data,
          // return with null Scaffold
          if (!snapshot.hasData) return const Scaffold();
          // otherwise, data be shown in ListView
          return ListView(
            // snapshot data mapped to list of ListTile
            // from List<_JsonQueryDocumentSnapshot> to List<ListTile>
            children: snapshot.data!.docs.map((todo) {
              // ListTile widget of each TO-DO item
              return ListTile(
                contentPadding: const EdgeInsets.all(20.0),
                leading: IconButton(
                  // right after the 'edit button' pressed,
                  // following function executes
                  onPressed: () {
                    // whether TO-DO item is done or not would be updated on firebase
                    FirebaseFirestore.instance
                        .collection('todos').doc(todo.id).set({
                      'title': todo['title'],
                      'done': !todo['done'],
                      'createTime': todo['createTime'],
                    });
                    // recall and rebuild the screen
                    setState(() {});
                  },
                  // according to value of 'done',
                  // icon would be toggled
                  icon: Icon(todo['done']
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  ),
                ),
                title: Text(todo['title'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  // date data can be formatted to string
                  DateFormat.yMMMd().add_Hm().format(todo['createTime'].toDate()),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // asking TO-DO title dialog is displayed
                        await showDialog(
                          context: context,
                          // build the dialog widget
                          builder: (context) => AlertDialog(
                            title: const Text('Enter your TODO'),
                            content: TextFormField(
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                // right after the 'submit button' pressed,
                                // following function executes
                                onPressed: () {
                                  // TO-DO item would be updated on firebase
                                  FirebaseFirestore.instance
                                      .collection('todos').doc(todo.id).set({
                                    'title': controller.text,
                                    'done': todo['done'],
                                    'createTime': todo['createTime'],
                                  });
                                  // close the dialog
                                  Navigator.pop(context);
                                  // recall and rebuild the screen
                                  setState(() {});
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        // TO-DO item would be deleted on firebase
                        FirebaseFirestore.instance.collection('todos')
                            .doc(todo.id).delete();
                        // recall and rebuild the screen
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ) : StreamBuilder<QuerySnapshot>(
        // for the FutureBuilder, snapshots() function is used
        stream: FirebaseFirestore.instance
            .collection('todos').orderBy('createTime').snapshots(),
        builder: (context, snapshot) {
          // when snapshot has no data, return with null Scaffold
          if (!snapshot.hasData) return const Scaffold();
          // otherwise, data be shown in ListView
          return ListView(
            // snapshot data mapped to list of ListTile
            // from List<_JsonQueryDocumentSnapshot> to List<ListTile>
            children: snapshot.data!.docs.map((todo) {
              // ListTile widget of each TO-DO item
              return ListTile(
                contentPadding: const EdgeInsets.all(20.0),
                leading: IconButton(
                  // right after the 'edit button' pressed,
                  // following function executes
                  onPressed: () {
                    // whether TO-DO item is done or not would be updated on firebase
                    FirebaseFirestore.instance
                        .collection('todos').doc(todo.id).set({
                      'title': todo['title'],
                      'done': !todo['done'],
                      'createTime': todo['createTime'],
                    });
                    // recall and rebuild the screen
                    setState(() {});
                  },
                  // according to value of 'done', icon would be changed
                  icon: Icon(todo['done']
                      ? Icons.check_box
                      : Icons.check_box_outline_blank,
                  ),
                ),
                title: Text(todo['title'],
                  style: Theme.of(context).textTheme.titleLarge,
                ),
                subtitle: Text(
                  DateFormat.yMMMd().add_Hm().format(todo['createTime'].toDate()),
                ),
                trailing: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    IconButton(
                      onPressed: () async {
                        // asking TO-DO title dialog is displayed
                        await showDialog(
                          context: context,
                          // build the dialog widget
                          builder: (context) => AlertDialog(
                            title: const Text('Enter your TODO'),
                            content: TextFormField(
                              controller: controller,
                            ),
                            actions: [
                              TextButton(
                                // right after the 'submit button' pressed,
                                // following function executes
                                onPressed: () {
                                  // TO-DO item would be updated on firebase
                                  FirebaseFirestore.instance
                                      .collection('todos').doc(todo.id).set({
                                    'title': controller.text,
                                    'done': todo['done'],
                                    'createTime': todo['createTime'],
                                  });
                                  // close the dialog
                                  Navigator.pop(context);
                                  // recall and rebuild the screen
                                  setState(() {});
                                },
                                child: const Text('Submit'),
                              ),
                            ],
                          ),
                        );
                      },
                      icon: const Icon(Icons.edit),
                    ),
                    IconButton(
                      onPressed: () {
                        // TO-DO item would be deleted on firebase
                        FirebaseFirestore.instance.collection('todos')
                            .doc(todo.id).delete();
                        // recall and rebuild the screen
                        setState(() {});
                      },
                      icon: const Icon(Icons.delete),
                    ),
                  ],
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}