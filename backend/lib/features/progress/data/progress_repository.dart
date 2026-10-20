import '../../../core/database/database.dart';

class ProgressRepository {
  ProgressRepository(this._db);
  final Database _db;

  // --- Weight Log ---

  Future<List<Map<String, dynamic>>> getWeightLog(String userId) async {
    final result = await _db.query(
      '''
      SELECT id, weight, notes, recorded_at, created_at
      FROM weight_log
      WHERE user_id = @user_id
      ORDER BY recorded_at DESC
      ''',
      parameters: {'user_id': userId},
    );

    return result
        .map((row) => {
              'id': row[0],
              'weight': row[1],
              'notes': row[2],
              'recorded_at': (row[3] as DateTime).toIso8601String(),
              'created_at': (row[4] as DateTime).toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, dynamic>> logWeight(
    String userId,
    double weight, {
    String notes = '',
  }) async {
    final result = await _db.query(
      '''
      INSERT INTO weight_log (user_id, weight, notes)
      VALUES (@user_id, @weight, @notes)
      RETURNING id, weight, notes, recorded_at, created_at
      ''',
      parameters: {
        'user_id': userId,
        'weight': weight,
        'notes': notes,
      },
    );

    final row = result.first;
    return {
      'id': row[0],
      'weight': row[1],
      'notes': row[2],
      'recorded_at': (row[3] as DateTime).toIso8601String(),
      'created_at': (row[4] as DateTime).toIso8601String(),
    };
  }

  // --- Goals ---

  Future<List<Map<String, dynamic>>> getGoals(String userId) async {
    final result = await _db.query(
      '''
      SELECT id, title, description, target_value, current_value,
             unit, icon, is_completed, deadline, created_at
      FROM goals
      WHERE user_id = @user_id
      ORDER BY created_at DESC
      ''',
      parameters: {'user_id': userId},
    );

    return result
        .map((row) => {
              'id': row[0],
              'title': row[1],
              'description': row[2],
              'target_value': row[3],
              'current_value': row[4],
              'unit': row[5],
              'icon': row[6],
              'is_completed': row[7],
              'deadline': row[8] != null
                  ? (row[8] as DateTime).toIso8601String()
                  : null,
              'created_at': (row[9] as DateTime).toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, dynamic>> createGoal(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final result = await _db.query(
      '''
      INSERT INTO goals (user_id, title, description, target_value, unit, icon, deadline)
      VALUES (@user_id, @title, @description, @target_value, @unit, @icon, @deadline)
      RETURNING id, title, description, target_value, current_value, unit, icon, is_completed, deadline, created_at
      ''',
      parameters: {
        'user_id': userId,
        'title': data['title'] as String? ?? '',
        'description': data['description'] as String? ?? '',
        'target_value': (data['target_value'] as num?)?.toDouble() ?? 0,
        'unit': data['unit'] as String? ?? '',
        'icon': data['icon'] as String? ?? 'flag',
        'deadline': data['deadline'] != null
            ? DateTime.parse(data['deadline'] as String)
            : null,
      },
    );

    final row = result.first;
    return {
      'id': row[0],
      'title': row[1],
      'description': row[2],
      'target_value': row[3],
      'current_value': row[4],
      'unit': row[5],
      'icon': row[6],
      'is_completed': row[7],
      'deadline':
          row[8] != null ? (row[8] as DateTime).toIso8601String() : null,
      'created_at': (row[9] as DateTime).toIso8601String(),
    };
  }

  Future<Map<String, dynamic>?> toggleGoalCompleted(
    String userId,
    String goalId,
  ) async {
    final result = await _db.query(
      '''
      UPDATE goals
      SET is_completed = NOT is_completed, updated_at = now()
      WHERE id = @id AND user_id = @user_id
      RETURNING id, title, description, target_value, current_value, unit, icon, is_completed, deadline, created_at
      ''',
      parameters: {'id': goalId, 'user_id': userId},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0],
      'title': row[1],
      'description': row[2],
      'target_value': row[3],
      'current_value': row[4],
      'unit': row[5],
      'icon': row[6],
      'is_completed': row[7],
      'deadline':
          row[8] != null ? (row[8] as DateTime).toIso8601String() : null,
      'created_at': (row[9] as DateTime).toIso8601String(),
    };
  }

  // --- Workout Sessions ---

  Future<List<Map<String, dynamic>>> getWorkoutSessions(
      String userId) async {
    final result = await _db.query(
      '''
      SELECT id, workout_id, workout_name, duration_minutes,
             calories_burned, notes, completed_at, created_at
      FROM workout_sessions
      WHERE user_id = @user_id
      ORDER BY completed_at DESC
      ''',
      parameters: {'user_id': userId},
    );

    return result
        .map((row) => {
              'id': row[0],
              'workout_id': row[1],
              'workout_name': row[2],
              'duration_minutes': row[3],
              'calories_burned': row[4],
              'notes': row[5],
              'completed_at': (row[6] as DateTime).toIso8601String(),
              'created_at': (row[7] as DateTime).toIso8601String(),
            })
        .toList();
  }

  Future<Map<String, dynamic>> logWorkoutSession(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final result = await _db.query(
      '''
      INSERT INTO workout_sessions (user_id, workout_id, workout_name, duration_minutes, calories_burned, notes)
      VALUES (@user_id, @workout_id, @workout_name, @duration_minutes, @calories_burned, @notes)
      RETURNING id, workout_id, workout_name, duration_minutes, calories_burned, notes, completed_at, created_at
      ''',
      parameters: {
        'user_id': userId,
        'workout_id': data['workout_id'] as String?,
        'workout_name': data['workout_name'] as String? ?? '',
        'duration_minutes': data['duration_minutes'] as int? ?? 0,
        'calories_burned': data['calories_burned'] as int? ?? 0,
        'notes': data['notes'] as String? ?? '',
      },
    );

    final row = result.first;
    return {
      'id': row[0],
      'workout_id': row[1],
      'workout_name': row[2],
      'duration_minutes': row[3],
      'calories_burned': row[4],
      'notes': row[5],
      'completed_at': (row[6] as DateTime).toIso8601String(),
      'created_at': (row[7] as DateTime).toIso8601String(),
    };
  }
}
