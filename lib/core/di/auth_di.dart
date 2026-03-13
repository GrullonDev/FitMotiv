import 'package:get_it/get_it.dart';

import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_supabase_datasource.dart';
import 'package:fit_motiv/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';

class AuthDI {
  static void init(GetIt sl) {
    // Register AuthDataSource (Supabase implementation)
    sl.registerLazySingleton<AuthDataSource>(
      () => AuthSupabaseDataSource(),
    );

    // Register AuthRepository
    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl<AuthDataSource>()),
    );

    // Add Use Cases here when created
    // Example:
    // sl.registerLazySingleton<LoginUseCase>(
    //   () => LoginUseCase(sl<AuthRepository>()),
    // );

    // Add Providers/BLoCs here when created
    // Example:
    // sl.registerFactory<AuthProvider>(
    //   () => AuthProvider(loginUseCase: sl<LoginUseCase>()),
    // );
  }
}
