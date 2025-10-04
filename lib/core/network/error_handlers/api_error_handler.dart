import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';

/// Custom exception classes for API errors
/// These exceptions can be used across all modules in the application
abstract class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final String? endpoint;

  const ApiException(this.message, {this.statusCode, this.endpoint});

  @override
  String toString() => 'ApiException: $message (Status: $statusCode, Endpoint: $endpoint)';
}

class ServerException extends ApiException {
  const ServerException(super.message, {super.statusCode, super.endpoint});
}

class NetworkException extends ApiException {
  const NetworkException(super.message, {super.statusCode, super.endpoint});
}

class UnauthorizedException extends ApiException {
  const UnauthorizedException(super.message, {super.statusCode, super.endpoint});
}

class ForbiddenException extends ApiException {
  const ForbiddenException(super.message, {super.statusCode, super.endpoint});
}

class NotFoundException extends ApiException {
  const NotFoundException(super.message, {super.statusCode, super.endpoint});
}

class ValidationException extends ApiException {
  final Map<String, List<String>>? errors;

  const ValidationException(super.message, {super.statusCode, super.endpoint, this.errors});

  @override
  String toString() => 'ValidationException: $message (Errors: $errors, Status: $statusCode, Endpoint: $endpoint)';
}

class TokenExpiredException extends ApiException {
  const TokenExpiredException(super.message, {super.statusCode, super.endpoint});
}

class AccountDeactivatedException extends ApiException {
  const AccountDeactivatedException(super.message, {super.statusCode, super.endpoint});
}

class EmailNotVerifiedException extends ApiException {
  const EmailNotVerifiedException(super.message, {super.statusCode, super.endpoint});
}

class RateLimitException extends ApiException {
  const RateLimitException(super.message, {super.statusCode, super.endpoint});
}

class ConflictException extends ApiException {
  const ConflictException(super.message, {super.statusCode, super.endpoint});
}

class PaymentRequiredException extends ApiException {
  const PaymentRequiredException(super.message, {super.statusCode, super.endpoint});
}

class TooManyRequestsException extends ApiException {
  const TooManyRequestsException(super.message, {super.statusCode, super.endpoint});
}

