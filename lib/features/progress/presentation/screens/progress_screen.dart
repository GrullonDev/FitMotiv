import 'package:fit_motiv/constants/app_colors.dart';
import 'package:fit_motiv/constants/app_text_styles.dart';
import 'package:fit_motiv/core/localization/locale_provider.dart';
import 'package:fit_motiv/features/progress/presentation/providers/progress_provider.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class ProgressScreen extends StatefulWidget {
  const ProgressScreen({super.key});

  @override
  State<ProgressScreen> createState() => _ProgressScreenState();
}

class _ProgressScreenState extends State<ProgressScreen> with SingleTickerProviderStateMixin {
  late AnimationController _rotationController;

  @override
  void initState() {
    super.initState();
    _rotationController = AnimationController(duration: const Duration(seconds: 1), vsync: this);
  }

  @override
  void dispose() {
    _rotationController.dispose();
    super.dispose();
  }

  void _handleRefresh(ProgressProvider provider) async {
    _rotationController.repeat();
    await provider.refreshAll();
    _rotationController.stop();
    _rotationController.reset();
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ProgressProvider>();

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: Text(context.watch<LocaleProvider>().translate('progress'), style: AppTextStyles.heading3),
          centerTitle: true,
          actions: [
            RotationTransition(
              turns: _rotationController,
              child: IconButton(
                icon: Icon(Icons.refresh, color: Theme.of(context).colorScheme.primary),
                onPressed: () => _handleRefresh(provider),
              ),
            ),
          ],
          bottom: TabBar(
            labelColor: Theme.of(context).colorScheme.primary,
            unselectedLabelColor: Theme.of(context).colorScheme.onSurfaceVariant,
            indicatorColor: Theme.of(context).colorScheme.primary,
            tabs: const [
              Tab(text: 'Resumen'),
              Tab(text: 'Peso'),
              Tab(text: 'Metas'),
            ],
          ),
        ),
        body: provider.isLoading
            ? Center(child: CircularProgressIndicator(color: Theme.of(context).colorScheme.primary))
            : TabBarView(
                children: [
                  _OverviewTab(provider: provider),
                  _WeightTab(provider: provider),
                  _GoalsTab(provider: provider),
                ],
              ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            // TODO: Abrir modal de registro
            _showActionSheet(context, provider);
          },
          label: const Text('Registrar'),
          icon: const Icon(Icons.add),
          backgroundColor: Theme.of(context).colorScheme.primary,
          foregroundColor: Colors.white,
        ),
      ),
    );
  }

  void _showActionSheet(BuildContext context, ProgressProvider provider) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
      builder: (ctx) => Container(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('¿Qué deseas registrar?', style: AppTextStyles.heading4),
            const SizedBox(height: 20),
            ListTile(
              leading: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF4ECDC4)),
              title: const Text('Registrar Peso'),
              onTap: () {
                Navigator.pop(ctx);
                _showWeightDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.flag_outlined, color: Colors.orange),
              title: const Text('Nueva Meta'),
              onTap: () {
                Navigator.pop(ctx);
                _showGoalDialog(context, provider);
              },
            ),
            ListTile(
              leading: const Icon(Icons.fitness_center, color: Colors.blue),
              title: const Text('Ir a Rutinas'),
              onTap: () {
                Navigator.pop(ctx);
                // Navigate to routines tab using bottom navigation
                DefaultTabController.of(context).animateTo(1);
              },
            ),
          ],
        ),
      ),
    );
  }

  void _showWeightDialog(BuildContext context, ProgressProvider provider) {
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Registrar Peso'),
        content: TextField(
          controller: controller,
          keyboardType: const TextInputType.numberWithOptions(decimal: true),
          decoration: InputDecoration(
            hintText: 'Peso en lbs',
            suffixText: 'lbs',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          autofocus: true,
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              final weight = double.tryParse(controller.text.trim());
              if (weight != null && weight > 0) {
                Navigator.pop(ctx);
                final success = await provider.logWeight(weight);
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Peso registrado')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Guardar', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showGoalDialog(BuildContext context, ProgressProvider provider) {
    final titleController = TextEditingController();
    final descController = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Nueva Meta'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: titleController,
              decoration: InputDecoration(
                hintText: 'Nombre de la meta',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              autofocus: true,
            ),
            const SizedBox(height: 12),
            TextField(
              controller: descController,
              decoration: InputDecoration(
                hintText: 'Descripción (opcional)',
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
              ),
              maxLines: 2,
            ),
          ],
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Cancelar')),
          ElevatedButton(
            onPressed: () async {
              if (titleController.text.trim().isNotEmpty) {
                Navigator.pop(ctx);
                final success = await provider.createGoal(
                  title: titleController.text.trim(),
                  description: descController.text.trim(),
                );
                if (success && context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('✅ Meta creada')));
                }
              }
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Crear', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

/// Tab de resumen general
class _OverviewTab extends StatelessWidget {
  const _OverviewTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshAll(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Stats cards row
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.fitness_center_outlined,
                    label: 'Sesiones',
                    value: '${provider.totalSessions}',
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    icon: Icons.local_fire_department_outlined,
                    label: 'Calorías',
                    value: '${provider.totalCalories}',
                    color: const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _StatBox(
                    icon: Icons.monitor_weight_outlined,
                    label: 'Peso Actual',
                    value: provider.latestWeight != null
                        ? '${provider.latestWeight!.toStringAsFixed(1)} lbs'
                        : 'Pendiente',
                    color: const Color(0xFF4ECDC4),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _StatBox(
                    icon: Icons.trending_down,
                    label: 'Diferencia',
                    value: provider.weightChange != null
                        ? '${provider.weightChange! >= 0 ? "+" : ""}${provider.weightChange!.toStringAsFixed(1)} lbs'
                        : '-- lbs',
                    color: provider.weightChange != null && provider.weightChange! < 0
                        ? AppColors.success
                        : const Color(0xFFFF6B6B),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),

            // Weekly Activity Chart
            Text('Actividad Semanal', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            _WeeklyActivityChart(sessions: provider.sessions),
            const SizedBox(height: 24),

            // Recent workout sessions
            Text('Sesiones Recientes', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            if (provider.sessions.isEmpty)
              _buildEmptyCard(
                context,
                'Sin sesiones aún',
                'Completa un entrenamiento para ver tu historial.',
                Icons.history,
              )
            else
              ...provider.sessions.take(3).map((session) => _SessionCard(session: session)),

            const SizedBox(height: 24),

            // Weight log
            Text('Historial de Peso', style: AppTextStyles.heading4),
            const SizedBox(height: 12),
            if (provider.weightLog.isEmpty)
              _buildEmptyCard(
                context,
                'Sin registros de peso',
                'Empieza a monitorear tu peso para ver el progreso.',
                Icons.monitor_weight_outlined,
              )
            else
              ...provider.weightLog.take(3).map((entry) => _WeightEntry(entry: entry, showDiff: false)),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyCard(BuildContext context, String title, String subtitle, IconData icon) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: AppColors.textSecondary.withValues(alpha: 0.4)),
          const SizedBox(height: 12),
          Text(title, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.w600)),
          const SizedBox(height: 4),
          Text(subtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Tab de peso
class _WeightTab extends StatelessWidget {
  const _WeightTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Weight Trend Chart
          Text('Tendencia de Peso', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          _WeightTrendChart(weightLog: provider.weightLog),
          const SizedBox(height: 24),

          // Weight History List
          Text('Historial Completo', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          if (provider.weightLog.isEmpty)
            _buildEmptyState(
              context,
              'Sin registros',
              'Registra tu peso para ver la evolución.',
              Icons.monitor_weight_outlined,
            )
          else
            ...List.generate(provider.weightLog.length, (index) {
              final entry = provider.weightLog[index];
              final previousEntry = index < provider.weightLog.length - 1 ? provider.weightLog[index + 1] : null;
              return _WeightEntry(entry: entry, previousEntry: previousEntry);
            }),
          const SizedBox(height: 80), // Space for FAB
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(color: AppColors.textSecondary.withValues(alpha: 0.05), shape: BoxShape.circle),
            child: Icon(icon, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          ),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

/// Tab de metas
class _GoalsTab extends StatelessWidget {
  const _GoalsTab({required this.provider});
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    return RefreshIndicator(
      color: Theme.of(context).colorScheme.primary,
      onRefresh: () => provider.refreshAll(),
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          // Predefined Goals Section (Task 7)
          Text('Metas Sugeridas', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                _SuggestedGoalCard(
                  title: 'Bajar de peso',
                  icon: Icons.trending_down,
                  color: Colors.blue,
                  onTap: () => provider.createGoal(
                    title: 'Bajar de peso',
                    description: 'Reducir mi peso corporal de forma saludable.',
                  ),
                ),
                _SuggestedGoalCard(
                  title: 'Ganar músculo',
                  icon: Icons.fitness_center,
                  color: Colors.orange,
                  onTap: () => provider.createGoal(
                    title: 'Ganar músculo',
                    description: 'Aumentar mi masa muscular con entrenamiento de fuerza.',
                  ),
                ),
                _SuggestedGoalCard(
                  title: 'Mantenerse',
                  icon: Icons.accessibility_new,
                  color: Colors.green,
                  onTap: () => provider.createGoal(
                    title: 'Mantenerse activo',
                    description: 'Mantener una rutina regular de ejercicios.',
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),

          Text('Mis Metas', style: AppTextStyles.heading4),
          const SizedBox(height: 12),
          if (provider.goals.isEmpty)
            _buildEmptyState(context, 'Sin metas', 'Establece objetivos para medir tu progreso.', Icons.flag_outlined)
          else
            ...provider.goals.map((goal) {
              return _GoalCard(goal: goal, provider: provider);
            }),
          const SizedBox(height: 80),
        ],
      ),
    );
  }

  Widget _buildEmptyState(BuildContext context, String title, String subtitle, IconData icon) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const SizedBox(height: 40),
          Icon(icon, size: 64, color: AppColors.textSecondary.withValues(alpha: 0.2)),
          const SizedBox(height: 16),
          Text(title, style: AppTextStyles.heading4),
          const SizedBox(height: 8),
          Text(subtitle, style: AppTextStyles.bodySmall, textAlign: TextAlign.center),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────

class _StatBox extends StatelessWidget {
  const _StatBox({required this.icon, required this.label, required this.value, required this.color});
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(color: color.withValues(alpha: 0.1), borderRadius: BorderRadius.circular(8)),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(height: 12),
          Text(value, style: AppTextStyles.heading3.copyWith(color: color, fontSize: 18)),
          const SizedBox(height: 4),
          Text(label, style: AppTextStyles.bodySmall.copyWith(color: AppColors.textSecondary, fontSize: 11)),
        ],
      ),
    );
  }
}

class _WeeklyActivityChart extends StatelessWidget {
  const _WeeklyActivityChart({required this.sessions});
  final List<Map<String, dynamic>> sessions;

  @override
  Widget build(BuildContext context) {
    // Calcular sesiones por día de la semana (últimos 7 días)
    final now = DateTime.now();
    final dayCounts = List.generate(7, (index) {
      final day = now.subtract(Duration(days: 6 - index));
      return sessions.where((s) {
        final date = DateTime.parse(s['completed_at'] as String);
        return date.year == day.year && date.month == day.month && date.day == day.day;
      }).length;
    });

    final days = ['L', 'M', 'M', 'J', 'V', 'S', 'D'];
    final todayIndex = now.weekday - 1;
    final last7Days = List.generate(7, (i) => days[(todayIndex - 6 + i + 7) % 7]);

    return Container(
      height: 180,
      padding: const EdgeInsets.fromLTRB(16, 24, 16, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (dayCounts.reduce((a, b) => a > b ? a : b) + 1).toDouble(),
          barTouchData: BarTouchData(enabled: false),
          titlesData: FlTitlesData(
            show: true,
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                getTitlesWidget: (value, meta) {
                  return Padding(
                    padding: const EdgeInsets.only(top: 8.0),
                    child: Text(last7Days[value.toInt()], style: AppTextStyles.bodySmall.copyWith(fontSize: 10)),
                  );
                },
                reservedSize: 28,
              ),
            ),
            leftTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          gridData: const FlGridData(show: false),
          borderData: FlBorderData(show: false),
          barGroups: List.generate(7, (i) {
            return BarChartGroupData(
              x: i,
              barRods: [
                BarChartRodData(
                  toY: dayCounts[i].toDouble(),
                  color: dayCounts[i] > 0
                      ? Theme.of(context).colorScheme.primary
                      : AppColors.textSecondary.withValues(alpha: 0.1),
                  width: 14,
                  borderRadius: const BorderRadius.vertical(top: Radius.circular(4)),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}

class _WeightTrendChart extends StatelessWidget {
  const _WeightTrendChart({required this.weightLog});
  final List<Map<String, dynamic>> weightLog;

  @override
  Widget build(BuildContext context) {
    final hasData = weightLog.isNotEmpty;
    final displayData = hasData ? weightLog.reversed.toList() : _getDemoData();

    return Container(
      height: 200,
      padding: const EdgeInsets.fromLTRB(16, 24, 24, 12),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Opacity(
        opacity: hasData ? 1.0 : 0.3,
        child: LineChart(
          LineChartData(
            gridData: const FlGridData(show: false),
            titlesData: FlTitlesData(
              show: true,
              bottomTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              topTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              rightTitles: const AxisTitles(sideTitles: SideTitles(showTitles: false)),
              leftTitles: AxisTitles(
                sideTitles: SideTitles(
                  showTitles: true,
                  reservedSize: 40,
                  getTitlesWidget: (value, meta) {
                    return Text('${value.toInt()}', style: AppTextStyles.bodySmall.copyWith(fontSize: 10));
                  },
                ),
              ),
            ),
            borderData: FlBorderData(show: false),
            lineBarsData: [
              LineChartBarData(
                spots: List.generate(displayData.length, (i) {
                  final weight = (displayData[i]['weight'] as num).toDouble();
                  return FlSpot(i.toDouble(), weight);
                }),
                isCurved: true,
                color: Theme.of(context).colorScheme.primary,
                barWidth: 4,
                isStrokeCapRound: true,
                dotData: const FlDotData(show: true),
                belowBarData: BarAreaData(
                  show: true,
                  color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<Map<String, dynamic>> _getDemoData() {
    return [
      {'weight': 185.0},
      {'weight': 183.5},
      {'weight': 184.2},
      {'weight': 181.8},
      {'weight': 180.5},
      {'weight': 179.0},
    ];
  }
}

class _SuggestedGoalCard extends StatelessWidget {
  const _SuggestedGoalCard({required this.title, required this.icon, required this.color, this.onTap});
  final String title;
  final IconData icon;
  final Color color;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 140,
        margin: const EdgeInsets.only(right: 12),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: color.withValues(alpha: 0.05),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: color.withValues(alpha: 0.1)),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, color: color, size: 28),
            const SizedBox(height: 8),
            Text(
              title,
              style: AppTextStyles.bodySmall.copyWith(fontWeight: FontWeight.bold, color: color),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

class _GoalCard extends StatelessWidget {
  const _GoalCard({required this.goal, required this.provider});
  final Map<String, dynamic> goal;
  final ProgressProvider provider;

  @override
  Widget build(BuildContext context) {
    final isCompleted = goal['is_completed'] as bool? ?? false;
    final title = goal['title'] as String? ?? '';
    final description = goal['description'] as String? ?? '';

    // Simular progreso para demostración (Task 8)
    double progress = isCompleted ? 1.0 : 0.45;
    String progressText = isCompleted ? "Meta alcanzada" : "Llevas 5 lbs de 20 lbs";

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 10, offset: const Offset(0, 4))],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: (isCompleted ? AppColors.success : Theme.of(context).colorScheme.primary).withValues(
                    alpha: 0.1,
                  ),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(
                  isCompleted ? Icons.check_circle : Icons.flag_outlined,
                  color: isCompleted ? AppColors.success : Theme.of(context).colorScheme.primary,
                  size: 22,
                ),
              ),
              const SizedBox(width: 14),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: AppTextStyles.bodyMedium.copyWith(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        decoration: isCompleted ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    if (description.isNotEmpty)
                      Text(description, style: AppTextStyles.bodySmall.copyWith(fontSize: 12)),
                  ],
                ),
              ),
              IconButton(
                icon: Icon(
                  isCompleted ? Icons.check_circle : Icons.radio_button_unchecked,
                  color: isCompleted ? AppColors.success : AppColors.textSecondary.withValues(alpha: 0.3),
                  size: 28,
                ),
                onPressed: () => provider.toggleGoal(goal['id'] as String, !isCompleted),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: AppColors.textSecondary.withValues(alpha: 0.1),
              valueColor: AlwaysStoppedAnimation<Color>(
                isCompleted ? AppColors.success : Theme.of(context).colorScheme.primary,
              ),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 8),
          Text(progressText, style: AppTextStyles.bodySmall.copyWith(fontSize: 11, fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}

class _SessionCard extends StatelessWidget {
  const _SessionCard({required this.session});
  final Map<String, dynamic> session;

  @override
  Widget build(BuildContext context) {
    final name = session['workout_name'] as String? ?? 'Entrenamiento';
    final duration = session['duration_minutes'] as int? ?? 0;
    final calories = session['calories_burned'] as int? ?? 0;
    final completedAt = session['completed_at'] as String? ?? '';

    String timeAgo = '';
    if (completedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(completedAt);
        final diff = DateTime.now().difference(date);
        if (diff.inDays > 0) {
          timeAgo = 'hace ${diff.inDays}d';
        } else if (diff.inHours > 0) {
          timeAgo = 'hace ${diff.inHours}h';
        } else {
          timeAgo = 'hace ${diff.inMinutes}m';
        }
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(Icons.fitness_center_outlined, color: Theme.of(context).colorScheme.primary, size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(name, style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(
                  '$duration min • $calories cal ${timeAgo.isNotEmpty ? "• $timeAgo" : ""}',
                  style: AppTextStyles.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _WeightEntry extends StatelessWidget {
  const _WeightEntry({required this.entry, this.previousEntry, this.showDiff = true});
  final Map<String, dynamic> entry;
  final Map<String, dynamic>? previousEntry;
  final bool showDiff;

  @override
  Widget build(BuildContext context) {
    final weight = (entry['weight'] as num?)?.toDouble() ?? 0;
    final recordedAt = entry['recorded_at'] as String? ?? '';

    double? diff;
    if (previousEntry != null) {
      final prevWeight = (previousEntry!['weight'] as num).toDouble();
      diff = weight - prevWeight;
    }

    String dateStr = '';
    if (recordedAt.isNotEmpty) {
      try {
        final date = DateTime.parse(recordedAt);
        dateStr = DateFormat('dd MMM').format(date);
      } catch (_) {}
    }

    return Container(
      margin: const EdgeInsets.only(bottom: 10),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Theme.of(context).cardTheme.color ?? Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.05), blurRadius: 8, offset: const Offset(0, 2))],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF4ECDC4).withValues(alpha: 0.1),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.monitor_weight_outlined, color: Color(0xFF4ECDC4), size: 20),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${weight.toStringAsFixed(1)} lbs',
                  style: AppTextStyles.bodyMedium.copyWith(fontWeight: FontWeight.bold),
                ),
                Text(dateStr, style: AppTextStyles.bodySmall),
              ],
            ),
          ),
          if (showDiff && diff != null)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: (diff <= 0 ? Colors.green : Colors.red).withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
              ),
              child: Text(
                '${diff > 0 ? "+" : ""}${diff.toStringAsFixed(1)}',
                style: AppTextStyles.bodySmall.copyWith(
                  color: diff <= 0 ? Colors.green : Colors.red,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
