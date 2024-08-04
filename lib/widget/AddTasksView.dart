import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:to_do/library/globals.dart' as globals;

class AddTasksView extends StatefulWidget {
  const AddTasksView({super.key});

  @override
  State<AddTasksView> createState() => _AddTasksViewState();
}

class _AddTasksViewState extends State<AddTasksView> {
  DateTime _selectedDay = DateTime.now();
  DateTime _focusedDay = DateTime.now();
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add new Task"),
      ),
      body: Form(
        key: _formKey,
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
                _focusedDay = focusedDay; // update `_focusedDay` here as well
              });
            },
            onPageChanged: (focusedDay) {
              _focusedDay = focusedDay;
            },
            calendarBuilders: CalendarBuilders(
             markerBuilder: (context,datetime,events){
               return  Container(
                 width: 20,
                 height: 15 ,
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4.0),
                   color: globals.primaries[1],
                 ),
               );
             },
             selectedBuilder:(context, _datetime,focusedDay) {
               return Container(
                 decoration: BoxDecoration(
                   borderRadius: BorderRadius.circular(4.0),
                   color: Colors.blue
                 ),
                 margin: EdgeInsets.symmetric(vertical: 4.0,horizontal: 10.0),
                 child: Center(
                   child: Text(_datetime.day.toString(),style: TextStyle(color: Colors.white),),
                 ),
               );
             }
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
                if (value == null || value.isEmpty) {
                  return 'Please enter some text';
                }
                return null;
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              validator: (value) {
              },
            ),
          ),
        ]),
      ),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.done),
        onPressed: (){
          if (_formKey.currentState!.validate()) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Processing Data')),
            );
          }
        } ,
      ),
    );
  }
}
