import 'package:dio/dio.dart';
import 'package:fit_motiv/core/network/error_handlers/api_error_handler.dart';

/// Servicio centralizado para extraer y formatear mensajes de error
/// Maneja tanto errores HTTP como errores específicos de la aplicación
class ErrorMessageExtractor {
  /// Extrae mensaje de error específico basado en el tipo de failure
  static String extractErrorMessage(dynamic failure) {
    if (failure == null) return 'Unknown error occurred';

    // Si es un ApiException del error handler
    if (failure is ApiException) {
      return _handleApiException(failure);
    }

    // Si es un DioException
    if (failure is DioException) {
      return _handleDioException(failure);
    }

    // Si es un string con información de error
    final failureString = failure.toString().toLowerCase();
    return _handleStringError(failureString);
  }

  /// Maneja errores de ApiException
  static String _handleApiException(ApiException exception) {
    // Verificar el tipo específico de ApiException
    if (exception is NetworkException) {
      return 'Network error. Please check your internet connection';
    } else if (exception is UnauthorizedException) {
      return 'Session expired. Please login again';
    } else if (exception is ForbiddenException) {
      return 'Access denied. You do not have permission for this action';
    } else if (exception is NotFoundException) {
      return 'Service not found. Please try again later';
    } else if (exception is ValidationException) {
      return _extractValidationMessage(exception.message);
    } else if (exception is ServerException) {
      return 'Internal server error. Please try again later';
    }

    // Fallback basado en status code
    if (exception.statusCode != null) {
      return _handleHttpStatusCode(exception.statusCode);
    }

    return exception.message;
  }

  /// Maneja errores de DioException
  static String _handleDioException(DioException exception) {
    switch (exception.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return 'Request timed out. Please try again';

      case DioExceptionType.connectionError:
        return 'Network error. Please check your internet connection';

      case DioExceptionType.badResponse:
        return _handleHttpStatusCode(exception.response?.statusCode);

      case DioExceptionType.cancel:
        return 'Request was cancelled';

      case DioExceptionType.unknown:
      default:
        return 'Network error occurred. Please try again';
    }
  }

  /// Maneja errores basados en códigos de estado HTTP
  static String _handleHttpStatusCode(int? statusCode) {
    if (statusCode == null) return 'Unknown server error occurred';

    switch (statusCode) {
      case 400:
        return 'Invalid request. Please check your information and try again';
      case 401:
        return 'Authentication failed. Please check your credentials';
      case 403:
        return 'Access denied. You do not have permission to perform this action';
      case 404:
        return 'Service not found. Please try again later';
      case 409:
        return 'Email address or username is already taken';
      case 422:
        return 'Invalid data provided. Please check all fields';
      case 429:
        return 'Too many requests. Please wait a moment before trying again';
      case 500:
        return 'Internal server error. Please try again later';
      case 502:
      case 503:
      case 504:
        return 'Service temporarily unavailable. Please try again later';
      default:
        return 'Server error (HTTP $statusCode). Please try again later';
    }
  }

  /// Maneja errores basados en strings de error
  static String _handleStringError(String failureString) {
    // Manejo específico de códigos de estado HTTP en strings
    if (failureString.contains('400')) {
      return 'Invalid request. Please check your information and try again';
    } else if (failureString.contains('401')) {
      return 'Authentication failed. Please check your credentials';
    } else if (failureString.contains('403')) {
      return 'Access denied. You do not have permission to perform this action';
    } else if (failureString.contains('404')) {
      return 'Service not found. Please try again later';
    } else if (failureString.contains('409')) {
      return 'Email address or username is already taken';
    } else if (failureString.contains('422')) {
      return 'Invalid data provided. Please check all fields';
    } else if (failureString.contains('429')) {
      return 'Too many requests. Please wait a moment before trying again';
    } else if (failureString.contains('500')) {
      return 'Internal server error. Please try again later';
    } else if (failureString.contains('502') || failureString.contains('503') || failureString.contains('504')) {
      return 'Service temporarily unavailable. Please try again later';
    }

    // Manejo de errores específicos de validación y aplicación
    if (failureString.contains('email')) {
      return 'Email address is invalid or already in use';
    } else if (failureString.contains('username')) {
      return 'Username is already taken';
    } else if (failureString.contains('password')) {
      return 'Password does not meet requirements';
    } else if (failureString.contains('token')) {
      return 'Your session has expired. Please login again';
    } else if (failureString.contains('network') || failureString.contains('connection')) {
      return 'Network error. Please check your internet connection';
    } else if (failureString.contains('timeout')) {
      return 'Request timed out. Please try again';
    } else if (failureString.contains('validation')) {
      return 'Please check your information and try again';
    }

    // Mensaje por defecto
    return 'An error occurred. Please try again';
  }

  /// Extrae mensaje específico de errores de validación
  static String _extractValidationMessage(String? message) {
    if (message == null || message.isEmpty) {
      return 'Please check your information and try again';
    }

    // Si el mensaje contiene información específica de validación
    final lowerMessage = message.toLowerCase();
    if (lowerMessage.contains('email')) {
      return 'Please enter a valid email address';
    } else if (lowerMessage.contains('password')) {
      return 'Password does not meet the requirements';
    } else if (lowerMessage.contains('username')) {
      return 'Username is not available';
    }

    return message;
  }
}
