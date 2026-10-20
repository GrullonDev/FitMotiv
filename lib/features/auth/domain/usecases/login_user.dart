import 'package:fit_motiv/features/auth/data/model/request/login_request.dart';
import 'package:fit_motiv/features/auth/domain/entities/user.dart';
import 'package:fit_motiv/features/auth/domain/repositories/auth_repository.dart';

class LoginUser {
  LoginUser(this.repository);
  final AuthRepository repository;

  Future<UserEntity> call(String email, String password) async {
    final result = await repository.login(LoginRequest(username: email, password: password));

    return result.fold(
      (failure) => throw Exception(failure.message),
      (response) => UserEntity(id: '0', name: 'User', email: email),
    );
  }
}
