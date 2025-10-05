/// Utility class for logging HTTP responses and status codes
/// Helps with debugging and monitoring API responses
class HttpResponseLogger {
  static const String _tag = 'HttpResponse';

  /// Log successful HTTP responses with their status codes
  static void logSuccess({
    required String endpoint,
    required int statusCode,
    String? operation,
    Map<String, dynamic>? data,
  }) {
    final operationText = operation != null ? ' ($operation)' : '';
    print('$_tag SUCCESS$operationText: $endpoint - Status $statusCode'); // ignore: avoid_print

    if (data != null && data.isNotEmpty) {
      print('$_tag Response Data Keys: ${data.keys.toList()}'); // ignore: avoid_print
    }
  }

  /// Log error HTTP responses with their status codes and details
  static void logError({
    required String endpoint,
    required int? statusCode,
    String? operation,
    String? errorMessage,
    dynamic errorData,
  }) {
    final operationText = operation != null ? ' ($operation)' : '';
    final statusText = statusCode != null ? ' - Status $statusCode' : '';

    print('$_tag ERROR$operationText: $endpoint$statusText'); // ignore: avoid_print

    if (errorMessage != null) {
      print('$_tag Error Message: $errorMessage'); // ignore: avoid_print
    }

    if (errorData != null) {
      print('$_tag Error Data: $errorData'); // ignore: avoid_print
    }
  }

  /// Check if status code indicates success (200-299 range)
  static bool isSuccessStatusCode(int? statusCode) {
    return statusCode != null && statusCode >= 200 && statusCode < 300;
  }

  /// Get human-readable description of HTTP status code
  static String getStatusCodeDescription(int statusCode) {
    switch (statusCode) {
      case 200:
        return 'OK - Request successful';
      case 201:
        return 'Created - Resource created successfully';
      case 202:
        return 'Accepted - Request accepted for processing';
      case 204:
        return 'No Content - Request successful, no content returned';
      case 400:
        return 'Bad Request - Invalid request format';
      case 401:
        return 'Unauthorized - Authentication required';
      case 403:
        return 'Forbidden - Access denied';
      case 404:
        return 'Not Found - Resource not found';
      case 409:
        return 'Conflict - Resource already exists';
      case 422:
        return 'Unprocessable Entity - Validation failed';
      case 429:
        return 'Too Many Requests - Rate limit exceeded';
      case 500:
        return 'Internal Server Error - Server error';
      case 502:
        return 'Bad Gateway - Invalid response from upstream server';
      case 503:
        return 'Service Unavailable - Server temporarily unavailable';
      case 504:
        return 'Gateway Timeout - Upstream server timeout';
      default:
        return 'HTTP $statusCode - Unknown status code';
    }
  }
}
