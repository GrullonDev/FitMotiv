import 'package:dart_frog/dart_frog.dart';

import '../../../../lib/core/middleware/auth_middleware.dart';

Handler middleware(Handler handler) {
  return handler.use(authMiddleware());
}
