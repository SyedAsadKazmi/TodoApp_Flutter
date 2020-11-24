import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:todo_list/todos_db.dart';
import 'package:todo_list/todo_card.dart';
import 'package:date_time_picker/date_time_picker.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData.light(),
    darkTheme: ThemeData.dark(),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  TodoDb todoDbInstance = TodoDb();

  TextEditingController addTodoTitleTextController = TextEditingController();

  DateTime deadline = DateTime.now();

  bool _validate = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text("My Todos"),
          centerTitle: true,
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            addTodoTitleTextController.text = "";
            deadline = DateTime.now();
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    title: Text("Add Todolist"),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          controller: addTodoTitleTextController,
                          decoration: InputDecoration(
                            labelText: 'Enter todo task',
                            errorText:
                                _validate ? 'Task Can\'t Be Empty' : null,
                          ),
                        ),
                        DateTimePicker(
                          type: DateTimePickerType.dateTimeSeparate,
                          dateMask: 'd MMM, yyyy',
                          initialValue: DateTime.now().toString(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2100),
                          icon: Icon(Icons.event),
                          dateLabelText: 'Date',
                          timeLabelText: "Time",
                          selectableDayPredicate: (date) {
                            final now = DateTime.now();
                            final yesterday =
                                DateTime(now.year, now.month, now.day - 1);
                            if (date.isAfter(yesterday)) {
                              return true;
                            }

                            return false;
                          },
                          onChanged: (val) {
                            if (DateTime.parse(val).isAfter(DateTime.now())) {
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
                      ],
                    ),
                    actions: [
                      FlatButton(
                        onPressed: () {
                          print(_validate);

                          if (addTodoTitleTextController.text.isEmpty ||
                              deadline == DateTime.now()) {
                            _validate = true;
                          } else {
                            _validate = false;
                            TodoDb todoDbInstance = TodoDb(
                                todoTitle: addTodoTitleTextController.text,
                                deadline: deadline);

                            todoDbInstance.createTodos();

                            Navigator.of(context).pop();
                          }
                        },
                        child: Text("Add"),
                      )
                    ],
                  );
                });
          },
          child: Icon(
            Icons.add,
            color: Colors.white,
          ),
        ),
        body: StreamBuilder(
            stream: FirebaseFirestore.instance
                .collection("MyTodos")
                .orderBy('createdAt', descending: false)
                .snapshots(),
            builder: (context, snapshots) {
              return ListView.builder(
                  shrinkWrap: true,
                  itemCount: snapshots.data.documents.length,
                  itemBuilder: (context, index) {
                    DocumentSnapshot documentSnapshot =
                        snapshots.data.documents[index];

                    return Dismissible(
                        onDismissed: (direction) {
                          todoDbInstance.deleteTodos(documentSnapshot);
                        },
                        key: UniqueKey(),
                        child: TodoCard(
                          documentSnapshot: documentSnapshot,
                        ));
                  });
            }));
  }
}
