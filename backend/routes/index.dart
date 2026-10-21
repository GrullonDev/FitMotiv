import 'package:dart_frog/dart_frog.dart';

import '../lib/core/utils/json_response.dart';

Response onRequest(RequestContext context) {
  return jsonOk({
    'name': 'FitMotiv API',
    'version': '1.0.0',
    'status': 'running',
  });
}
