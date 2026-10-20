import '../../../core/database/database.dart';

class QuotesRepository {
  QuotesRepository(this._db);
  final Database _db;

  Future<Map<String, dynamic>?> getRandomQuote() async {
    final result = await _db.query(
      '''
      SELECT id, text, author, category
      FROM quotes
      ORDER BY random()
      LIMIT 1
      ''',
    );

    if (result.isEmpty) return null;

    final row = result.first;
    return {
      'id': row[0],
      'text': row[1],
      'author': row[2],
      'category': row[3],
    };
  }

  Future<List<Map<String, dynamic>>> getQuotes({String? category}) async {
    final conditions = <String>[];
    final parameters = <String, dynamic>{};

    if (category != null && category.isNotEmpty) {
      conditions.add('category = @category');
      parameters['category'] = category;
    }

    final where =
        conditions.isEmpty ? '' : 'WHERE ${conditions.join(' AND ')}';

    final result = await _db.query(
      '''
      SELECT id, text, author, category
      FROM quotes
      $where
      ORDER BY random()
      ''',
      parameters: parameters,
    );

    return result
        .map((row) => {
              'id': row[0],
              'text': row[1],
              'author': row[2],
              'category': row[3],
            })
        .toList();
  }
}
