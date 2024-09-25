import 'package:flutter/material.dart';

import '../utilities/constants.dart';

class DialogLoading extends StatefulWidget {
  final String message;
  const DialogLoading({
    super.key,
    this.message = "Loading...",
  });

  @override
  State<DialogLoading> createState() => _DialogLoadingState();
}

class _DialogLoadingState extends State<DialogLoading> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        toolbarHeight: 0.0,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          const SizedBox(
            width: double.infinity,
          ),
          Container(
            height: 140.0,
            width: 140.0,
            margin: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
            child: CircularProgressIndicator(
              strokeWidth: 20.0,
              color: mainButtonColor.withOpacity(0.4),
            ),
          ),
          Container(
            margin: const EdgeInsets.fromLTRB(0.0, 40.0, 0.0, 0.0),
            child: Text(
              widget.message,
              style: const TextStyle(
                fontSize: 24.0,
                color: Color(0xFF111111),
                fontVariations: [
                  FontVariation('wght', 700),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
