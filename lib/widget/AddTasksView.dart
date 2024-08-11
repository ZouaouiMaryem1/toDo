import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do/library/globals.dart' as globals;
import 'package:to_do/model/Task.dart';

import '../provider/TaskModel.dart';

class AddTasksView extends StatefulWidget {
  const AddTasksView({super.key});

  @override
  State<AddTasksView> createState() => _AddTasksViewState();
}

class _AddTasksViewState extends State<AddTasksView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Consumer<TaskModel>(builder: (context, model, child) {
      return Scaffold(
        appBar: AppBar(
          title: Text("Add new Task"),
        ),
        body: SingleChildScrollView(
          child: Builder(builder: (context) {
            return Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10.0),
                child: Column(children: <Widget>[
                  TableCalendar(
                    calendarFormat: CalendarFormat.week,
                    firstDay: DateTime.utc(2024, 08, 04),
                    lastDay: DateTime.utc(2030, 01, 01),
                    focusedDay: _focusedDay,
                    selectedDayPredicate: (day) {
                      return isSameDay(_selectedDay, day);
                    },
                    onDaySelected: (selectedDay, focusedDay) {
                      setState(() {
                        _selectedDay = selectedDay;
                        _focusedDay =
                            focusedDay; // update `_focusedDay` here as well
                      });
                    },
                    onPageChanged: (focusedDay) {
                      _focusedDay = focusedDay;
                    },
                    calendarBuilders: CalendarBuilders(
                        markerBuilder: (context, datetime, events) {
                      return model.countTasksByDate(datetime)>0 ?Container(
                        width: 20,
                        height:18,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(4.0),
                          color: globals.primaries[model.countTasksByDate(datetime)],
                        ),
                        child: Center(
                          child: Text(
                            model.countTasksByDate(datetime).toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ): Container();
                    }, selectedBuilder: (context, _datetime, focusedDay) {
                      return Container(
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(4.0),
                            color: Colors.blue),
                        margin: EdgeInsets.symmetric(
                            vertical: 4.0, horizontal: 10.0),
                        child: Center(
                          child: Text(
                            _datetime.day.toString(),
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      );
                    }),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: TextFormField(
                      controller: _titleController,
                      maxLength: 100,
                      decoration: InputDecoration(
                        hintText: "Enter Task title",
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.blue, width: 2.0)),
                        errorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0)),
                        focusedErrorBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5.0),
                            borderSide:
                                BorderSide(color: Colors.red, width: 2.0)),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter some title';
                        }
                        return null;
                      },
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    maxLength: 500,
                    maxLines: 5,
                    minLines: 3,
                    decoration: InputDecoration(
                      hintText: "Enter Task description (optional)",
                      focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0)),
                      enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              BorderSide(color: Colors.blue, width: 2.0)),
                      errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5.0),
                          borderSide:
                              BorderSide(color: Colors.red, width: 2.0)),
                    ),
                  ),
                ]),
              ),
            );
          }),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.done),
          onPressed: () {
            if (_formKey.currentState!.validate()) {
              Task _newTask = Task(_titleController.text, false,
                  _descriptionController.text, _focusedDay);
              model.add(_newTask);

              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Task saved !')),
              );
              Navigator.pushReplacementNamed(context, 'listTasks');
            }
          },
        ),
      );
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
