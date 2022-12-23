
// 할일 클래스
class Todo {
  /// attributes
  // 아이디
  String? id;

  // 할일
  late String title;

  // 완료 여부
  late bool done;

  /// constructors
  // 기본 생성자
  Todo({
    this.id,
    required this.title,
    this.done = false,
  });

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
