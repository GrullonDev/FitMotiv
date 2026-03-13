import 'dart:io';
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
      'initial_weight': metadata['initial_weight'] ?? metadata['weight'] ?? 0.0,
      'created_at': user.createdAt,
    };
  }

  /// Actualiza el perfil del usuario tanto en Auth metadata como en la tabla profiles
  Future<void> updateProfile(Map<String, dynamic> data) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No user logged in');

    // 1. Update Auth metadata
    await _client.auth.updateUser(
      UserAttributes(data: data),
    );

    // 2. Update public.profiles table
    await _client.from('profiles').update(data).eq('id', userId);
  }

  /// Sube una imagen al bucket de avatars y devuelve la URL pública
  Future<String> uploadAvatar(File file) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('No user logged in');

    final fileExt = file.path.split('.').last;
    final fileName = '$userId.${DateTime.now().millisecondsSinceEpoch}.$fileExt';
    final filePath = 'avatars/$fileName';

    await _client.storage.from('avatars').upload(
          filePath,
          file,
          fileOptions: const FileOptions(cacheControl: '3600', upsert: false),
        );

    final String publicUrl = _client.storage.from('avatars').getPublicUrl(filePath);
    return publicUrl;
  }
}
