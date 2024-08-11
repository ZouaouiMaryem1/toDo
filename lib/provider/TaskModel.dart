import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:to_do/model/Task.dart';
import 'package:to_do/library/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  final Map<String, List<Task>> _todoTasks = {
    globals.late: [],
    globals.today: [],
    globals.tomorrow: [],
    globals.thisWeek: [],
    globals.nextWeek: [],
    globals.thisMonth: [],
    globals.later: [],
  };
  Map<String, List<Task>> get todoTasks => _todoTasks;
  void add(Task _task) {
    String _key = guessTodokeyFromDate(_task.deadline);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!.add((_task));
      addTaskToCache(_task);
      notifyListeners();
    }
  }

  void markAsDone(
    String key,
    int index,
  ) {
    _todoTasks[key]![index].status = true;
    notifyListeners();
  }

  int countTasksByDate(DateTime _datetime) {
    String _key = guessTodokeyFromDate(_datetime);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!
          .where((task) =>
              task.deadline.day == _datetime.day &&
              task.deadline.month == _datetime.month &&
              task.deadline.year == _datetime.year)
          .length;
    }
    return 0;
  }

  String guessTodokeyFromDate(DateTime deadline) {
    if (deadline.isPast && !deadline.isToday) {
      return globals.late;
    } else if (deadline.isToday) {
      return globals.today;
    } else if (deadline.isTomorrow) {
      return globals.tomorrow;
    } else if (deadline.getWeek == DateTime.now().getWeek &&
        deadline.year == DateTime.now().year) {
      return globals.thisWeek;
    } else if (deadline.getWeek == DateTime.now().getWeek + 1 &&
        deadline.year == DateTime.now().year) {
      return globals.nextWeek;
    } else if (deadline.isThisMonth) {
      return globals.thisMonth;
    } else {
      return globals.later;
    }
  }

  void addTaskToCache(Task _task) async {
    // Obtain shared preferences.
    final prefs = await SharedPreferences.getInstance();
    List<Task> _tasksList = [];
    if (prefs.containsKey(globals.todo_tasks)) ;
    {
      final String? data = prefs.getString(globals.todo_tasks);
      List<dynamic> _oldTasks = jsonDecode(data!);
      _tasksList =
          List<Task>.from(_oldTasks.map((element) => Task.fromJson(element)));
      print(_oldTasks);
    }
    _tasksList.add(_task);

    await prefs.setString(globals.todo_tasks, jsonEncode(_tasksList));
  }

  void syncDoneTaskToCache(Task _task) async {
    //Retrieve all todoTasks from cache
    // remove todoTask from prefs
    //update todoTask cache

    //Retrieve all doneTasks from cache
    // remove doneTask from prefs
    //update doneTask cache
  }
}
