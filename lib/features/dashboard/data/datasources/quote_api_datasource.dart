import 'package:dio/dio.dart';

class QuoteApiDatasource {
  QuoteApiDatasource({required Dio dio, required String baseUrl})
      : _dio = dio,
        _baseUrl = baseUrl;

  final Dio _dio;
  final String _baseUrl;

  static const _fallbackQuotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can do it. It's your mind you need to convince.",
    "Fitness is not about being better than someone else. It's about being better than you used to be.",
    "The groundwork for all happiness is good health.",
    "Take care of your body. It's the only place you have to live.",
    "Every workout is progress, no matter how small.",
    "Strong is the new beautiful.",
    "Your only limit is you.",
  ];

  Future<Map<String, dynamic>> getRandomQuote() async {
    try {
      final response = await _dio.get('$_baseUrl/v1/quotes/random');
      final data = response.data;
      if (data is Map<String, dynamic>) {
        if (data.containsKey('data') && data['data'] is Map) {
          return data['data'] as Map<String, dynamic>;
        }
        return data;
      }
      return _fallbackQuote();
    } catch (_) {
      return _fallbackQuote();
    }
  }

  Map<String, dynamic> _fallbackQuote() {
    final dayOfYear =
        DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % _fallbackQuotes.length;
    return {
      'text': _fallbackQuotes[index],
      'author': 'Unknown',
    };
  }
}
