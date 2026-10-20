import 'package:dio/dio.dart';
import 'package:fit_motiv/core/di/auth_di.dart';
import 'package:fit_motiv/core/di/network_di.dart';
import 'package:fit_motiv/core/services/analytics_service.dart';
import 'package:fit_motiv/core/services/notification_service.dart';
import 'package:fit_motiv/features/community/data/datasources/community_stub_datasource.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/dashboard/data/datasources/quote_local_datasource.dart';
import 'package:fit_motiv/features/dashboard/data/repositories/quote_repository_impl.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';
import 'package:fit_motiv/features/dashboard/domain/usecases/get_daily_quote.dart';
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fit_motiv/features/plans/data/datasources/plans_api_datasource.dart';
import 'package:fit_motiv/features/plans/presentation/providers/plans_provider.dart';
import 'package:fit_motiv/features/profile_settings/data/datasources/profile_api_datasource.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/features/progress/data/datasources/progress_api_datasource.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fit_motiv/features/routines/data/datasources/workout_api_datasource.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_provider.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_session_provider.dart';
import 'package:get_it/get_it.dart';

final sl = GetIt.instance;

Future<void> init() async {
  await sl.reset();

  NetworkDI.init(sl);
  AuthDI.init(sl);

  final dio = sl<Dio>(instanceName: 'mainDio');
  final baseUrl = dio.options.baseUrl;

  // ─────────────────────────────────────────
  // Dashboard feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<QuoteLocalDatasource>(() => QuoteLocalDatasource());
  sl.registerLazySingleton<QuoteRepository>(() => QuoteRepositoryImpl(localDatasource: sl<QuoteLocalDatasource>()));
  sl.registerLazySingleton<GetDailyQuote>(() => GetDailyQuote(sl<QuoteRepository>()));
  sl.registerFactory<DashboardProvider>(() => DashboardProvider(getDailyQuote: sl<GetDailyQuote>()));

  // ─────────────────────────────────────────
  // Profile feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<ProfileApiDatasource>(
    () => ProfileApiDatasource(dio: dio, baseUrl: baseUrl),
  );
  sl.registerFactory<UserProfileProvider>(
    () => UserProfileProvider(datasource: sl<ProfileApiDatasource>()),
  );

  // ─────────────────────────────────────────
  // Routines/Workouts feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<WorkoutApiDatasource>(
    () => WorkoutApiDatasource(dio: dio, baseUrl: baseUrl),
  );
  sl.registerFactory<WorkoutProvider>(
    () => WorkoutProvider(datasource: sl<WorkoutApiDatasource>()),
  );
  sl.registerFactory<WorkoutSessionProvider>(
    () => WorkoutSessionProvider(
      progressDatasource: sl<ProgressApiDatasource>(),
      analyticsService: sl<AnalyticsService>(),
    ),
  );

  // ─────────────────────────────────────────
  // Progress feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<ProgressApiDatasource>(
    () => ProgressApiDatasource(dio: dio, baseUrl: baseUrl),
  );
  sl.registerFactory<ProgressProvider>(
    () => ProgressProvider(datasource: sl<ProgressApiDatasource>(), analyticsService: sl<AnalyticsService>()),
  );

  // ─────────────────────────────────────────
  // Community feature (stub until backend supports it)
  // ─────────────────────────────────────────
  sl.registerLazySingleton<CommunityStubDatasource>(() => CommunityStubDatasource());
  sl.registerFactory<CommunityProvider>(() => CommunityProvider(datasource: sl<CommunityStubDatasource>()));

  // ─────────────────────────────────────────
  // Plans/Nutrition feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<PlansApiDatasource>(
    () => PlansApiDatasource(dio: dio, baseUrl: baseUrl),
  );
  sl.registerFactory<PlansProvider>(() => PlansProvider(datasource: sl<PlansApiDatasource>()));

  // ─────────────────────────────────────────
  // Services
  // ─────────────────────────────────────────
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
  sl.registerLazySingleton<AnalyticsService>(() => AnalyticsService());
}
