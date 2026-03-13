import 'package:flutter/material.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:fit_motiv/features/profile_settings/data/datasources/profile_supabase_datasource.dart';
import 'package:fit_motiv/features/profile_settings/data/models/user_profile_model.dart';

/// Provider que gestiona el estado del perfil del usuario.
/// Carga los datos desde Supabase Auth metadata y los expone a la UI.
class UserProfileProvider extends ChangeNotifier {
  UserProfileProvider({required ProfileSupabaseDatasource datasource})
      : _datasource = datasource {
    loadProfile();
  }

  final ProfileSupabaseDatasource _datasource;

  UserProfileModel? _profile;
  bool _isLoading = false;
  String? _error;

  UserProfileModel? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  /// Nombre para mostrar del usuario actual
  String get displayName => _profile?.displayName ?? 'User';

  /// Initiales del usuario para avatar
  String get initials => _profile?.initials ?? '?';

  /// Carga el perfil del usuario actual
  Future<void> loadProfile() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final data = await _datasource.getCurrentProfile();
      _profile = UserProfileModel.fromMap(data);
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading profile: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Refresca el perfil
  Future<void> refreshProfile() async {
    await loadProfile();
  }

  /// Actualiza el perfil del usuario
  Future<bool> updateProfile(Map<String, dynamic> data) async {
    try {
      await _datasource.updateProfile(data);
      await loadProfile(); // Reload to get fresh data
      return true;
    } catch (e) {
      _error = e.toString();
      notifyListeners();
      return false;
    }
  }

  /// Selecciona una imagen y la sube como avatar
  Future<bool> pickAndUploadAvatar() async {
    try {
      final ImagePicker picker = ImagePicker();
      final XFile? image = await picker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 70, // Compresión básica
        maxWidth: 512,
        maxHeight: 512,
      );

      if (image == null) return false;

      _isLoading = true;
      notifyListeners();

      final url = await _datasource.uploadAvatar(File(image.path));
      await updateProfile({'avatar_url': url});
      
      return true;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error uploading avatar: $e');
      return false;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Diferencia de peso
  double get weightDifference => _profile?.weightDifference ?? 0.0;
  
  /// Porcentaje de progreso
  double get weightProgressPercent => _profile?.weightProgressPercent ?? 0.0;

  /// Limpia el perfil (para logout)
  void clearProfile() {
    _profile = null;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }
}
