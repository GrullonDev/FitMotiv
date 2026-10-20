import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'package:fit_motiv/core/services/token_storage.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_api_datasource.dart';
import 'package:fit_motiv/features/auth/data/datasources/auth_datasource.dart';
import 'package:fit_motiv/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';

class AuthDI {
  static void init(GetIt sl) {
    final dio = sl<Dio>(instanceName: 'mainDio');

    sl.registerLazySingleton<AuthDataSource>(
      () => AuthApiDataSource(
        dio: dio,
        baseUrl: dio.options.baseUrl,
        tokenStorage: sl<TokenStorage>(),
      ),
    );

    sl.registerLazySingleton<AuthRepository>(
      () => AuthRepositoryImpl(remoteDataSource: sl<AuthDataSource>()),
    );
  }
}
