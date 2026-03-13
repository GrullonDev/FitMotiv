import 'package:supabase_flutter/supabase_flutter.dart';

/// Datasource que obtiene quotes motivacionales desde Supabase.
/// Tiene fallback a quotes locales si la tabla no existe aún.
class QuoteSupabaseDatasource {
  final SupabaseClient _client = Supabase.instance.client;

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

  /// Obtiene una quote random desde Supabase, con fallback local
  Future<Map<String, dynamic>> getRandomQuote() async {
    try {
      final response = await _client
          .from('quotes')
          .select()
          .limit(20);

      final quotes = List<Map<String, dynamic>>.from(response);
      if (quotes.isEmpty) return _fallbackQuote();

      final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
      final index = dayOfYear % quotes.length;
      return quotes[index];
    } catch (_) {
      return _fallbackQuote();
    }
  }

  Map<String, dynamic> _fallbackQuote() {
    final dayOfYear = DateTime.now().difference(DateTime(DateTime.now().year)).inDays;
    final index = dayOfYear % _fallbackQuotes.length;
    return {
      'text': _fallbackQuotes[index],
      'author': 'Unknown',
    };
  }
}
