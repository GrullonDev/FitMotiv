import 'package:fit_motiv/features/dashboard/data/datasources/quote_api_datasource.dart';
import 'package:fit_motiv/features/dashboard/data/datasources/quote_local_datasource.dart';
import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';

class QuoteRepositoryImpl implements QuoteRepository {
  QuoteRepositoryImpl({
    required this.apiDatasource,
    required this.localDatasource,
  });

  final QuoteApiDatasource apiDatasource;
  final QuoteLocalDatasource localDatasource;

  @override
  Future<Quote> getRandomQuote() async {
    try {
      final data = await apiDatasource.getRandomQuote();
      final text = data['text'] as String? ?? '';
      if (text.isNotEmpty) return Quote(text);
    } catch (_) {}
    return localDatasource.getRandomQuote();
  }
}
