import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

enum MessageType {
  success,
  error,
  info,
  warning,
}

class AppMessage {
  final String text;
  final MessageType type;
  final Duration duration;

  const AppMessage({
    required this.text,
    required this.type,
    this.duration = const Duration(seconds: 3),
  });

  Color get backgroundColor {
    switch (type) {
      case MessageType.success:
        return Colors.green;
      case MessageType.error:
        return Colors.red;
      case MessageType.info:
        return Colors.blue;
      case MessageType.warning:
        return Colors.orange;
    }
  }

  IconData get icon {
    switch (type) {
      case MessageType.success:
        return Icons.check_circle;
      case MessageType.error:
        return Icons.error;
      case MessageType.info:
        return Icons.info;
      case MessageType.warning:
        return Icons.warning;
    }
  }
}

class MessageNotifier extends StateNotifier<AppMessage?> {
  MessageNotifier() : super(null);

  void showSuccess(String message) {
    state = AppMessage(text: message, type: MessageType.success);
    _clearAfterDelay();
  }

  void showError(String message) {
    state = AppMessage(text: message, type: MessageType.error);
    _clearAfterDelay();
  }

  void showInfo(String message) {
    state = AppMessage(text: message, type: MessageType.info);
    _clearAfterDelay();
  }

  void showWarning(String message) {
    state = AppMessage(text: message, type: MessageType.warning);
    _clearAfterDelay();
  }

  void clear() {
    state = null;
  }

  void _clearAfterDelay() {
    Future.delayed(state?.duration ?? const Duration(seconds: 3), () {
      if (mounted) {
        state = null;
      }
    });
  }
}

final messageProvider = StateNotifierProvider<MessageNotifier, AppMessage?>((ref) {
  return MessageNotifier();
});