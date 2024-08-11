import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/TaskModel.dart';
import 'package:to_do/library/globals.dart' as globals;

class ListtasksByTabwidget extends StatelessWidget {
  final String tabkey;
  const ListtasksByTabwidget({Key? key, required this.tabkey}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return Padding(
        padding: const EdgeInsets.all(8.0),
        child: ListView.builder(
          itemCount: model.todoTasks[tabkey]!.length,
          itemBuilder: (BuildContext context, int index) {
            return Padding(
              padding: const EdgeInsets.symmetric(vertical: 4.0),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.blue,
                      border: Border.all(),
                      borderRadius: BorderRadius.circular(10)),
                  child: ListTile(
                    contentPadding: EdgeInsets.zero,
                    title: Text(model.todoTasks[tabkey]![index].title),
                    subtitle: Text(
                        model.todoTasks[tabkey]![index].deadline.toString()),
                    leading: Checkbox(
                      value: model.todoTasks[tabkey]![index].status,
                      onChanged: (bool? value) {
                        value:
                        model.markAsDone(tabkey, index);
                        print(model.todoTasks[tabkey]![index].status);
                      },
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      );
    });
  }
}
