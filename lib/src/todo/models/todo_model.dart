class TodoModel {
  final String id;
  final String title;
  final bool check;

  TodoModel({
    required this.id,
    required this.title,
    required this.check,
  });

  copyWith({
    id,
    title,
    check,
  }) =>
      TodoModel(
        id: id ?? this.id,
        title: title ?? this.title,
        check: check ?? this.check,
      );

  factory TodoModel.fromMap(Map map) => TodoModel(
        id: map['id'],
        check: false,
        title: map['title']['rendered'],
      );
}
