import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:todo_bloc/src/todo/bloc/todo_event.dart';
import 'package:todo_bloc/src/todo/bloc/todo_state.dart';
import 'package:todo_bloc/src/todo/services/todo_service.dart';

class TodoBloc extends Bloc<TodoEvent, TodoState> {
  final TodoService todoService;
  TodoBloc(this.todoService) : super(InitialTodoState()) {
    on<FetchTodoEvent>(_fetchTodoEvent);
    on<UpdateTodoEvent>(_updateTodoEvent);
  }

  Future<void> _fetchTodoEvent(FetchTodoEvent event, emit) async {
    emit(LoadingTodoState());
    try {
      final todos = await todoService.fetchTodo(page: 1, perPage: event.perPage);
      if (todos.isEmpty) {
        emit(InitialTodoState());
      } else {
        emit(SuccessTodoState(todos: todos, page: 1));
      }
    } catch (e) {
      emit(ErrorTodoState(message: e.toString()));
    }
  }

  Future<void> _updateTodoEvent(UpdateTodoEvent event, emit) async {
    emit(ListLoadingTodoState(todos: event.todos, page: event.page));
    try {
      final newTodos = await todoService.fetchTodo(page: event.page, perPage: event.perPage);
      if (newTodos.isEmpty) {
        emit(FinishLoadedState(todos: event.todos, page: event.page + 1));
      } else {
        emit(SuccessTodoState(todos: newTodos, page: event.page + 1));
      }
    } catch (e) {
      emit(ErrorTodoState(message: e.toString()));
    }
  }
}
