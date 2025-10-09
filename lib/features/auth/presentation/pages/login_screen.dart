// This file exports the LoginPage from our new login implementation
// Updated to use the new structure with BLoC pattern
import 'package:fit_motiv/features/auth/presentation/login/pages/login_page.dart';

// Re-export LoginPage as LoginScreen for backward compatibility
class LoginScreen extends LoginPage {
  const LoginScreen({super.key});
}
