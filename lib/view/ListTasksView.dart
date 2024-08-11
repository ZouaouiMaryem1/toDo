import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:to_do/provider/TaskModel.dart';
import 'package:to_do/library/globals.dart' as globals;

import '../widget/ListAllTasksWidget.dart';
import '../widget/ListTasksByTabWidget.dart';

class Listtasksview extends StatefulWidget {
  const Listtasksview({super.key});

  @override
  State<Listtasksview> createState() => _ListtasksviewState();
}

class _ListtasksviewState extends State<Listtasksview> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        appBar: AppBar(
          title: Text("List Tasks"),
          bottom: const TabBar(
            isScrollable: true,
            tabs: [
              Tab(text: "All"),
              Tab(text: "Today"),
              Tab(text: "Tomorrow"),
              Tab(text: "This week"),
              Tab(text: "Next week"),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            ListAllTasksWidget(),
            ListtasksByTabwidget(tabkey: globals.today),
            ListtasksByTabwidget(tabkey: globals.tomorrow),
            ListtasksByTabwidget(tabkey: globals.thisWeek),
            ListtasksByTabwidget(tabkey: globals.thisMonth),



          ],
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            Navigator.pushNamed(context, 'addTask');
          },
        ),
      ),
    );
  }
}
