import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/core/utils/snackbar_service.dart';
import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';
import 'package:flutter/material.dart';

class LoginBloc extends ChangeNotifier {
  LoginBloc({required AuthRepository authRepository, required AnalyticsService analyticsService})
    : _authRepository = authRepository,
      _analyticsService = analyticsService;

  final AuthRepository _authRepository;
  final AnalyticsService _analyticsService;

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

  // Flag para mostrar opción de reenviar verificación
  bool _isEmailNotConfirmed = false;
  bool get isEmailNotConfirmed => _isEmailNotConfirmed;

  Future<void> login() async {
    if (!_validateForm()) return;

    _isLoading = true;
    _errorMessage = null;
    _successMessage = null;
    _isEmailNotConfirmed = false;
    notifyListeners();

    try {
      final request = LoginRequest(username: usernameController.text.trim(), password: passwordController.text.trim());

      final result = await _authRepository.login(request);

      result.fold(
        (failure) {
          _isLoading = false;

          // Detectar si es error de email no confirmado
          if (failure.message.toLowerCase().contains('email') &&
              (failure.message.toLowerCase().contains('confirm') || failure.message.toLowerCase().contains('verify'))) {
            _isEmailNotConfirmed = true;
            _errorMessage = 'Please verify your email before signing in. Check your inbox for a confirmation link.';
            SnackBarService.showWarning(_errorMessage!);
          } else {
            _errorMessage = failure.message;
            SnackBarService.showError(failure.message);
          }

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
            _analyticsService.logLogin('email');
            SnackBarService.showSuccess('Login successful! Welcome back.');
          }

          notifyListeners();
        },
      );
    } catch (error) {
      _isLoading = false;
      final errorStr = error.toString();

      // Detectar error de email no confirmado desde excepción cruda de Supabase
      if (errorStr.contains('email_not_confirmed')) {
        _isEmailNotConfirmed = true;
        _errorMessage = 'Please verify your email before signing in. Check your inbox for a confirmation link.';
        SnackBarService.showWarning(_errorMessage!);
      } else {
        _errorMessage = 'An unexpected error occurred. Please try again.';
        SnackBarService.showError(_errorMessage!);
      }

      notifyListeners();
    }
  }

  /// Reenviar correo de verificación de email
  Future<void> resendVerificationEmail() async {
    final email = usernameController.text.trim();
    if (email.isEmpty) {
      SnackBarService.showError('Please enter your email first.');
      return;
    }

    try {
      _isLoading = true;
      notifyListeners();

      await _authRepository.resendVerification({'email': email});

      _isLoading = false;
      SnackBarService.showSuccess('Verification email sent! Check your inbox.');
      notifyListeners();
    } catch (e) {
      _isLoading = false;
      SnackBarService.showError('Could not resend verification email. Please try again later.');
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
