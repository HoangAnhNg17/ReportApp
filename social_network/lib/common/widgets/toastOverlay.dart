import 'package:flutter/material.dart';

class ToastOverlay {
  final BuildContext context;
  OverlayEntry? overlayEntry;

  Color? color;

  ToastOverlay(this.context,);

  void showToastOverlay({
    required String message,
    required ToastType type ,
    Duration duration = const Duration(seconds: 5),
  }) {
    if (overlayEntry != null) {
      overlayEntry!.remove();
      overlayEntry = null;
    }




    switch(type){
      case ToastType.success:
        color = Colors.green;
        break;
      case ToastType.warning:
        color = Colors.yellowAccent;
        break;
      case ToastType.info:
        color = Colors.grey;
        break;
      case ToastType.error:
        color = Colors.redAccent;
        break;
    }

    overlayEntry = OverlayEntry(builder: (context) {
      return Positioned(
        top: 64,
        left: 16,
        right: 16,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: color,
            ),
            child: Row(
              children: [
                Expanded(
                  child: Text(message),
                ),
                IconButton(
                  onPressed: () {
                    if (overlayEntry != null) {
                      overlayEntry!.remove();
                      overlayEntry = null;
                    }
                  },
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
        ),
      );
    });

    if (overlayEntry != null) {
      Overlay.of(context)!.insert(overlayEntry!);
      Future.delayed(duration, () {
        if (overlayEntry != null) {
          overlayEntry!.remove();
          overlayEntry = null;
        }
      });
    }
  }
}

enum ToastType {
  success,
  warning,
  info,
  error,
}