import 'package:fit_motiv/features/community/data/datasources/community_supabase_datasource.dart';
import 'package:fit_motiv/core/services/notification_service.dart';
import 'package:fit_motiv/features/community/presentation/providers/community_provider.dart';
import 'package:fit_motiv/features/dashboard/data/datasources/quote_local_datasource.dart';
import 'package:fit_motiv/features/dashboard/data/datasources/quote_supabase_datasource.dart';
import 'package:fit_motiv/features/dashboard/data/repositories/quote_repository_impl.dart';
import 'package:fit_motiv/features/dashboard/domain/repositories/quote_repository.dart';
import 'package:fit_motiv/features/dashboard/domain/usecases/get_daily_quote.dart';
import 'package:fit_motiv/features/dashboard/presentation/providers/dashboard_provider.dart';
import 'package:fit_motiv/features/profile_settings/data/datasources/profile_supabase_datasource.dart';
import 'package:fit_motiv/features/profile_settings/presentation/providers/user_profile_provider.dart';
import 'package:fit_motiv/features/progress/data/datasources/progress_supabase_datasource.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fit_motiv/features/routines/data/datasources/workout_supabase_datasource.dart';
import 'package:fit_motiv/features/routines/presentation/providers/workout_provider.dart';
import 'package:get_it/get_it.dart';

import 'package:fit_motiv/core/di/auth_di.dart';
import 'package:fit_motiv/core/di/network_di.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Reset all previous registrations to handle hot reload/restart
  // This ensures new registrations are always applied
  await sl.reset();

  // Initialize core network dependencies first
  NetworkDI.init(sl);

  // Initialize feature-specific modules
  AuthDI.init(sl);

  // ─────────────────────────────────────────
  // Dashboard feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<QuoteLocalDatasource>(() => QuoteLocalDatasource());
  sl.registerLazySingleton<QuoteSupabaseDatasource>(() => QuoteSupabaseDatasource());
  sl.registerLazySingleton<QuoteRepository>(
    () => QuoteRepositoryImpl(localDatasource: sl<QuoteLocalDatasource>()),
  );
  sl.registerLazySingleton<GetDailyQuote>(
    () => GetDailyQuote(sl<QuoteRepository>()),
  );
  sl.registerFactory<DashboardProvider>(
    () => DashboardProvider(getDailyQuote: sl<GetDailyQuote>()),
  );

  // ─────────────────────────────────────────
  // Profile feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<ProfileSupabaseDatasource>(
    () => ProfileSupabaseDatasource(),
  );
  sl.registerFactory<UserProfileProvider>(
    () => UserProfileProvider(datasource: sl<ProfileSupabaseDatasource>()),
  );

  // ─────────────────────────────────────────
  // Routines/Workouts feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<WorkoutSupabaseDatasource>(
    () => WorkoutSupabaseDatasource(),
  );
  sl.registerFactory<WorkoutProvider>(
    () => WorkoutProvider(datasource: sl<WorkoutSupabaseDatasource>()),
  );

  // ─────────────────────────────────────────
  // Progress feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<ProgressSupabaseDatasource>(
    () => ProgressSupabaseDatasource(),
  );
  sl.registerFactory<ProgressProvider>(
    () => ProgressProvider(datasource: sl<ProgressSupabaseDatasource>()),
  );

  // ─────────────────────────────────────────
  // Community feature
  // ─────────────────────────────────────────
  sl.registerLazySingleton<CommunitySupabaseDatasource>(
    () => CommunitySupabaseDatasource(),
  );
  sl.registerFactory<CommunityProvider>(
    () => CommunityProvider(datasource: sl<CommunitySupabaseDatasource>()),
  );

  // ─────────────────────────────────────────
  // Services
  // ─────────────────────────────────────────
  sl.registerLazySingleton<NotificationService>(() => NotificationService());
}
