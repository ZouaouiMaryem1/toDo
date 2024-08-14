import 'dart:convert';

import 'package:dart_date/dart_date.dart';
import 'package:flutter/material.dart';
import 'package:to_do/model/Task.dart';
import 'package:to_do/library/globals.dart' as globals;
import 'package:shared_preferences/shared_preferences.dart';

class TaskModel extends ChangeNotifier {
  TaskModel(){
    initState();
  }
  void initState(){
    loadTasksFromCache();
  }
  List<Task> _doneTasks =[];

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
  List<Task> get doneTasks => _doneTasks;
  void add(Task _task) {
    print("id:"+_task.id);
    String _key = guessTodokeyFromDate(_task.deadline);
    if (_todoTasks.containsKey(_key)) {
      _todoTasks[_key]!.add((_task));
      addTaskToCache(_task);
      notifyListeners();
    }
  }

  void markAsChecked(
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
  void markAsDone(String key , int index){
    _doneTasks.add(_todoTasks[key]![index]);
    _todoTasks[key]!.removeAt(index);
    print("done tasks"+ _doneTasks.map((task)=>task.title).toString());

  notifyListeners();
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

    // Vérifiez si la clé existe dans SharedPreferences
    if (prefs.containsKey(globals.todo_tasks)) {
      final String? data = prefs.getString(globals.todo_tasks);

      // Vérifiez si les données récupérées ne sont pas nulles
      if (data != null) {
        List<dynamic> _oldTasks = jsonDecode(data);
        _tasksList = List<Task>.from(
            _oldTasks.map((element) => Task.fromJson(element))
        );
        print(_oldTasks);
      }
    }

    // Ajouter la nouvelle tâche à la liste
    _tasksList.add(_task);

    // Sauvegarder la liste mise à jour dans SharedPreferences
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
  loadTasksFromCache() async {
    final prefs = await SharedPreferences.getInstance();

    // Vérifiez si la clé existe dans SharedPreferences
    if (prefs.containsKey(globals.todo_tasks)) {
      final String? data = prefs.getString(globals.todo_tasks);

      // Vérifiez si les données récupérées ne sont pas nulles
      if (data != null) {
        List<dynamic> _oldTasks = jsonDecode(data);
        List<Task> _tasksList = List<Task>.from(
            _oldTasks.map((element) => Task.fromJson(element))
        );

        for (int i = 0; i < _tasksList.length; i++) {
          add(_tasksList[i]);
        }
      } else {
        // Gérer le cas où les données sont nulles
        print("Les données des tâches sont nulles");
      }
    } else {
      // Gérer le cas où la clé n'existe pas
      print("Aucune tâche enregistrée trouvée");
    }
  }

}
