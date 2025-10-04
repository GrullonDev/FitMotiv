import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';

/// Repositorio abstracto que define los métodos de acceso a citas
abstract class QuoteRepository {
  Future<Quote> getRandomQuote();
}
