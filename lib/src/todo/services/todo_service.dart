import 'package:todo_bloc/src/todo/models/todo_model.dart';
import 'package:todo_bloc/src/todo/repositories/todo_repository.dart';

class TodoService {
  final TodoRepository todoRepository;

  TodoService(this.todoRepository);

  Future<List<TodoModel>> fetchTodo({required int page, required int perPage}) async {
    return await todoRepository.fetchTodo(page: page, perPage: perPage);
  }
}
