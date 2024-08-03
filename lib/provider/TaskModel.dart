import 'package:flutter/material.dart';
import 'package:to_do/model/Task.dart';

class CartModel extends ChangeNotifier {

  final List<Task> _todoTasks = [
    Task("Task1", false , "create Provider", DateTime.now().add(Duration(days: 1))),
    Task("Task1", false , "create Provider", DateTime.now().add(Duration(days: 2))),
    Task("Task1", false , "create Provider", DateTime.now().add(Duration(days: 7))),
    Task("Task1", false , "create Provider", DateTime.now().add(Duration(days: 8))),



  ];

  List<Task> get todoTasks => _todoTasks;

}