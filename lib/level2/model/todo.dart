import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:intl/intl.dart';

/// TO-DO class
class Todo {
  /// attributes
  String? id;
  late String title;
  late bool done;
  late Timestamp _createTime;

  /// constructors
  // default constructor
  Todo({
    // nullable
    this.id,
    // non-nullable (parameter passing required)
    required this.title,
    // non-nullable (with default constant value)
    this.done = false,
    // non-nullable (with default non-constant value)
    Timestamp? createTime,
  }) : _createTime = createTime ?? Timestamp.now();

  // json constructor: construct object from json data
  Todo.fromJson(Map<String, dynamic> json) {
    fromJson(json);
  }

  /// json methods
  // update object attributes from json data
  void fromJson(Map<String, dynamic> json) {
    id = json['id'];
    title = json['title'];
    done = json['done'];
    _createTime = json['createTime'];
  }

  // extract json data from object attributes
  Map<String, dynamic> toJson() => {
    'id': id,
    'title': title,
    'done': done,
    'createTime': _createTime,
  };

  /// methods
  // toggle done value
  void toggleDone() => done = !done;

  // return string formatted createTime
  String get createTime {
    return DateFormat.yMMMd().add_Hm().format(_createTime.toDate());
  }
}
