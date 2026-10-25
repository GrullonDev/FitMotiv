import '../../../core/database/database.dart';

class WorkoutsRepository {
  WorkoutsRepository(this._db);
  final Database _db;

  Future<List<Map<String, dynamic>>> getWorkouts({
    String? category,
    bool publicOnly = true,
    String? userId,
    int limit = 20,
    int offset = 0,
  }) async {
    final conditions = <String>[];
    final parameters = <String, dynamic>{};

    if (publicOnly) {
      conditions.add('w.is_public = true');
    }

    if (category != null && category.isNotEmpty) {
      conditions.add('w.category = @category');
      parameters['category'] = category;
    }

    if (userId != null) {
      conditions.add('(w.user_id = @user_id OR w.is_public = true)');
      parameters['user_id'] = userId;
    }

    final where =
        conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

    parameters['limit'] = limit;
    parameters['offset'] = offset;

    final result = await _db.query(
      '''
      SELECT w.id, w.user_id, w.name, w.description, w.duration,
             w.difficulty, w.category, w.equipment, w.is_public, w.created_at
      FROM workouts w
      $where
      ORDER BY w.created_at DESC
      LIMIT @limit OFFSET @offset
      ''',
      parameters: parameters,
    );

    return result.map(_workoutFromRow).toList();
  }

  Future<Map<String, dynamic>?> getWorkoutById(String id) async {
    final result = await _db.query(
      '''
      SELECT w.id, w.user_id, w.name, w.description, w.duration,
             w.difficulty, w.category, w.equipment, w.is_public, w.created_at
      FROM workouts w
      WHERE w.id = @id
      ''',
      parameters: {'id': id},
    );

    if (result.isEmpty) return null;

    final workout = _workoutFromRow(result.first);

    final exercises = await _db.query(
      '''
      SELECT id, name, description, category, seconds, reps,
             rest_seconds, sort_order, image_url
      FROM exercises
      WHERE workout_id = @workout_id
      ORDER BY sort_order
      ''',
      parameters: {'workout_id': id},
    );

    workout['exercises'] = exercises
        .map((e) => {
              'id': e[0],
              'name': e[1],
              'description': e[2],
              'category': e[3],
              'seconds': e[4],
              'reps': e[5],
              'rest_seconds': e[6],
              'sort_order': e[7],
              'image_url': e[8],
            })
        .toList();

    return workout;
  }

  Future<Map<String, dynamic>?> getRandomWorkout({String? category}) async {
    final conditions = <String>['w.is_public = true'];
    final parameters = <String, dynamic>{};

    if (category != null && category.isNotEmpty) {
      conditions.add('w.category = @category');
      parameters['category'] = category;
    }

    final where = 'WHERE ${conditions.join(' AND ')}';

    final result = await _db.query(
      '''
      SELECT w.id, w.user_id, w.name, w.description, w.duration,
             w.difficulty, w.category, w.equipment, w.is_public, w.created_at
      FROM workouts w
      $where
      ORDER BY random()
      LIMIT 1
      ''',
      parameters: parameters,
    );

    if (result.isEmpty) return null;

    final workout = _workoutFromRow(result.first);
    final id = workout['id'] as String;

    final exercises = await _db.query(
      '''
      SELECT id, name, description, category, seconds, reps,
             rest_seconds, sort_order, image_url
      FROM exercises
      WHERE workout_id = @workout_id
      ORDER BY sort_order
      ''',
      parameters: {'workout_id': id},
    );

    workout['exercises'] = exercises
        .map((e) => {
              'id': e[0],
              'name': e[1],
              'description': e[2],
              'category': e[3],
              'seconds': e[4],
              'reps': e[5],
              'rest_seconds': e[6],
              'sort_order': e[7],
              'image_url': e[8],
            })
        .toList();

    return workout;
  }

  Map<String, dynamic> _workoutFromRow(List<dynamic> row) {
    final equipment = row[7];
    return {
      'id': row[0],
      'user_id': row[1],
      'name': row[2],
      'description': row[3],
      'duration': row[4],
      'difficulty': row[5],
      'category': row[6],
      'equipment': equipment is List ? equipment : <String>[],
      'is_public': row[8],
      'created_at': (row[9] as DateTime).toIso8601String(),
    };
  }
}
