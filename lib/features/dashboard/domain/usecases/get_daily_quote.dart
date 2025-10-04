import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';

class GetDailyQuote {

  GetDailyQuote(this.repository);
  final QuoteRepository repository;

  Future<Quote> call() async {
    return await repository.getRandomQuote();
  }
}
