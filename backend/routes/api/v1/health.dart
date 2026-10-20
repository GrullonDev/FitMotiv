import 'package:dart_frog/dart_frog.dart';

import '../../../lib/core/database/database.dart';
import '../../../lib/core/utils/json_response.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  try {
    final result = await db.query('SELECT 1');
    return jsonOk({
      'status': 'healthy',
      'database': result.isNotEmpty ? 'connected' : 'error',
      'timestamp': DateTime.now().toUtc().toIso8601String(),
    });
  } catch (e) {
    return jsonError(
      'Database connection failed',
      statusCode: 503,
    );
  }
}
