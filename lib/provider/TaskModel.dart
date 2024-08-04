import 'package:flutter/material.dart';
import 'package:to_do/model/Task.dart';

class TaskModel extends ChangeNotifier {

  final List<Task> _todoTasks = [
    Task("Task1", false , "create Provider", DateTime.now().add(Duration(days: 1))),
    Task("Task2", false , "create Provider", DateTime.now().add(Duration(days: 2))),
    Task("Task3", false , "create Provider", DateTime.now().add(Duration(days: 7))),
    Task("Task4", false , "create Provider", DateTime.now().add(Duration(days: 8))),



  ];
  void markAsDone(int index, ){
    _todoTasks[index].status=true;
    notifyListeners();
  }

  List<Task> get todoTasks => _todoTasks;

}