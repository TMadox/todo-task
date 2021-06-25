import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/flutter_swipe_action_cell.dart';
import 'package:get/get.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:todo/Components/CustomTextField.dart';
import 'package:todo/Components/SwipActionCell.dart';
import 'package:todo/Logic/FirebaseLogic.dart';
import 'package:todo/Logic/ScreenSize.dart';
import 'package:todo/Logic/StateManagement.dart';
import 'package:todo/Models/TodoModel.dart';
import 'package:data_connection_checker/data_connection_checker.dart';

class TodoPage extends StatefulWidget {
  @override
  _TodoPageState createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  String title;
  String description;
  DataConnectionStatus connection;
  List<TodoModel> templst = [];
  GlobalKey<FormState> _gkey = GlobalKey<FormState>();
  @override
  void initState() {
    super.initState();
    DataConnectionChecker().onStatusChange.listen((event) {
      setState(() {
        // context.read(generalmanagment).syncdata();
        connection = event;
        print(connection);
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Todo App"),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Consumer(
        builder: (context, watch, child) => Container(
          child: connection == DataConnectionStatus.connected
              ? FutureBuilder(
                  future: FirebaseFirestore.instance.collection("todos").get(),
                  builder: (context, snapshot) {
                    if (snapshot.hasData) {
                      return ListView.builder(
                          itemCount: snapshot.data.docs.length,
                          itemBuilder: (context, index) {
                            return swipeActionCell(
                                connectionstate: connection,
                                item: snapshot.data.docs[index].data(),
                                ondone: () {
                                  FirebaseAPI.removedata(
                                      snapshot.data.docs[index].id);
                                });
                          });
                    } else {
                      return Center(
                          child: CircularProgressIndicator(
                        backgroundColor: Colors.purple,
                      ));
                    }
                  })
              : ListView.builder(
                  itemCount: watch(generalmanagment).todolist.length,
                  itemBuilder: (context, index) {
                    print("connection");
                    return Card(
                        child: swipeActionCell(
                            connectionstate: connection,
                            item: watch(generalmanagment).todolist[index],
                            ondone: () {
                              watch(generalmanagment).removefromlist(
                                  watch(generalmanagment).todolist[index]);
                            }));
                  }),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.purple,
        onPressed: () {
          Get.defaultDialog(
              title: "New Task",
              content: Form(
                key: _gkey,
                child: Column(
                  children: [
                    CustomTextField(
                      hintext: "Title",
                      onsubmit: (text) {
                        title = text;
                      },
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.01,
                    ),
                    CustomTextField(
                      onsubmit: (text) {
                        description = text;
                      },
                      hintext: "Description",
                    ),
                    SizedBox(
                      height: screenHeight(context) * 0.03,
                    ),
                    ElevatedButton(
                      onPressed: () async {
                        if (_gkey.currentState.validate()) {
                          _gkey.currentState.save();
                          bool isconnected =
                              await DataConnectionChecker().hasConnection;
                          if (isconnected) {
                            if (!Platform.isWindows) {
                              FirebaseAPI.adddata(title, description);
                              setState(() {});
                            } else {
                              FirebaseAPI.sendData(title, description);
                              setState(() {});
                            }
                          } else {
                            context.read(generalmanagment).addtodotask(
                                TodoModel(
                                    description, title, DateTime.now(), false));
                          }
                          _gkey.currentState.reset();
                        }
                      },
                      child: Text("Add"),
                      style: ElevatedButton.styleFrom(primary: Colors.purple),
                    )
                  ],
                ),
              ));
        },
        child: Icon(Icons.add),
      ),
    );
  }
}
