import 'package:fit_motiv/features/auth/domain/entities/user.dart';

class LoginUser {
  Future<UserEntity> call(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 300));
    return UserEntity(id: '1', name: 'Mock User', email: email);
  }
}
