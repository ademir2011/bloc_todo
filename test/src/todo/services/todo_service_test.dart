import 'package:bloc_test/bloc_test.dart';
import 'package:dio/dio.dart';
import 'package:dio/native_imp.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:todo_bloc/src/todo/bloc/todo_bloc.dart';
import 'package:todo_bloc/src/todo/bloc/todo_event.dart';
import 'package:todo_bloc/src/todo/bloc/todo_state.dart';
import 'package:todo_bloc/src/todo/datasources/dio_fetch_datasource.dart';
import 'package:todo_bloc/src/todo/repositories/todo_repository.dart';
import 'package:todo_bloc/src/todo/services/todo_service.dart';
import 'package:todo_bloc/src/utils/check_internet_util.dart';

class CheckInternetUtilMock extends Mock implements CheckInternetUtil {}

class DioFetchDatasourceMock extends Mock implements DioFetchDatasource {}

class TodoServiceMock extends Mock implements TodoService {}

class DioMock extends Mock implements DioForNative {}

class ResponseMock extends Mock implements Response {}

void main() {
  blocTest<TodoBloc, TodoState>(
    'Espera retornar todos os itens',
    build: () {
      final checkInternetUtilMock = CheckInternetUtilMock();
      when(() => checkInternetUtilMock.hasNetwork()).thenAnswer((_) async => true);

      return TodoBloc(
        TodoService(
          TodoRepository(
            DioFetchDatasource(
              Dio(),
            ),
            checkInternetUtilMock,
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(FetchTodoEvent()),
    wait: const Duration(seconds: 10),
    expect: () => [
      isA<LoadingTodoState>(),
      isA<SuccessTodoState>(),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'Espera retornar o estado inicial sem itens',
    build: () {
      final dioMock = DioMock();
      final responseMock = ResponseMock();

      when(() => responseMock.data).thenReturn([]);

      when(() => dioMock.get(any())).thenAnswer((_) async => responseMock);

      return TodoBloc(
        TodoService(
          TodoRepository(
            DioFetchDatasource(dioMock),
            CheckInternetUtil(),
          ),
        ),
      );
    },
    act: (bloc) => bloc.add(FetchTodoEvent()),
    wait: const Duration(seconds: 1),
    expect: () => [
      isA<LoadingTodoState>(),
      isA<InitialTodoState>(),
    ],
  );

  blocTest<TodoBloc, TodoState>(
    'Espera retornar um erro',
    build: () {
      final todoServiceMock = TodoServiceMock();
      when(() => todoServiceMock.fetchTodo(page: 1, perPage: 10)).thenThrow(Exception);

      return TodoBloc(todoServiceMock);
    },
    act: (bloc) => bloc.add(FetchTodoEvent()),
    expect: () => [
      isA<LoadingTodoState>(),
      isA<ErrorTodoState>(),
    ],
  );
}
