import 'package:fit_motiv/core/routes/route_path.dart';
import 'package:fit_motiv/features/begin/splash_page.dart';
import 'package:fit_motiv/features/dashboard/presentation/screens/dashboard_page.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:material_ui/material_ui.dart';

class RouteSwitch {
  static PageRouteBuilder<dynamic> _instant(Widget page) {
    return PageRouteBuilder(
      pageBuilder: (_, _, _) => page,
      transitionDuration: const Duration(milliseconds: 200),
      reverseTransitionDuration: const Duration(milliseconds: 200),
      transitionsBuilder: (_, animation, _, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case RoutePath.splash:
        return _instant(SplashPage());
      case RoutePath.dashboard:
        return _instant(DashboardPage());
      default:
        return MaterialPageRoute(
          builder: (context) => Scaffold(
            body: Text(
              'Pagina No Encontrada!',
              textAlign: TextAlign.center,
              style: GoogleFonts.gabarito(
                fontSize: 35,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        );
    }
  }
}
