import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';
import 'package:fit_motiv/models/sample_data.dart';

/// Data source local que obtiene citas de la data local
class QuoteLocalDatasource {
  Future<Quote> getRandomQuote() async {
    final random = DateTime.now().millisecondsSinceEpoch;
    final index = random % SampleData.motivationalQuotes.length;
    return Quote(SampleData.motivationalQuotes[index]);
  }
}
