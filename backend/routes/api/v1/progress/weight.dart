import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/middleware/auth_middleware.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/core/utils/request_helpers.dart';
import '../../../../lib/features/progress/data/progress_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  final authUser = context.read<AuthUser>();
  final db = context.read<Database>();
  final repo = ProgressRepository(db);

  switch (context.request.method) {
    case HttpMethod.get:
      final params = context.request.uri.queryParameters;
      final limit = parsePaginationParam(params['limit'], defaultValue: 50, max: 100);
      final offset = parsePaginationParam(params['offset']);
      final entries = await repo.getWeightLog(authUser.id, limit: limit, offset: offset);
      return jsonOk(entries);
    case HttpMethod.post:
      return _logWeight(context, repo, authUser);
    default:
      return methodNotAllowed();
  }
}

Future<Response> _logWeight(
  RequestContext context,
  ProgressRepository repo,
  AuthUser authUser,
) async {
  final body = await parseJsonBody(context);

  final weight = (body['weight'] as num?)?.toDouble();
  if (weight == null || weight <= 0) {
    return jsonError('Valid weight is required');
  }

  final entry = await repo.logWeight(
    authUser.id,
    weight,
    notes: body['notes'] as String? ?? '',
  );

  return jsonCreated(entry);
}
