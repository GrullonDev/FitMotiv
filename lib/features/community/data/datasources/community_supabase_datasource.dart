import 'package:flutter/foundation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource para obtener perfiles públicos de la comunidad
class CommunitySupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

  /// Obtiene la lista de usuarios registrados (perfiles públicos)
  Future<List<Map<String, dynamic>>> getProfiles({double? myLat, double? myLon}) async {
    try {
      var query = _client
          .from('profiles')
          .select('id, full_name, username, bio, fitness_goal, activity_level, avatar_url, is_online, last_seen, latitude, longitude')
          .neq('id', _client.auth.currentUser?.id ?? '');

      final response = await query.order('created_at', ascending: false);
      final List<Map<String, dynamic>> profiles = List<Map<String, dynamic>>.from(response);

      // Si tenemos coordenadas, calcular cercanía (simulado o manual si no hay PostGIS)
      if (myLat != null && myLon != null) {
        // Podríamos filtrar aquí o confiar en que Supabase lo haga si tuviera PostGIS
        // Por ahora lo dejamos para que el UI pueda mostrar la distancia si quiere
      }

      return profiles;
    } catch (e) {
      debugPrint('❌ Error fetching profiles: $e');
      return [];
    }
  }

  /// Obtiene los posts del feed
  Future<List<Map<String, dynamic>>> getFeedPosts() async {
    try {
      final userId = _client.auth.currentUser?.id;
      final response = await _client
          .from('posts')
          .select('*, profiles(full_name, username, avatar_url), post_likes(user_id)')
          .order('created_at', ascending: false)
          .limit(50);

      final posts = List<Map<String, dynamic>>.from(response);
      
      // Mark if current user liked the post
      if (userId != null) {
        for (var post in posts) {
          final likes = post['post_likes'] as List?;
          post['is_liked'] = likes?.any((l) => l['user_id'] == userId) ?? false;
        }
      }
      
      return posts;
    } catch (e) {
      debugPrint('❌ Error fetching feed posts: $e');
      return [];
    }
  }

  /// Toggle like a un post
  Future<void> toggleLike(String postId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    // Comprobar si ya existe el like
    final existing = await _client
        .from('post_likes')
        .select()
        .eq('post_id', postId)
        .eq('user_id', userId)
        .maybeSingle();

    if (existing == null) {
      await _client.from('post_likes').insert({
        'post_id': postId,
        'user_id': userId,
      });
    } else {
      await _client
          .from('post_likes')
          .delete()
          .eq('post_id', postId)
          .eq('user_id', userId);
    }
  }

  /// Agrega un comentario a un post
  Future<void> addComment(String postId, String content) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await _client.from('post_comments').insert({
      'post_id': postId,
      'user_id': userId,
      'content': content,
    });
  }

  /// Obtiene los comentarios de un post
  Future<List<Map<String, dynamic>>> getComments(String postId) async {
    try {
      final response = await _client
          .from('post_comments')
          .select('*, profiles(full_name, username, avatar_url)')
          .eq('post_id', postId)
          .order('created_at', ascending: true);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('❌ Error fetching comments: $e');
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

  /// === CHAT METHODS ===

  /// Obtiene las conversaciones del usuario actual
  Future<List<Map<String, dynamic>>> getConversations() async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return [];

    try {
      final response = await _client
          .from('conversations')
          .select('*, p1:profiles!conversations_participant_1_id_fkey(*), p2:profiles!conversations_participant_2_id_fkey(*)')
          .or('participant_1_id.eq.$userId,participant_2_id.eq.$userId')
          .order('last_message_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching conversations: $e');
      return [];
    }
  }

  /// Obtiene los mensajes de una conversación
  Future<List<Map<String, dynamic>>> getMessages(String conversationId) async {
    try {
      final response = await _client
          .from('messages')
          .select('*')
          .eq('conversation_id', conversationId)
          .order('created_at', ascending: false);

      return List<Map<String, dynamic>>.from(response);
    } catch (e) {
      debugPrint('Error fetching messages: $e');
      return [];
    }
  }

  /// Stream de mensajes para tiempo real
  Stream<List<Map<String, dynamic>>> streamMessages(String conversationId) {
    return _client
        .from('messages')
        .stream(primaryKey: ['id'])
        .eq('conversation_id', conversationId)
        .order('created_at', ascending: false);
  }

  /// Envía un mensaje
  Future<void> sendMessage({
    required String conversationId,
    required String receiverId,
    required String text,
  }) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    await _client.from('messages').insert({
      'conversation_id': conversationId,
      'sender_id': userId,
      'receiver_id': receiverId,
      'text': text,
    });
  }

  /// Busca o crea una conversación con otro usuario
  Future<Map<String, dynamic>> getOrCreateConversation(String otherUserId) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) throw Exception('Not logged in');

    // Intentar encontrar conversación existente
    final response = await _client
        .from('conversations')
        .select()
        .or('and(participant_1_id.eq.$userId,participant_2_id.eq.$otherUserId),and(participant_1_id.eq.$otherUserId,participant_2_id.eq.$userId)')
        .maybeSingle();

    if (response != null) {
      return response;
    }

    // Si no existe, crearla
    final participants = [userId, otherUserId]..sort();
    
    final created = await _client
        .from('conversations')
        .insert({
          'participant_1_id': participants[0],
          'participant_2_id': participants[1],
        })
        .select()
        .single();

    return created;
  }

  /// Asegura que el perfil del usuario actual existe
  Future<void> ensureProfileExists() async {
    final user = _client.auth.currentUser;
    if (user == null) return;

    try {
      final profile = await _client.from('profiles').select().eq('id', user.id).maybeSingle();
      
      if (profile == null) {
        debugPrint('Creating missing profile for user ${user.id}');
        await _client.from('profiles').insert({
          'id': user.id,
          'full_name': user.userMetadata?['full_name'] ?? 'User',
          'username': user.userMetadata?['username'] ?? 'user_${user.id.substring(0, 5)}',
          'email': user.email,
        });
      }
    } catch (e) {
      debugPrint('Error ensuring profile exists: $e');
    }
  }

  /// Actualiza la ubicación del usuario actual
  Future<void> updateLocation(double lat, double lon) async {
    final userId = _client.auth.currentUser?.id;
    if (userId == null) return;

    try {
      await _client.from('profiles').update({
        'latitude': lat,
        'longitude': lon,
        'last_seen': DateTime.now().toIso8601String(),
      }).eq('id', userId);
    } catch (e) {
      debugPrint('Error updating location: $e');
    }
  }
}
