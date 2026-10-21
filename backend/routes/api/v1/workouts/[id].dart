import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/features/workouts/data/workouts_repository.dart';

Future<Response> onRequest(RequestContext context, String id) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  final repo = WorkoutsRepository(db);

  final workout = await repo.getWorkoutById(id);
  if (workout == null) return jsonNotFound('Workout not found');
  return jsonOk(workout);
}
