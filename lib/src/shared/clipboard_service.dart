import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// Service that handles clipboard operations with user feedback
class ClipboardService {
  /// Copies text to clipboard and shows feedback to the user via SnackBar
  static Future<void> copyToClipboard(BuildContext context, String text) async {
    await Clipboard.setData(ClipboardData(text: text));

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('$text copied to clipboard'),
        duration: const Duration(seconds: 2),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}