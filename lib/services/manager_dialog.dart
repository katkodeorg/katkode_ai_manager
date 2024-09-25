import 'package:flutter/material.dart';

import '../widgets/dialog_loading.dart';
import '../widgets/error_dialog.dart';

class ManagerDialog {
  ManagerDialog();

  static Future<dynamic> showLoadingDialog(BuildContext context) {
    return showGeneralDialog(
      context: context,
      barrierColor: const Color(0xff202020),
      // Background color
      barrierDismissible: false,
      barrierLabel: 'Dialog',
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (_, __, ___) {
        return WillPopScope(
          onWillPop: () async => false,
          child: const DialogLoading(),
        );
      },
    );
  }

  static Future<dynamic> showCustomDialog(
    BuildContext context,
    Widget alertDialog,
    bool barrierDismissible,
  ) {
    return showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: alertDialog,
        );
      },
    );
  }

  static void hideDialog(BuildContext context) {
    Navigator.of(context).pop();
  }

  static void showErrorDialog(
    String errorMessage,
    BuildContext context,
    bool barrierDismissible,
    Function okPressed,
  ) {
    showDialog(
      barrierDismissible: barrierDismissible,
      context: context,
      builder: (BuildContext context) {
        return WillPopScope(
          onWillPop: () async => barrierDismissible,
          child: ErrorDialog(
            title: errorMessage,
            okFunction: okPressed,
          ),
        );
      },
    );
  }
}
