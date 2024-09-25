import 'package:flutter/material.dart';

class DialogDone extends StatefulWidget {
  final Function onComplete;
  final String displayText;
  const DialogDone({
    super.key,
    required this.onComplete,
    this.displayText = 'Successful',
  });

  @override
  State<DialogDone> createState() => _DialogDoneState();
}

class _DialogDoneState extends State<DialogDone> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(
        widget.displayText,
        style: TextStyle(
          color: Theme.of(context).textTheme.bodyLarge?.color!,
          fontSize: 24.0,
          fontVariations: const [
            FontVariation('wght', 700),
          ],
        ),
      ),
      content: const Icon(
        Icons.check_circle,
        color: Colors.green,
        size: 30,
      ),
      actions: [
        TextButton(
          onPressed: () {
            widget.onComplete();
          },
          child: Text(
            'Done',
            style: TextStyle(
              color: Theme.of(context).textTheme.bodyLarge?.color!,
              fontSize: 16.0,
              fontVariations: const [
                FontVariation('wght', 700),
              ],
            ),
          ),
        ),
      ],
    );
  }
}
