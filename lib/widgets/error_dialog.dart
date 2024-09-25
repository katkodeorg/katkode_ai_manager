import 'dart:ui';

import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class ErrorDialog extends StatelessWidget {
  late final String _title;
  late final Function _okFunction;

  ErrorDialog({
    super.key,
    required String title,
    required Function okFunction,
  }) {
    _title = title;
    _okFunction = okFunction;
  }

  @override
  Widget build(BuildContext context) {
    return BackdropFilter(
      filter: ImageFilter.blur(sigmaX: 4.0, sigmaY: 4.0),
      child: AlertDialog(
        backgroundColor: Theme.of(context).canvasColor,
        title: Center(
          child: Text(
            _title,
            style: TextStyle(
              fontSize: 18.0,
              color: Theme.of(context).textTheme.bodyLarge!.color,
              fontWeight: FontWeight.w500,
            ),
            textAlign: TextAlign.center,
          ),
        ),
        content: Container(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Container(
                margin: const EdgeInsets.fromLTRB(0.0, 30.0, 0.0, 0.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Stack(
                        children: <Widget>[
                          Positioned.fill(
                            child: Container(
                              color: mainButtonColor,
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              _okFunction();
                            },
                            child: Text(
                              'Okay',
                              style: TextStyle(
                                fontSize: 14.0,
                                color: Theme.of(context)
                                    .textTheme
                                    .bodyLarge!
                                    .color,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(14.0)),
        ),
      ),
    );
  }
}
