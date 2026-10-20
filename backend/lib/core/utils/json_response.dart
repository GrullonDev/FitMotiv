import 'dart:convert';
import 'dart:io';

import 'package:dart_frog/dart_frog.dart';

Response jsonOk(dynamic data, {int statusCode = HttpStatus.ok}) {
  return Response(
    statusCode: statusCode,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode({'success': true, 'data': data}),
  );
}

Response jsonCreated(dynamic data) {
  return jsonOk(data, statusCode: HttpStatus.created);
}

Response jsonError(
  String message, {
  int statusCode = HttpStatus.badRequest,
  Map<String, dynamic>? errors,
}) {
  final body = <String, dynamic>{
    'success': false,
    'error': {'message': message},
  };
  if (errors != null) {
    body['error'] = {'message': message, ...errors};
  }
  return Response(
    statusCode: statusCode,
    headers: {'Content-Type': 'application/json'},
    body: jsonEncode(body),
  );
}

Response jsonNotFound([String message = 'Resource not found']) {
  return jsonError(message, statusCode: HttpStatus.notFound);
}

Response jsonUnauthorized([String message = 'Authentication required']) {
  return jsonError(message, statusCode: HttpStatus.unauthorized);
}

Response jsonForbidden([String message = 'Access denied']) {
  return jsonError(message, statusCode: HttpStatus.forbidden);
}

Response jsonTooManyRequests([String message = 'Too many requests']) {
  return jsonError(message, statusCode: HttpStatus.tooManyRequests);
}

Response methodNotAllowed() {
  return jsonError('Method not allowed',
      statusCode: HttpStatus.methodNotAllowed);
}
