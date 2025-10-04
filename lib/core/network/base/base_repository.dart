import 'package:dartz/dartz.dart';

import '../error_handlers/api_error_handler.dart';

/// Generic base interface for all repositories in the application
/// This interface provides common patterns that all repositories should follow
/// Follows Dependency Inversion Principle by depending on abstractions
abstract class BaseRepository {
  /// Handle common repository operations with error handling
  Future<Either<ApiException, T>> handleRepositoryCall<T>(Future<Either<ApiException, T>> Function() repositoryCall);
}

/// Base implementation of BaseRepository
/// Provides common functionality for all repository implementations
/// Implements error handling and logging patterns
abstract class BaseRepositoryImpl implements BaseRepository {
  @override
  Future<Either<ApiException, T>> handleRepositoryCall<T>(
    Future<Either<ApiException, T>> Function() repositoryCall,
  ) async {
    try {
      return await repositoryCall();
    } catch (e, stackTrace) {
      final exception = ApiErrorHandler.handleGeneralError(e, stackTrace);
      return Left(exception);
    }
  }

  /// Handle successful operations that might need token storage/update
  Future<Either<ApiException, Map<String, dynamic>>> handleAuthenticationResult(
    Either<ApiException, Map<String, dynamic>> result,
  ) async {
    return result.fold((failure) => Left(failure), (data) async {
      // Here you could implement token storage logic
      // Example:
      // if (data.containsKey('token')) {
      //   await _tokenStorage.saveToken(data['token']);
      // }
      // if (data.containsKey('refresh_token')) {
      //   await _tokenStorage.saveRefreshToken(data['refresh_token']);
      // }
      return Right(data);
    });
  }

  /// Handle operations that should clear authentication on success
  Future<Either<ApiException, Map<String, dynamic>>> handleLogoutResult(
    Either<ApiException, Map<String, dynamic>> result,
  ) async {
    return result.fold((failure) => Left(failure), (data) async {
      // Here you could implement token clearing logic
      // Example:
      // await _tokenStorage.clearToken();
      // await _tokenStorage.clearRefreshToken();
      // await _userPreferences.clearUserData();
      return Right(data);
    });
  }

  /// Handle operations that might need user profile caching
  Future<Either<ApiException, Map<String, dynamic>>> handleProfileResult(
    Either<ApiException, Map<String, dynamic>> result,
  ) async {
    return result.fold((failure) => Left(failure), (data) async {
      // Here you could implement profile caching logic
      // Example:
      // if (data.containsKey('user')) {
      //   await _userPreferences.saveUserProfile(data['user']);
      // }
      return Right(data);
    });
  }

  /// Handle paginated responses
  Either<ApiException, Map<String, dynamic>> handlePaginatedResult(Either<ApiException, Map<String, dynamic>> result) {
    return result.fold((failure) => Left(failure), (data) {
      // Normalize paginated response structure
      if (data.containsKey('results') || data.containsKey('data')) {
        return Right(data);
      }

      // If response is already a list, wrap it with pagination info
      if (data['data'] is List) {
        return Right({'results': data['data'], 'count': (data['data'] as List).length, 'next': null, 'previous': null});
      }

      return Right(data);
    });
  }

  /// Transform repository response to domain model
  Either<ApiException, T> transformToModel<T>(
    Either<ApiException, Map<String, dynamic>> result,
    T Function(Map<String, dynamic>) transformer,
  ) {
    return result.fold((failure) => Left(failure), (data) {
      try {
        final model = transformer(data);
        return Right(model);
      } catch (e, stackTrace) {
        final exception = ApiErrorHandler.handleGeneralError(e, stackTrace);
        return Left(exception);
      }
    });
  }

  /// Transform repository response to list of domain models
  Either<ApiException, List<T>> transformToModelList<T>(
    Either<ApiException, Map<String, dynamic>> result,
    T Function(Map<String, dynamic>) transformer, {
    String dataKey = 'data',
  }) {
    return result.fold((failure) => Left(failure), (data) {
      try {
        List<dynamic> rawList;

        // Extract list from different possible structures
        if (data[dataKey] is List) {
          rawList = data[dataKey];
        } else if (data['results'] is List) {
          rawList = data['results'];
        } else if (data['items'] is List) {
          rawList = data['items'];
        } else {
          rawList = [];
        }

        final models = rawList.cast<Map<String, dynamic>>().map(transformer).toList();

        return Right(models);
      } catch (e, stackTrace) {
        final exception = ApiErrorHandler.handleGeneralError(e, stackTrace);
        return Left(exception);
      }
    });
  }
}
