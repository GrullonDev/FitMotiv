import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/database/database.dart';
import '../../../../lib/core/utils/json_response.dart';
import '../../../../lib/features/quotes/data/quotes_repository.dart';

Future<Response> onRequest(RequestContext context) async {
  if (context.request.method != HttpMethod.get) return methodNotAllowed();

  final db = context.read<Database>();
  final repo = QuotesRepository(db);
  final params = context.request.uri.queryParameters;

  final quotes = await repo.getQuotes(category: params['category']);
  return jsonOk(quotes);
}
