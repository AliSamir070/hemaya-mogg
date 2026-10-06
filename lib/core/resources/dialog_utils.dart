import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'color_manager.dart';

class DialogUtils {
  static showMessageDialog({
    required BuildContext context,
    required String content,
    required String actionTitle,
    required void Function() actionPress,
  }) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text("Warning"),
        content: Text(content),
        actions: [
          ElevatedButton(onPressed: actionPress, child: Text(actionTitle)),
        ],
      ),
    );
  }

  static showLoadingDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Loading..."),
                Center(child: CircularProgressIndicator()),
              ],
            ),
          ],
        ),
      ),
    );
  }

  static showSnackbar(BuildContext context, String content) {
    SnackBar snackBar = SnackBar(content: Text(content));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  static showToast(String message) {
    Fluttertoast.showToast(
      msg: message,
      toastLength: Toast.LENGTH_SHORT,
      gravity: ToastGravity.BOTTOM,
      timeInSecForIosWeb: 3,
      backgroundColor: ColorManager.primary,
      textColor: Colors.white,
      fontSize: 16.sp,
    );
  }
}
