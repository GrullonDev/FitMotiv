import 'package:dbcrypt/dbcrypt.dart';

class PasswordHasher {
  static final _crypt = DBCrypt();

  static String hash(String password) {
    final salt = _crypt.gensaltWithRounds(12);
    return _crypt.hashpw(password, salt);
  }

  static bool verify(String password, String hashedPassword) {
    return _crypt.checkpw(password, hashedPassword);
  }
}
