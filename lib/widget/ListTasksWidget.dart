

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/TaskModel.dart';

class Listtaskswidget extends StatelessWidget {
  const Listtaskswidget({super.key});

  @override
  Widget build(BuildContext context) {
    return  Consumer<TaskModel>(
        builder: (context, model , child) {
          return ListView.builder(
        itemCount: model.todoTasks.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.blue,
                  border: Border.all(),
                  borderRadius: BorderRadius.circular(10)

              ),

              child: CheckboxListTile(
                title: Text(model.todoTasks[index].title),
                subtitle: Text(model.todoTasks[index].deadline.toString()),
                value: model.todoTasks[index].status,
                onChanged: (bool? value) {

                  value: model.markAsDone(index);
                  print(model.todoTasks[index].status);

                },
                controlAffinity: ListTileControlAffinity.leading,

              ),
            ),
          );


        },

      );
    }
    );
  }
}
