import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/features/workouts/data/workouts_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  final repo = WorkoutsRepository(db);
  final params = context.request.uri.queryParameters;

  final workout = await repo.getRandomWorkout(
    category: params['category'],
  );

  if (workout == null) return jsonNotFound('No workouts available');
  return jsonOk(workout);
}
