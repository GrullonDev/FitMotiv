import 'package:flutter/material.dart';
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
  bool _isLoading = false;
  String? _error;

  List<Map<String, dynamic>> get profiles => _profiles;
  List<Map<String, dynamic>> get posts => _posts;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        _datasource.getProfiles(),
        _datasource.getFeedPosts(),
      ]);
      _profiles = results[0];
      _posts = results[1];
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading community: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
}
