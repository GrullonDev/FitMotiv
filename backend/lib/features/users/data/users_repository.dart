import '../../../core/database/database.dart';

class UsersRepository {
  UsersRepository(this._db);
  final Database _db;

  Future<Map<String, dynamic>?> getProfile(String userId) async {
    final result = await _db.query(
      '''
      SELECT u.id, u.email, u.is_verified, u.created_at,
             p.full_name, p.username, p.bio, p.fitness_goal,
             p.activity_level, p.age, p.height, p.weight, p.avatar_url
      FROM users u
      JOIN profiles p ON p.user_id = u.id
      WHERE u.id = @user_id AND u.is_active = true
      ''',
      parameters: {'user_id': userId},
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0],
      'email': row[1],
      'is_verified': row[2],
      'created_at': (row[3] as DateTime).toIso8601String(),
      'full_name': row[4],
      'username': row[5],
      'bio': row[6],
      'fitness_goal': row[7],
      'activity_level': row[8],
      'age': row[9],
      'height': row[10],
      'weight': row[11],
      'avatar_url': row[12],
    };
  }

  Future<Map<String, dynamic>?> updateProfile(
    String userId,
    Map<String, dynamic> data,
  ) async {
    final allowedFields = {
      'full_name', 'username', 'bio', 'fitness_goal',
      'activity_level', 'age', 'height', 'weight', 'avatar_url',
    };

    final updates = <String>[];
    final parameters = <String, dynamic>{'user_id': userId};

    for (final entry in data.entries) {
      if (allowedFields.contains(entry.key) && entry.value != null) {
        updates.add('${entry.key} = @${entry.key}');
        parameters[entry.key] = entry.value;
      }
    }

    if (updates.isEmpty) return getProfile(userId);

    updates.add("updated_at = now()");

    // Check username uniqueness
    if (data.containsKey('username') && data['username'] != null) {
      final existing = await _db.query(
        'SELECT user_id FROM profiles WHERE username = @username AND user_id != @user_id',
        parameters: {'username': data['username'], 'user_id': userId},
      );
      if (existing.isNotEmpty) {
        throw Exception('Username is already taken');
      }
    }

    await _db.query(
      'UPDATE profiles SET ${updates.join(', ')} WHERE user_id = @user_id',
      parameters: parameters,
    );

    return getProfile(userId);
  }
}
