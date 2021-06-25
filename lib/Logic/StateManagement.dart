import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/Models/TodoModel.dart';

final generalmanagment = ChangeNotifierProvider<General>((ref) => General());

class General extends ChangeNotifier {
  List<TodoModel> todolist = [];

  void addtodotask(TodoModel task) {
    todolist.add(task);
    notifyListeners();
  }

  void removefromlist(var task) {
    todolist.remove(task);
    notifyListeners();
  }

  void syncdata() {
    for (TodoModel i in todolist)
      FirebaseFirestore.instance
          .collection("todos")
          .doc(DateTime.now().toString())
          .set({
        "Title": i.title,
        "Description": i.description,
        "CreationDate": i.creationdate,
        "isDone": i.isdone
      });
  }
}
