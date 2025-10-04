import 'package:fit_motiv/features/auth/data/model/request/register_request.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class RegisterBloc extends ChangeNotifier {
  RegisterBloc({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  // Controllers para los campos del formulario
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController fullNameController = TextEditingController();
  final TextEditingController bioController = TextEditingController();
  final TextEditingController ageController = TextEditingController();
  final TextEditingController heightController = TextEditingController();
  final TextEditingController weightController = TextEditingController();

  // Estado del formulario
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  String _fitnessGoal = '';
  String _activityLevel = '';
  dynamic _userData; // Para almacenar datos del usuario registrado

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  String get fitnessGoal => _fitnessGoal;
  String get activityLevel => _activityLevel;
  dynamic get userData => _userData;

  // Setters
  void setFitnessGoal(String goal) {
    _fitnessGoal = goal;
    notifyListeners();
  }

  void setActivityLevel(String level) {
    _activityLevel = level;
    notifyListeners();
  }

  void clearError() {
    _errorMessage = null;
    notifyListeners();
  }

  void clearSuccess() {
    _successMessage = null;
    notifyListeners();
  }

  void resetState() {
    _isLoading = false;
    _errorMessage = null;
    _successMessage = null;
    _userData = null;
    notifyListeners();
  }

  Future<void> register() async {
    if (!_validateForm()) return;

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final request = RegisterRequest(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
        username: usernameController.text.trim(),
        fullName: fullNameController.text.trim(),
        fitnesGoal: _fitnessGoal,
        bio: bioController.text.trim(),
        activityLevel: _activityLevel,
        age: int.tryParse(ageController.text.trim()) ?? 0,
        height: double.tryParse(heightController.text.trim()) ?? 0.0,
        weight: double.tryParse(weightController.text.trim()) ?? 0.0,
      );

      final result = await _authRepository.register(request);

      result.fold(
        (failure) {
          _isLoading = false;
          // Extraer mensaje de error específico del failure
          _errorMessage = _extractErrorMessage(failure);
          notifyListeners();
        },
        (userEntity) {
          _isLoading = false;
          _userData = userEntity;
          _successMessage = 'Account created successfully! Welcome to FitMotiv, ${fullNameController.text}!';
          // Aquí podrías hacer acciones adicionales como:
          // - Guardar token de autenticación
          // - Enviar analytics
          // - Inicializar configuraciones del usuario
          notifyListeners();
        },
      );
    } catch (e) {
      _isLoading = false;
      _errorMessage = 'Unexpected error occurred. Please try again later.\nDetails: ${e.toString()}';
      notifyListeners();
    }
  }

  String _extractErrorMessage(dynamic failure) {
    // Aquí implementas la lógica para extraer mensajes de error específicos
    // basado en el tipo de failure que uses en tu arquitectura

    if (failure == null) return 'Unknown error occurred';

    // Si el failure tiene un mensaje específico
    if (failure.toString().contains('email')) {
      return 'Email address is already in use or invalid';
    } else if (failure.toString().contains('username')) {
      return 'Username is already taken';
    } else if (failure.toString().contains('network')) {
      return 'Network error. Please check your internet connection';
    } else if (failure.toString().contains('server')) {
      return 'Server error. Please try again later';
    } else if (failure.toString().contains('validation')) {
      return 'Please check your information and try again';
    }

    // Mensaje por defecto con detalles del error
    return 'Registration failed: ${failure.toString()}';
  }

  bool _validateForm() {
    if (emailController.text.trim().isEmpty) {
      _errorMessage = 'El email es requerido';
      notifyListeners();
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      _errorMessage = 'La contraseña es requerida';
      notifyListeners();
      return false;
    }

    if (passwordController.text.trim() != confirmPasswordController.text.trim()) {
      _errorMessage = 'Las contraseñas no coinciden';
      notifyListeners();
      return false;
    }

    if (fullNameController.text.trim().isEmpty) {
      _errorMessage = 'El nombre completo es requerido';
      notifyListeners();
      return false;
    }

    if (usernameController.text.trim().isEmpty) {
      _errorMessage = 'El nombre de usuario es requerido';
      notifyListeners();
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    usernameController.dispose();
    fullNameController.dispose();
    bioController.dispose();
    ageController.dispose();
    heightController.dispose();
    weightController.dispose();
    super.dispose();
  }
}
