import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource para obtener perfiles públicos de la comunidad
class CommunitySupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene la lista de usuarios registrados (perfiles públicos)
  Future<List<Map<String, dynamic>>> getProfiles() async {
    try {
      final response = await _client
          .from('profiles')
          .select('id, full_name, username, bio, fitness_goal, activity_level, avatar_url, is_online, last_seen')
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  /// Obtiene los posts del feed
  Future<List<Map<String, dynamic>>> getFeedPosts() async {
    try {
      final response = await _client
          .from('posts')
          .select('*, profiles!posts_user_id_fkey(full_name, username, avatar_url)')
          .order('created_at', ascending: false)
          .limit(20);

      return List<Map<String, dynamic>>.from(response);
    } catch (_) {
      return [];
    }
  }

  /// Crea un nuevo post
  Future<void> createPost(String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await _client.from('posts').insert({
      'user_id': userId,
      'content': content,
    });
  }
}
