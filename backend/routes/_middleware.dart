import 'package:dart_frog/dart_frog.dart';

import '../lib/core/database/database.dart';
import '../lib/core/middleware/request_logger.dart' as logger;
import '../lib/server_init.dart';

Handler middleware(Handler handler) {
  return handler
      .use(logger.requestLogger())
      .use(provider<Database>((_) => Database.instance))
      .use(_initMiddleware());
}

Middleware _initMiddleware() {
  return (handler) {
    return (context) async {
      await ensureInitialized();
      return handler(context);
    };
  };
}
