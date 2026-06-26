import 'dart:async';

import 'package:flutter/material.dart';

import '../config/router/route_manager.dart';
import '../widgets/custom_toast.dart';

class Toaster {
  static OverlayEntry? _entry;
  static Timer? _timer;

  const Toaster._();

  static void error(String text) => _show(text, ToastType.error);

  static void success(String text) => _show(text, ToastType.success);

  static void warning(String text) => _show(text, ToastType.warning);

  static void info(String text) => _show(text, ToastType.info);

  static void close() {
    _timer?.cancel();
    _timer = null;
    _entry?.remove();
    _entry = null;
  }

  static void _show(String text, ToastType type) {
    final overlay = rootNavigatorKey.currentState?.overlay;
    if (overlay == null) return;

    close();
    _entry = OverlayEntry(
      builder: (context) => Positioned(
        top: MediaQuery.viewPaddingOf(context).top + 12,
        left: 0,
        right: 0,
        child: SafeArea(
          bottom: false,
          child: CustomToast(type: type, text: text, onDismiss: close),
        ),
      ),
    );

    overlay.insert(_entry!);
    _timer = Timer(const Duration(seconds: 3), close);
  }
}
