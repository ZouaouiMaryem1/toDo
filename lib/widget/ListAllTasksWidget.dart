import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../provider/TaskModel.dart';
import 'package:to_do/library/globals.dart' as globals;

class ListAllTasksWidget extends StatelessWidget {
  const ListAllTasksWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return ListView.builder(
        itemCount: model.todoTasks.length,
        itemBuilder: (BuildContext context, int index) {
          String key = model.todoTasks.keys.elementAt(index);
          print('Key: $key'); // Debug print to check the key

          if (globals.taskCategoryNames == null) {
            print('globals.taskCategoryNames is null');
            return SizedBox.shrink(); // Return an empty widget if null
          }

          if (!globals.taskCategoryNames.containsKey(key)) {
            print('Key $key not found in globals.taskCategoryNames');
            return SizedBox.shrink(); // Return an empty widget if key not found
          }

          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    globals.taskCategoryNames[key]!,
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                  ),
                ),
                ListView.builder(
                  shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: model.todoTasks[key]!.length,
                  itemBuilder: (BuildContext context, int index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4.0),
                      child: Container(
                        decoration: BoxDecoration(
                          color: Colors.blue,
                          border: Border.all(),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: ListTile(
                            contentPadding: EdgeInsets.zero,
                          title: Text(model.todoTasks[key]![index].title),
                          subtitle: Text(model.todoTasks[key]![index].deadline.toString()),
                          leading: Checkbox(
                            value: model.todoTasks[key]![index].status,
                            onChanged: (bool? value) {
                              model.markAsChecked(key, index);
                              model.markAsDone(key, index);

                              print(model.todoTasks[key]![index].status);
                            },

                          ),


                        ),
                      ),
                    );
                  },
                )
              ],
            ),
          );
        },
      );
    });
  }
}
