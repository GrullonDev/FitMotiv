import '../entities/quote.dart';
import '../repositories/quote_repository.dart';

class GetDailyQuote {
  final QuoteRepository repository;

  GetDailyQuote(this.repository);

  Future<Quote> call() async {
    return await repository.getRandomQuote();
  }
}
