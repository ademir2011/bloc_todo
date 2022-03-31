import 'package:todo_bloc/src/todo/models/todo_model.dart';

abstract class TodoState {}

class InitialTodoState extends TodoState {}

class LoadingTodoState extends TodoState {}

class ErrorTodoState extends TodoState {
  final String message;
  ErrorTodoState({required this.message});
}

class ListLoadingTodoState extends TodoState {
  var todos = <TodoModel>[];
  final int page;
  ListLoadingTodoState({required this.todos, required this.page});
}

class SuccessTodoState extends TodoState {
  var todos = <TodoModel>[];
  final int page;
  SuccessTodoState({required this.todos, required this.page});
}

class FinishLoadedState extends TodoState {
  var todos = <TodoModel>[];
  final int page;
  FinishLoadedState({required this.todos, required this.page});
}
