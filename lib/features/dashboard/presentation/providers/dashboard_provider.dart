import 'package:flutter/material.dart';
import 'package:fit_motiv/features/dashboard/domain/entities/quote.dart';
import 'package:fit_motiv/features/dashboard/domain/usecases/get_daily_quote.dart';

/// Provider para el dashboard que gestiona la cita diaria
class DashboardProvider extends ChangeNotifier {
  final GetDailyQuote getDailyQuote;
  Quote? _quote;
  bool _loading = false;

  DashboardProvider({required this.getDailyQuote}) {
    fetchQuote();
  }

  Quote? get quote => _quote;
  bool get loading => _loading;

  Future<void> fetchQuote() async {
    _loading = true;
    notifyListeners();
    _quote = await getDailyQuote();
    _loading = false;
    notifyListeners();
  }
}
