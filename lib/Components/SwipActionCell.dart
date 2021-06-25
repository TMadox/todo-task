import 'package:connectivity/connectivity.dart';
import 'package:data_connection_checker/data_connection_checker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_swipe_action_cell/core/cell.dart';

Widget swipeActionCell(
        {var item,
        Function ondelete,
        Function ondone,
        DataConnectionStatus connectionstate}) =>
    SwipeActionCell(
      key: ObjectKey(item),
      performsFirstActionWithFullSwipe: true,
      trailingActions: <SwipeAction>[
        SwipeAction(
            title: "Delete",
            onTap: (CompletionHandler handler) async {
              await handler(true);
              ondelete();
            },
            color: Colors.red),
        SwipeAction(
            widthSpace: 120,
            title: "Done",
            onTap: (CompletionHandler handler) async {
              handler(false);
              ondone();
            },
            color: Colors.orange),
      ],
      child: Card(
        child: ListTile(
          onTap: () {
            print(connectionstate);
          },
          title: Text(
            connectionstate == DataConnectionStatus.disconnected
                ? item.title
                : item["Title"],
          ),
          subtitle: Text(connectionstate == DataConnectionStatus.disconnected
              ? item.description
              : item["Description"]),
        ),
      ),
    );
