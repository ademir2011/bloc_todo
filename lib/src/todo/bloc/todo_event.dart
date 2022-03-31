import 'package:todo_bloc/src/todo/models/todo_model.dart';

abstract class TodoEvent {}

class FetchTodoEvent extends TodoEvent {
  final int page;
  final int perPage;

  FetchTodoEvent({this.page = 1, this.perPage = 30});
}

class UpdateTodoEvent extends TodoEvent {
  final List<TodoModel> todos;
  final int page;
  final int perPage;
  UpdateTodoEvent({required this.todos, required this.page, this.perPage = 30});
}

class CheckTodoEvent extends TodoEvent {}
