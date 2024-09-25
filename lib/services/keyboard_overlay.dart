import 'package:flutter/cupertino.dart';

class KeyboardOverlay {
  static OverlayEntry? _overlayEntry;

  static showOverlay(BuildContext context) {
    // if (_overlayEntry != null) {
    //   return;
    // }
    //
    // OverlayState? overlayState = Overlay.of(context);
    // _overlayEntry = OverlayEntry(
    //   builder: (context) {
    //     return Positioned(
    //       bottom: MediaQuery.of(context).viewInsets.bottom,
    //       right: 0.0,
    //       left: 0.0,
    //       child: const InputDoneView(),
    //     );
    //   },
    // );
    //
    // overlayState.insert(_overlayEntry!);
  }

  static removeOverlay() {
    if (_overlayEntry != null) {
      _overlayEntry!.remove();
      _overlayEntry = null;
    }
  }

  static FocusNode getFocusNode(BuildContext context) {
    FocusNode numberFocusNode = FocusNode();
    numberFocusNode.addListener(
      () {
        bool hasFocus = numberFocusNode.hasFocus;
        if (hasFocus) {
          KeyboardOverlay.showOverlay(context);
        } else {
          KeyboardOverlay.removeOverlay();
        }
      },
    );

    return numberFocusNode;
  }
}
