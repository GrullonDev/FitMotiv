import 'package:fit_motiv/features/dashboard/data/datasources/quote_local_datasource.dart';
import 'package:fit_motiv/features/dashboard/data/repositories/quote_repository_impl.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';
import 'package:fit_motiv/features/dashboard/domain/usecases/get_daily_quote.dart';
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:get_it/get_it.dart';

import 'auth_di.dart';
import 'network_di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Initialize core network dependencies first
  NetworkDI.init(sl);

  // Initialize feature-specific modules
  AuthDI.init(sl);

  // Dashboard feature dependencies
  // Data sources
  sl.registerLazySingleton<QuoteLocalDatasource>(() => QuoteLocalDatasource());
  // Repositories
  sl.registerLazySingleton<QuoteRepository>(() => QuoteRepositoryImpl(localDatasource: sl<QuoteLocalDatasource>()));
  // Use cases
  sl.registerLazySingleton<GetDailyQuote>(() => GetDailyQuote(sl<QuoteRepository>()));
  // Presentation - Providers
  sl.registerFactory<DashboardProvider>(() => DashboardProvider(getDailyQuote: sl<GetDailyQuote>()));
}
