import 'package:get_it/get_it.dart';

import '../../features/auth/data/datasources/auth_datasource.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../network/services/api_service.dart';

/// Authentication module dependency injection configuration
/// This class follows the Dependency Injection principle and helps maintain
/// a clean separation of concerns for the authentication module
/// Now uses the generic ApiService instead of a specific AuthService
class AuthDI {
  static void init(GetIt sl) {
    // Register AuthDataSource
    sl.registerLazySingleton<AuthDataSource>(() => AuthRemoteDataSource(apiService: sl<ApiService>()));

    // Register AuthRepository
    sl.registerLazySingleton<AuthRepository>(() => AuthRepositoryImpl(remoteDataSource: sl<AuthDataSource>()));

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
