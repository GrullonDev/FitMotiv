import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';
import 'package:fit_motiv/features/dashboard/data/datasources/quote_local_datasource.dart';

/// Implementación de [QuoteRepository] usando data source local
class QuoteRepositoryImpl implements QuoteRepository {

  QuoteRepositoryImpl({required this.localDatasource});
  final QuoteLocalDatasource localDatasource;

  @override
  Future<Quote> getRandomQuote() {
    return localDatasource.getRandomQuote();
  }
}
