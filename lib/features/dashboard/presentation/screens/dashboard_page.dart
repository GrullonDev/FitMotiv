import 'package:fit_motiv/utils/custom_app_bar.dart';
import 'package:material_ui/material_ui.dart';

class DashboardPage extends StatelessWidget {
  const DashboardPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF00E676),
      appBar: CustomAppBar(userName: 'Maya', streakDays: 12),
    );
  }
}
