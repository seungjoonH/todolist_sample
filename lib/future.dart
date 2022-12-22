import 'package:flutter/material.dart';

// 할일 클래스
class Todo {
  /// attributes
  // 할일
  late String title;

  // 완료 여부
  late bool done;

  /// constructors
  // 기본 생성자
  Todo({required this.title, this.done = false});

  // json 생성자: json 형식 데이터로부터 객체를 생성
  Todo.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// json methods
  // json 형식 데이터로부터 객체의 attributes 를 최신화
  void fromJson(Map<String, dynamic> json) {
    title = json['title'];
    done = json['done'];
  }

  // 객체의 attributes 를 json 형식으로 추출
  Map<String, dynamic> toJson() => {
    'title': title,
    'done': done,
  };

  /// methods
  void toggleDone() => done = !done;
}


// 할일 리스트 클래스
class Todos {
  List<Todo> list = [];

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
                IconButton(onPressed: () {}, icon: Icon(Icons.edit)),
                IconButton(onPressed: () {}, icon: Icon(Icons.delete)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
