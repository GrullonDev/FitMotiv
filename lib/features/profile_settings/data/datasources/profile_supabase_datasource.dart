import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource que obtiene los datos del perfil del usuario
/// directamente desde Supabase Auth (user metadata).
class ProfileSupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene el perfil del usuario actual desde auth.users metadata
  Future<Map<String, dynamic>> getCurrentProfile() async {
    final user = _client.auth.currentUser;
    if (user == null) throw Exception('No user logged in');

    final metadata = user.userMetadata ?? {};

    return {
      'id': user.id,
      'email': user.email ?? '',
      'full_name': metadata['full_name'] ?? '',
      'username': metadata['username'] ?? '',
      'bio': metadata['bio'] ?? '',
      'fitness_goal': metadata['fitness_goal'] ?? '',
      'activity_level': metadata['activity_level'] ?? '',
      'age': metadata['age'] ?? 0,
      'height': metadata['height'] ?? 0.0,
      'weight': metadata['weight'] ?? 0.0,
      'avatar_url': metadata['avatar_url'] ?? '',
      'created_at': user.createdAt,
    };
  }

  /// Actualiza el perfil del usuario
  Future<Map<String, dynamic>> updateProfile(Map<String, dynamic> data) async {
    final response = await _client.auth.updateUser(
      UserAttributes(data: data),
    );
    return response.user?.userMetadata ?? {};
  }
}
