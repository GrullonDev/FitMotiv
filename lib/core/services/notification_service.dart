import 'package:flutter/foundation.dart';

class NotificationService {
  Future<void> init() async {
    debugPrint('NotificationService: init (push notifications disabled — no Firebase)');
  }
}
