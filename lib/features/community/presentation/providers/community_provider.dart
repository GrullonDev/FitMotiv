import 'dart:math';
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:fit_motiv/features/community/data/datasources/community_supabase_datasource.dart';

/// Provider que gestiona los datos de la comunidad
class CommunityProvider extends ChangeNotifier {
  CommunityProvider({required CommunitySupabaseDatasource datasource})
      : _datasource = datasource {
    loadAll();
  }

  final CommunitySupabaseDatasource _datasource;

  List<Map<String, dynamic>> _profiles = [];
  List<Map<String, dynamic>> _posts = [];
  List<Map<String, dynamic>> _conversations = [];
  List<Map<String, dynamic>> _currentMessages = [];
  List<Map<String, dynamic>> _postComments = [];
  bool _isLoading = false;
  String? _error;
  Position? _currentPosition;
  StreamSubscription? _messagesSubscription;

  List<Map<String, dynamic>> get profiles => _profiles;
  List<Map<String, dynamic>> get posts => _posts;
  List<Map<String, dynamic>> get conversations => _conversations;
  List<Map<String, dynamic>> get currentMessages => _currentMessages;
  List<Map<String, dynamic>> get postComments => _postComments;
  bool get isLoading => _isLoading;
  String? get error => _error;
  Position? get currentPosition => _currentPosition;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    Future.microtask(() => notifyListeners());

    try {
      // Intentar asegurar que el perfil exista (para Task 1)
      await _datasource.ensureProfileExists();
      
      // Intentar obtener ubicación (para Task 3)
      await _updateUserLocation();

      final results = await Future.wait([
        _datasource.getProfiles(
          myLat: _currentPosition?.latitude,
          myLon: _currentPosition?.longitude,
        ),
        _datasource.getFeedPosts(),
        _datasource.getConversations(),
      ]);

      _profiles = results[0];
      _posts = results[1];
      _conversations = results[2];

      // Ordenar perfiles por distancia si tenemos ubicación
      if (_currentPosition != null) {
        _profiles.sort((a, b) {
          final distA = _calculateDistance(a['latitude'], a['longitude']);
          final distB = _calculateDistance(b['latitude'], b['longitude']);
          return distA.compareTo(distB);
        });
      }

      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading community: $e');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  Future<void> _updateUserLocation() async {
    try {
      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }
      
      if (permission == LocationPermission.whileInUse || permission == LocationPermission.always) {
        _currentPosition = await Geolocator.getCurrentPosition();
        if (_currentPosition != null) {
          await _datasource.updateLocation(_currentPosition!.latitude, _currentPosition!.longitude);
        }
      }
    } catch (e) {
      debugPrint('Error getting location: $e');
    }
  }

  double _calculateDistance(dynamic lat, dynamic lon) {
    if (lat == null || lon == null || _currentPosition == null) return 999999.0;
    
    final double targetLat = (lat is num) ? lat.toDouble() : double.tryParse(lat.toString()) ?? 0.0;
    final double targetLon = (lon is num) ? lon.toDouble() : double.tryParse(lon.toString()) ?? 0.0;

    return Geolocator.distanceBetween(
      _currentPosition!.latitude,
      _currentPosition!.longitude,
      targetLat,
      targetLon,
    );
  }

  String getDistanceString(dynamic lat, dynamic lon) {
    final dist = _calculateDistance(lat, lon);
    if (dist > 100000) return '';
    if (dist < 1000) return '${dist.toStringAsFixed(0)}m away';
    return '${(dist / 1000).toStringAsFixed(1)}km away';
  }

  Future<void> refreshAll() async => loadAll();

  /// Crea un nuevo post
  Future<bool> createPost(String content) async {
    try {
      await _datasource.createPost(content);
      await loadAll();
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Toggle like
  Future<void> toggleLike(String postId) async {
    try {
      await _datasource.toggleLike(postId);
      // Actualización optimista local rápida (opcional pero recomendada)
      final index = _posts.indexWhere((p) => p['id'] == postId);
      if (index != -1) {
        final post = _posts[index];
        final bool currentlyLiked = post['is_liked'] ?? false;
        post['is_liked'] = !currentlyLiked;
        post['likes_count'] = (post['likes_count'] as int) + (currentlyLiked ? -1 : 1);
        notifyListeners();
      }
      // Luego refrescar de la DB por si acaso
      _posts = await _datasource.getFeedPosts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling like: $e');
    }
  }

  /// Agregar comentario
  Future<void> addComment(String postId, String content) async {
    try {
      await _datasource.addComment(postId, content);
      _postComments = await _datasource.getComments(postId);
      _posts = await _datasource.getFeedPosts();
      notifyListeners();
    } catch (e) {
      debugPrint('Error adding comment: $e');
    }
  }

  /// Cargar comentarios de un post
  Future<void> loadComments(String postId) async {
    try {
      _postComments = await _datasource.getComments(postId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading comments: $e');
    }
  }

  /// === CHAT LOGIC ===

  /// Carga los mensajes de una conversación específica
  Future<void> loadMessages(String conversationId) async {
    _currentMessages = [];
    notifyListeners();
    
    try {
      _currentMessages = await _datasource.getMessages(conversationId);
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading messages: $e');
    }
  }

  /// Envía un mensaje en una conversación
  Future<void> sendMessage(String conversationId, String receiverId, String text) async {
    try {
      await _datasource.sendMessage(
        conversationId: conversationId,
        receiverId: receiverId,
        text: text,
      );
      // No necesitamos agregarlo localmente porque el Realtime lo hará
    } catch (e) {
      debugPrint('Error sending message: $e');
    }
  }

  /// Inicia o recupera una conversación con un usuario
  Future<Map<String, dynamic>> startConversation(String otherUserId) async {
    try {
      final conversation = await _datasource.getOrCreateConversation(otherUserId);
      await refreshAll(); // Recargar lista de conversaciones
      return conversation;
    } catch (e) {
      debugPrint('Error starting conversation: $e');
      rethrow;
    }
  }

  /// Suscripción a cambios en tiempo real en los mensajes
  void subscribeToMessages(String conversationId) {
    debugPrint('📩 Subscribing to messages for: $conversationId');
    _messagesSubscription?.cancel();
    _messagesSubscription = _datasource.streamMessages(conversationId).listen((messages) {
      _currentMessages = messages;
      notifyListeners();
    });
  }

  /// Cancela la suscripción a mensajes
  void unsubscribeFromMessages() {
    debugPrint('🚫 Unsubscribing from messages');
    _messagesSubscription?.cancel();
    _messagesSubscription = null;
  }

  @override
  void dispose() {
    _messagesSubscription?.cancel();
    super.dispose();
  }
}
