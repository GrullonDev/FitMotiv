import 'package:dartz/dartz.dart';

import 'package:fit_motiv/core/network/error_handlers/api_error_handler.dart';

/// Generic base interface for all data sources in the application
/// This interface provides common methods that all data sources should implement
/// Follows Interface Segregation Principle by providing only essential operations
abstract class BaseDataSource {
  /// Generic method to make API calls with automatic error handling
  Future<Either<ApiException, Map<String, dynamic>>> makeApiCall(
    Future<Map<String, dynamic>> Function() apiCall, {
    String? endpoint,
  });

  /// Generic method to make API calls that return lists
  Future<Either<ApiException, List<Map<String, dynamic>>>> makeApiCallForList(
    Future<List<Map<String, dynamic>>> Function() apiCall, {
    String? endpoint,
  });

  /// Generic method to make API calls that return raw data
  Future<Either<ApiException, T>> makeApiCallWithTransform<T>(
    Future<T> Function() apiCall, {
    String? endpoint,
  });
}

/// Base implementation of BaseDataSource
/// Provides common functionality for all remote data sources
/// Implements Single Responsibility Principle by handling only API call orchestration
abstract class BaseRemoteDataSource implements BaseDataSource {
  @override
  Future<Either<ApiException, Map<String, dynamic>>> makeApiCall(
    Future<Map<String, dynamic>> Function() apiCall, {
    String? endpoint,
  }) async {
    try {
      final result = await apiCall();
      return Right(result);
    } catch (e, stackTrace) {
      final exception = ApiErrorHandler.handleGeneralError(
        e,
        stackTrace,
        endpoint: endpoint,
      );
      return Left(exception);
    }
  }

  @override
  Future<Either<ApiException, List<Map<String, dynamic>>>> makeApiCallForList(
    Future<List<Map<String, dynamic>>> Function() apiCall, {
    String? endpoint,
  }) async {
    try {
      final result = await apiCall();
      return Right(result);
    } catch (e, stackTrace) {
      final exception = ApiErrorHandler.handleGeneralError(
        e,
        stackTrace,
        endpoint: endpoint,
      );
      return Left(exception);
    }
  }

  @override
  Future<Either<ApiException, T>> makeApiCallWithTransform<T>(
    Future<T> Function() apiCall, {
    String? endpoint,
  }) async {
    try {
      final result = await apiCall();
      return Right(result);
    } catch (e, stackTrace) {
      final exception = ApiErrorHandler.handleGeneralError(
        e,
        stackTrace,
        endpoint: endpoint,
      );
      return Left(exception);
    }
  }

  /// Helper method to extract data from API response
  /// Handles different response formats and ensures consistent data structure
  Map<String, dynamic> extractDataFromResponse(dynamic responseData) {
    if (responseData == null) {
      return <String, dynamic>{};
    }

    if (responseData is Map<String, dynamic>) {
      return responseData;
    }

    // If response is a list, wrap it in a data key
    if (responseData is List) {
      return <String, dynamic>{'data': responseData};
    }

    // If response is a primitive type, wrap it in a data key
    return <String, dynamic>{'data': responseData};
  }

  /// Helper method to extract list data from API response
  List<Map<String, dynamic>> extractListFromResponse(dynamic responseData) {
    if (responseData == null) {
      return <Map<String, dynamic>>[];
    }

    if (responseData is List) {
      return responseData.cast<Map<String, dynamic>>();
    }

    if (responseData is Map<String, dynamic>) {
      // Check if it's wrapped in a data key
      if (responseData['data'] is List) {
        return List<Map<String, dynamic>>.from(responseData['data']);
      }

      // If it's a single object, return it as a list
      return [responseData];
    }

    return <Map<String, dynamic>>[];
  }
}

/// Base interface for all repositories in the application
/// This interface provides common patterns that all repositories should follow
/// Follows Dependency Inversion Principle by depending on abstractions
abstract class BaseRepository {
  /// Handle common repository operations with error handling
  Future<Either<ApiException, T>> handleRepositoryCall<T>(
    Future<Either<ApiException, T>> Function() repositoryCall,
  );
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
  Either<ApiException, Map<String, dynamic>> handleAuthenticationResult(
    Either<ApiException, Map<String, dynamic>> result,
  ) {
    return result.fold((failure) => Left(failure), (data) {
      // Here you could implement token storage logic
      // Example: if (data.containsKey('token')) await _tokenStorage.saveToken(data['token']);
      return Right(data);
    });
  }

  /// Handle operations that should clear authentication on success
  Either<ApiException, Map<String, dynamic>> handleLogoutResult(
    Either<ApiException, Map<String, dynamic>> result,
  ) {
    return result.fold((failure) => Left(failure), (data) {
      // Here you could implement token clearing logic
      // Example: await _tokenStorage.clearToken();
      return Right(data);
    });
  }
}
