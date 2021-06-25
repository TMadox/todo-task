import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:riverpod/riverpod.dart';
import 'package:todo/Models/TodoModel.dart';

class FirebaseAPI {
  static Future retrievedata() async {
    //test trial
    final List<TodoModel> todolistwindows = [];
    final response = await http.get(Uri.parse(
        "https://todo-63b4b-default-rtdb.firebaseio.com/userprofile.json"));
    final extractedData = json.decode(response.body) as Map<String, dynamic>;
    extractedData.forEach((profileId, todoitem) {
      todolistwindows.add(TodoModel(todoitem["Description"], todoitem["Title"],
          todoitem["CreationDate"], todoitem["isDone"]));
    });
    var todolistandroid =
        await FirebaseFirestore.instance.collection("todos").get();
    print("object");
    if (Platform.isWindows) {
      print("object");
      return todolistwindows;
    } else {
      // print(todolistandroid.docs);
      return todolistandroid;
    }
  }

  static Future<QuerySnapshot> adddata(String title, String description) async {
    FirebaseFirestore.instance
        .collection("todos")
        .doc(DateTime.now().toString())
        .set({
      "Title": title,
      "Description": description,
      "CreationDate": DateTime.now()
    });
  }

  static removedata(String docpath) {
    FirebaseFirestore.instance.collection("todos").doc(docpath).delete();
  }

  static sendData(String title, String description) {
    http.post(
        Uri.parse(
            "https://todo-63b4b-default-rtdb.firebaseio.com/userprofile.json"),
        body: json.encode({
          'Title': title,
          'Description': description,
          "CreationDate": DateTime.now().toString(),
        }));
  }
}
