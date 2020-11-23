import 'package:cloud_firestore/cloud_firestore.dart';

class TodoDb {
  String todoTitle = "";

  DateTime deadline = DateTime.now();

  TodoDb({this.todoTitle, this.deadline});

  createTodos() {
    var id = FirebaseFirestore.instance.collection("MyTodos").doc().id;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc("Todo $id");

    Map<String, String> todos = {
      "todoTitle": todoTitle,
      "createdAt": DateTime.now().toString(),
      "deadline": deadline.toString()
    };

    documentReference
        .set(todos)
        .whenComplete(() => print("Todo $id with title $todoTitle created"));
  }

  deleteTodos(documentSnapshot) {
    var id = documentSnapshot.id;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(id);

    documentReference.delete().whenComplete(() => print("$id deleted"));
  }

  updateTodos(documentSnapshot) {
    var id = documentSnapshot.id;

    DocumentReference documentReference =
        FirebaseFirestore.instance.collection("MyTodos").doc(id);

    Map<String, String> todos = {
      "todoTitle": todoTitle,
      "createdAt": documentSnapshot["createdAt"],
      "deadline": deadline.toString()
    };

    documentReference.update(todos).whenComplete(() => print(
        "${documentSnapshot["todoTitle"]} updated to $todoTitle and ${documentSnapshot["deadline"]} updated to $deadline"));
  }
}