/// Generic error handler for all API-related HTTP errors
/// This handler can be used across all modules (auth, fitness, nutrition, etc.)
/// Implements Single Responsibility Principle by focusing only on error handling
class ApiErrorHandler {
  /// Handle DioException and convert to appropriate ApiException
  static ApiException handleDioError(DioException error) {
    final endpoint = error.requestOptions.path;

    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        return NetworkException(
          'Connection timeout. Please check your internet connection and try again.',
          endpoint: endpoint,
        );

      case DioExceptionType.connectionError:
        return NetworkException('Connection error. Please check your internet connection.', endpoint: endpoint);

      case DioExceptionType.badResponse:
        return _handleHttpError(error);

      case DioExceptionType.cancel:
        return NetworkException('Request was cancelled.', endpoint: endpoint);

      case DioExceptionType.unknown:
      default:
        return ServerException('An unexpected error occurred: ${error.message}', endpoint: endpoint);
    }
  }

  /// Handle HTTP response errors based on status codes
  static ApiException _handleHttpError(DioException error) {
    final response = error.response;
    final statusCode = response?.statusCode;
    final data = response?.data;
    final endpoint = error.requestOptions.path;

    // Extract error message from response
    String message = 'An error occurred';
    Map<String, List<String>>? validationErrors;

    if (data is Map<String, dynamic>) {
      message = data['message'] ?? data['error'] ?? data['detail'] ?? message;

      // Handle validation errors (Laravel/Django style)
      if (data['errors'] is Map) {
        validationErrors = Map<String, List<String>>.from(
          data['errors'].map(
            (key, value) => MapEntry(key.toString(), List<String>.from(value is List ? value : [value.toString()])),
          ),
        );
      }

      // Handle Django Rest Framework style errors
      if (data['non_field_errors'] is List) {
        validationErrors = {'non_field_errors': List<String>.from(data['non_field_errors'])};
      }
    }

    switch (statusCode) {
      case 400:
        if (validationErrors != null) {
          return ValidationException(message, statusCode: statusCode, endpoint: endpoint, errors: validationErrors);
        }
        return ServerException(message, statusCode: statusCode, endpoint: endpoint);

      case 401:
        // Check for specific unauthorized scenarios
        if (_isTokenExpired(message)) {
          return TokenExpiredException(message, statusCode: statusCode, endpoint: endpoint);
        }
        if (_isEmailNotVerified(message)) {
          return EmailNotVerifiedException(message, statusCode: statusCode, endpoint: endpoint);
        }
        return UnauthorizedException(message, statusCode: statusCode, endpoint: endpoint);

      case 402:
        return PaymentRequiredException(
          'Payment required to access this feature.',
          statusCode: statusCode,
          endpoint: endpoint,
        );

      case 403:
        if (_isAccountDeactivated(message)) {
          return AccountDeactivatedException(message, statusCode: statusCode, endpoint: endpoint);
        }
        return ForbiddenException(message, statusCode: statusCode, endpoint: endpoint);

      case 404:
        return NotFoundException('The requested resource was not found.', statusCode: statusCode, endpoint: endpoint);

      case 409:
        return ConflictException(
          message.isEmpty ? 'Conflict occurred. Resource already exists or is in use.' : message,
          statusCode: statusCode,
          endpoint: endpoint,
        );

      case 422:
        return ValidationException(message, statusCode: statusCode, endpoint: endpoint, errors: validationErrors);

      case 429:
        return TooManyRequestsException(
          'Too many requests. Please wait before trying again.',
          statusCode: statusCode,
          endpoint: endpoint,
        );

      case 500:
      case 502:
      case 503:
      case 504:
        return ServerException('Server error. Please try again later.', statusCode: statusCode, endpoint: endpoint);

      default:
        return ServerException(message, statusCode: statusCode, endpoint: endpoint);
    }
  }

  /// Check if error indicates token expiration
  static bool _isTokenExpired(String message) {
    final lowercaseMessage = message.toLowerCase();
    return lowercaseMessage.contains('token') &&
        (lowercaseMessage.contains('expired') ||
            lowercaseMessage.contains('invalid') ||
            lowercaseMessage.contains('revoked'));
  }

  /// Check if error indicates email not verified
  static bool _isEmailNotVerified(String message) {
    final lowercaseMessage = message.toLowerCase();
    return lowercaseMessage.contains('email') &&
        (lowercaseMessage.contains('verify') ||
            lowercaseMessage.contains('verified') ||
            lowercaseMessage.contains('confirmation'));
  }

  /// Check if error indicates account deactivation
  static bool _isAccountDeactivated(String message) {
    final lowercaseMessage = message.toLowerCase();
    return lowercaseMessage.contains('deactivated') ||
        lowercaseMessage.contains('suspended') ||
        lowercaseMessage.contains('banned') ||
        lowercaseMessage.contains('disabled');
  }

  /// Convert ApiException to Either<Failure, T> pattern for clean architecture
  static Left<ApiException, T> toFailure<T>(ApiException exception) {
    return Left(exception);
  }

  /// Handle any general exception and convert to ApiException
  static ApiException handleGeneralError(Object error, StackTrace stackTrace, {String? endpoint}) {
    if (error is DioException) {
      return handleDioError(error);
    }

    if (error is ApiException) {
      return error;
    }

    return ServerException('An unexpected error occurred: ${error.toString()}', endpoint: endpoint);
  }

  /// Get user-friendly error message for UI display
  static String getUserFriendlyMessage(ApiException exception) {
    switch (exception.runtimeType) {
      case NetworkException:
        return 'No internet connection. Please check your network settings.';
      case UnauthorizedException:
        return 'Please log in to continue.';
      case TokenExpiredException:
        return 'Your session has expired. Please log in again.';
      case EmailNotVerifiedException:
        return 'Please verify your email address before continuing.';
      case AccountDeactivatedException:
        return 'Your account has been deactivated. Please contact support.';
      case ValidationException:
        final validationException = exception as ValidationException;
        if (validationException.errors?.isNotEmpty == true) {
          return validationException.errors!.values.first.first;
        }
        return exception.message;
      case NotFoundException:
        return 'The requested item could not be found.';
      case RateLimitException:
      case TooManyRequestsException:
        return 'Too many requests. Please wait a moment and try again.';
      case PaymentRequiredException:
        return 'Subscription required to access this feature.';
      case ConflictException:
        return 'This action conflicts with existing data.';
      case ServerException:
        return 'Server error. Please try again later.';
      default:
        return exception.message.isNotEmpty ? exception.message : 'An unexpected error occurred.';
    }
  }
}

/// Extension to add convenient error handling to Future<Response>
extension ApiResponseExtension on Future<Response> {
  /// Convert Future<Response> to Future<Either<ApiException, Response>>
  Future<Either<ApiException, Response>> toEither() async {
    try {
      final response = await this;
      return Right(response);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e, stackTrace) {
      return Left(ApiErrorHandler.handleGeneralError(e, stackTrace));
    }
  }

  /// Convert Future<Response> to Future<Either<ApiException, T>>
  /// with custom data transformation
  Future<Either<ApiException, T>> toEitherWithTransform<T>(T Function(dynamic data) transform) async {
    try {
      final response = await this;
      final transformedData = transform(response.data);
      return Right(transformedData);
    } on DioException catch (e) {
      return Left(ApiErrorHandler.handleDioError(e));
    } catch (e, stackTrace) {
      return Left(ApiErrorHandler.handleGeneralError(e, stackTrace));
    }
  }
}
