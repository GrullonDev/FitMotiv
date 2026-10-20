import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Middleware requestLogger() {
  return (handler) {
    return (context) async {
      final stopwatch = Stopwatch()..start();
      final method = context.request.method.value;
      final path = context.request.uri.path;

      Response response;
      try {
        response = await handler(context);
      } catch (e) {
        stopwatch.stop();
        stdout.writeln(
          '[${DateTime.now().toIso8601String()}] $method $path -> 500 (${stopwatch.elapsedMilliseconds}ms)',
        );
        rethrow;
      }

      stopwatch.stop();
      stdout.writeln(
        '[${DateTime.now().toIso8601String()}] $method $path -> ${response.statusCode} (${stopwatch.elapsedMilliseconds}ms)',
      );
      return response;
    };
  };
}
