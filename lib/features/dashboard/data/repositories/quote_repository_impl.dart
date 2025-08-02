import '../../domain/entities/quote.dart';
import '../../domain/repositories/quote_repository.dart';
import '../datasources/quote_local_datasource.dart';

/// Implementación de [QuoteRepository] usando data source local
class QuoteRepositoryImpl implements QuoteRepository {
  final QuoteLocalDatasource localDatasource;

  QuoteRepositoryImpl({required this.localDatasource});

  @override
  Future<Quote> getRandomQuote() {
    return localDatasource.getRandomQuote();
  }
}
