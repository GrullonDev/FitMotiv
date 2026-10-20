import 'package:fit_motiv/features/progress/domain/entities/progress_record.dart';

class GetProgressRecords {
  Future<List<ProgressRecordEntity>> call() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return [
      ProgressRecordEntity(
        date: DateTime.now().subtract(const Duration(days: 1)),
        weight: 150,
      ),
      ProgressRecordEntity(date: DateTime.now(), weight: 149.5),
    ];
  }
}
