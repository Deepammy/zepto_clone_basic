import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import '../../config/injection.dart';


class AppCustomLoader {
  static OverlayEntry? _overlayEntry;

  static void show() {
    if (_overlayEntry != null) return;

    final overlay = appNavKey.currentState?.overlay;
    if (overlay == null) {
      return;
    }

    _overlayEntry = OverlayEntry(
      builder: (_) {
        return Stack(
          alignment: Alignment.center,
          children: <Widget>[
            Container(
              color: Colors.black.withOpacity(.3),
              child: buildLoader(),
            ),
          ],
        );
      },
    );

    overlay.insert(_overlayEntry!);
  }

  static void hide() {
    try {
      _overlayEntry?.remove();
      _overlayEntry = null;
    } catch (e) {
      print(e);
    }
  }

  static Widget buildLoader() {
    final context = appNavKey.currentContext!;
    return Center(
      child: SizedBox(
        width: 70,
        child: SpinKitDualRing(
          color: Theme.of(context).colorScheme.primary,
          size: 32.0,
          lineWidth: 2.0,
        ),
      ),
    );
  }
}
