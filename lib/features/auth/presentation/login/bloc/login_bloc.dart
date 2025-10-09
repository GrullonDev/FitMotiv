import 'package:fit_motiv/core/utils/snackbar_service.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginBloc extends ChangeNotifier {
  LoginBloc({required AuthRepository authRepository}) : _authRepository = authRepository;

  final AuthRepository _authRepository;

  // Controllers para los campos del formulario
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  // Estado del formulario
  bool _isLoading = false;
  String? _errorMessage;
  String? _successMessage;
  dynamic _loginData; // Para almacenar datos del login (tokens)

  // Getters
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;
  String? get successMessage => _successMessage;
  dynamic get loginData => _loginData;

  // Setters para limpiar errores
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
    _loginData = null;
    notifyListeners();
  }

  Future<void> login() async {
    if (!_validateForm()) return;

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    notifyListeners();

    try {
      final request = LoginRequest(username: usernameController.text.trim(), password: passwordController.text.trim());

      final result = await _authRepository.login(request);

      result.fold(
        (failure) {
          _isLoading = false;
          _errorMessage = failure.message;
          SnackBarService.showError(failure.message);
          notifyListeners();
        },
        (response) {
          _isLoading = false;

          // Verificar si la respuesta tiene errores
          if (response.hasError) {
            _errorMessage = response.errorMessage;
            SnackBarService.showError(response.errorMessage);
          } else {
            _loginData = response;
            _successMessage = 'Login successful! Welcome back.';
            SnackBarService.showSuccess('Login successful! Welcome back.');

            // Aquí podrías guardar los tokens en storage seguro
            // TODO: Implementar almacenamiento de tokens
          }

          notifyListeners();
        },
      );
    } catch (error) {
      _isLoading = false;
      _errorMessage = 'An unexpected error occurred. Please try again.';
      SnackBarService.showError('An unexpected error occurred. Please try again.');
      notifyListeners();
    }
  }

  bool _validateForm() {
    // Validar campos requeridos
    if (usernameController.text.trim().isEmpty) {
      _errorMessage = 'Username is required';
      notifyListeners();
      return false;
    }

    if (passwordController.text.trim().isEmpty) {
      _errorMessage = 'Password is required';
      notifyListeners();
      return false;
    }

    if (passwordController.text.length < 6) {
      _errorMessage = 'Password must be at least 6 characters';
      notifyListeners();
      return false;
    }

    return true;
  }

  @override
  void dispose() {
    usernameController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
