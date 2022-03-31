import 'package:flutter/material.dart';

class TodoListViewWidget extends StatelessWidget {
  final List<dynamic> itens;
  final Function()? shootEvent;
  final bool isFinish;

  const TodoListViewWidget({
    Key? key,
    required this.itens,
    this.shootEvent,
    this.isFinish = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: itens.length + 1,
      itemBuilder: (ctx, index) {
        if (index < itens.length) {
          return Card(
            margin: const EdgeInsets.all(15),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('${index + 1} - ${itens[index].title}'),
            ),
          );
        } else {
          if (isFinish) {
            return const Text('Não há mais itens.');
          }

          if (shootEvent != null) {
            shootEvent!();
          }

          return const Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
