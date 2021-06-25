import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  String hintext;
  Function onsubmit;
  CustomTextField({
    @required this.onsubmit,
    @required this.hintext,
  });
  GlobalKey<FormState> _gkey = GlobalKey<FormState>();
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      // ignore: missing_return
      validator: (value) {
        if (value.isEmpty) {
          switch (hintext) {
            case "Title":
              return "Title is missing";

              break;
            default:
          }
        }
      },
      key: _gkey,
      onSaved: onsubmit,
      cursorColor: Colors.redAccent,
      decoration: InputDecoration(
        hintText: hintext,
        hintStyle: TextStyle(color: Colors.purple),
        contentPadding: EdgeInsets.only(top: 1, left: 10),
        filled: true,
        fillColor: Colors.grey.withOpacity(0.2),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(color: Colors.red)),
      ),
    );
  }
}
