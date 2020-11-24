import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:todo_list/todos_db.dart';
import 'package:timeago/timeago.dart' as timeago;
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:date_time_picker/date_time_picker.dart';

class TodoCard extends StatelessWidget {
  final DocumentSnapshot documentSnapshot;

  TodoCard({this.documentSnapshot});

  TodoDb todoDbInstance = TodoDb();

  TextEditingController editTodoTitleTextController = TextEditingController();

  bool _validate = false;

  DateTime deadline = DateTime.now();

  @override
  Widget build(BuildContext context) {
    editTodoTitleTextController.text = documentSnapshot["todoTitle"];
    deadline = DateTime.parse(documentSnapshot["deadline"]);
    return Card(
        color: Colors.orange,
        elevation: 4,
        margin: EdgeInsets.all(8),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  flex: 10,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: Text("Task: "),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              documentSnapshot["todoTitle"],
                              style: TextStyle(
                                fontSize: 18.0,
                              ),
                            ),
                          )
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Created: "),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 2,
                            child: Text(
                              timeago.format(DateTime.now().subtract(
                                  DateTime.now().difference(DateTime.parse(
                                      documentSnapshot["createdAt"])))),
                              style: TextStyle(
                                  fontSize: 12.0, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(
                        height: 10.0,
                      ),
                      Row(
                        children: [
                          Expanded(
                            child: Text("Time left: "),
                          ),
                          SizedBox(
                            width: 10.0,
                          ),
                          Expanded(
                            flex: 2,
                            child: CountdownTimer(
                              endTime:
                                  DateTime.parse(documentSnapshot["deadline"])
                                      .millisecondsSinceEpoch,
                              widgetBuilder: (BuildContext context,
                                  CurrentRemainingTime time) {
                                if (time == null) {
                                  return Text('Time over');
                                }
                                List<Widget> list = [];
                                if (time.days != null) {
                                  list.add(Row(
                                    children: <Widget>[
                                      Icon(Icons.sentiment_dissatisfied),
                                      Text(time.days.toString()),
                                    ],
                                  ));
                                }
                                if (time.hours != null) {
                                  list.add(Row(
                                    children: <Widget>[
                                      Icon(Icons.sentiment_satisfied),
                                      Text(time.hours.toString()),
                                    ],
                                  ));
                                }
                                if (time.min != null) {
                                  list.add(Row(
                                    children: <Widget>[
                                      Icon(Icons.sentiment_very_dissatisfied),
                                      Text(time.min.toString()),
                                    ],
                                  ));
                                }
                                if (time.sec != null) {
                                  list.add(Row(
                                    children: <Widget>[
                                      Icon(Icons.sentiment_very_satisfied),
                                      Text(time.sec.toString()),
                                    ],
                                  ));
                                }

                                return Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: list,
                                );
                              },
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),


                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          icon: Icon(Icons.edit),
                          color: Colors.blueGrey,
                          onPressed: () {
                            showDialog(
                                context: context,
                                builder: (BuildContext context) {
                                  return AlertDialog(
                                    shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(8)),
                                    title: Text("Edit Todolist"),
                                    content: Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          TextField(
                                            controller:
                                                editTodoTitleTextController,
                                            decoration: InputDecoration(
                                              labelText: 'Enter todo task',
                                              errorText: _validate
                                                  ? 'Task Can\'t Be Empty'
                                                  : null,
                                            ),
                                          ),
                                          DateTimePicker(
                                            type: DateTimePickerType
                                                .dateTimeSeparate,
                                            dateMask: 'd MMM, yyyy',
                                            initialValue:
                                                documentSnapshot["deadline"],
                                            firstDate: DateTime(2000),
                                            lastDate: DateTime(2100),
                                            icon: Icon(Icons.event),
                                            dateLabelText: 'Date',
                                            timeLabelText: "Time",
                                            selectableDayPredicate: (date) {
                                              final now = DateTime.now();
                                              final yesterday = DateTime(
                                                  now.year,
                                                  now.month,
                                                  now.day - 1);
                                              if (date.isAfter(yesterday)) {
                                                return true;
                                              }

                                              return false;
                                            },
                                            onChanged: (val) {
                                              if (DateTime.parse(val)
                                                  .isAfter(DateTime.now())) {
                                                print("Correct");
                                                deadline = DateTime.parse(val);
                                              } else {
                                                print("Incorrect");
                                                deadline = DateTime.now();
                                              }
                                              print(val);
                                            },
                                            validator: (val) {
                                              print(val);
                                              return null;
                                            },
                                            onSaved: (val) {

                                            },
                                          )
                                        ]),
                                    actions: [
                                      FlatButton(
                                        onPressed: () {
                                          if (editTodoTitleTextController
                                                  .text.isEmpty ||
                                              deadline == DateTime.now()) {
                                            _validate = true;
                                          } else {
                                            _validate = false;
                                            TodoDb todoDbInstance = TodoDb(
                                                todoTitle:
                                                    editTodoTitleTextController
                                                        .text,
                                                deadline: deadline);
                                            todoDbInstance
                                                .updateTodos(documentSnapshot);
                                            Navigator.of(context).pop();
                                          }
                                        },
                                        child: Text("Update"),
                                      )
                                    ],
                                  );
                                });
                          }),
                      IconButton(
                        icon: Icon(Icons.delete),
                        color: Colors.red,
                        onPressed: () {
                          todoDbInstance.deleteTodos(documentSnapshot);
                        },
                      ),
                    ],
                  ),
                )
              ],
            )));
  }
}
