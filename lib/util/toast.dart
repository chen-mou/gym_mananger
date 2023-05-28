import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class Toast {
  final FToast fToast = FToast();

  Toast(BuildContext ctx) {
    fToast.init(ctx);
  }

  void showToast(String msg, Icon icon) {
    Widget w = Container(
      width: 200,
      height: 50,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(5)),
          color: Colors.blueGrey[70]),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          icon,
          SizedBox(
            width: 20,
          ),
          Text(msg)
        ],
      ),
    );

    fToast.showToast(child: w, gravity: ToastGravity.TOP);
  }

  void error(String msg) {
    showToast(msg, Icon(Icons.error_outline));
  }

  void info(String msg) {
    showToast(msg, Icon(Icons.info_outline));
  }
}
