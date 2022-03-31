import 'dart:async';
import 'dart:math';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:todo_bloc/src/todo/bloc/todo_bloc.dart';
import 'package:todo_bloc/src/todo/bloc/todo_event.dart';
import 'package:todo_bloc/src/todo/bloc/todo_state.dart';
import 'package:todo_bloc/src/todo/datasources/dio_fetch_datasource.dart';
import 'package:todo_bloc/src/todo/repositories/todo_repository.dart';
import 'package:todo_bloc/src/todo/services/todo_service.dart';
import 'package:todo_bloc/src/todo/widgets/todo_listview_widget.dart';
import 'package:todo_bloc/src/utils/check_internet_util.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({Key? key}) : super(key: key);

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  late StreamSubscription sub;
  final bloc = TodoBloc(TodoService(TodoRepository(DioFetchDatasource(Dio()), CheckInternetUtil())));

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    sub = bloc.stream.listen((event) {
      setState(() {});
    });

    WidgetsBinding.instance?.addPostFrameCallback((timeStamp) {
      bloc.add(FetchTodoEvent());
    });
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    sub.cancel();
  }

  Widget body = Container();

  @override
  Widget build(BuildContext context) {
    final state = bloc.state;

    if (state is InitialTodoState) {
      body = const Center(
        child: Text('nada'),
      );
    }

    if (state is LoadingTodoState) {
      body = const Center(child: CircularProgressIndicator());
    }

    if (state is ListLoadingTodoState) {
      body = TodoListViewWidget(
        itens: state.todos,
      );
    }

    if (state is FinishLoadedState) {
      body = TodoListViewWidget(
        itens: state.todos,
        isFinish: true,
      );
    }

    if (state is SuccessTodoState) {
      body = TodoListViewWidget(
        itens: state.todos,
        shootEvent: () {
          bloc.add(UpdateTodoEvent(todos: state.todos, page: state.page));
        },
      );
    }

    if (state is ErrorTodoState) {
      body = const Center(
        child: Text('Houve um erro, favor recarregar a página.'),
      );
    }

    return Scaffold(
      appBar: AppBar(
        actions: [
          IconButton(
            onPressed: () {
              bloc.add(FetchTodoEvent());
            },
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: body,
    );
  }
}
