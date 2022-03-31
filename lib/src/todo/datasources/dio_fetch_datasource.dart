import 'package:dio/dio.dart';
import 'package:todo_bloc/src/todo/models/todo_model.dart';

class DioFetchDatasource {
  final Dio dio;
  final _todos = <TodoModel>[];

  DioFetchDatasource(this.dio);

  Future<List<TodoModel>> fetchTodo({required int page, required int perPage}) async {
    final response = await dio.get('https://www.intoxianime.com/?rest_route=/wp/v2/posts&page=$page&per_page=$perPage');

    final todosMap = response.data as List;
    _todos.addAll(todosMap
        .map((map) => TodoModel(id: map['id'].toString(), check: false, title: map['title']['rendered']))
        .toList());

    return _todos;
  }
}
