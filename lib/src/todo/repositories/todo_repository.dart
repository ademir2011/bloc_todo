import 'dart:io';

import 'package:todo_bloc/src/todo/datasources/dio_fetch_datasource.dart';
import 'package:todo_bloc/src/todo/models/todo_model.dart';
import 'package:todo_bloc/src/utils/check_internet_util.dart';

class TodoRepository {
  final DioFetchDatasource dioFetchDatasource;
  final CheckInternetUtil checkInternetUtil;

  TodoRepository(
    this.dioFetchDatasource,
    this.checkInternetUtil,
  );

  Future<List<TodoModel>> fetchTodo({required int page, required int perPage}) async {
    if (await checkInternetUtil.hasNetwork()) {
      return await dioFetchDatasource.fetchTodo(page: page, perPage: perPage);
    } else {
      return throw Exception();
    }
  }
}
