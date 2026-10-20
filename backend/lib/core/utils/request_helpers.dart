import 'dart:convert';

import 'package:dart_frog/dart_frog.dart';

Future<Map<String, dynamic>> parseJsonBody(RequestContext context) async {
  try {
    final body = await context.request.body();
    if (body.isEmpty) return {};
    return jsonDecode(body) as Map<String, dynamic>;
  } catch (_) {
    return {};
  }
}

String? validateEmail(String? email) {
  if (email == null || email.isEmpty) return 'Email is required';
  final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
  if (!emailRegex.hasMatch(email)) return 'Invalid email format';
  return null;
}

String? validatePassword(String? password) {
  if (password == null || password.isEmpty) return 'Password is required';
  if (password.length < 8) return 'Password must be at least 8 characters';
  if (!RegExp(r'[A-Z]').hasMatch(password)) {
    return 'Password must contain at least one uppercase letter';
  }
  if (!RegExp(r'[a-z]').hasMatch(password)) {
    return 'Password must contain at least one lowercase letter';
  }
  if (!RegExp(r'[0-9]').hasMatch(password)) {
    return 'Password must contain at least one digit';
  }
  return null;
}

String? validateRequired(String? value, String fieldName) {
  if (value == null || value.trim().isEmpty) return '$fieldName is required';
  return null;
}

String sanitize(String input) {
  return input.trim();
}
