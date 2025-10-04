import 'package:fit_motiv/features/plans/domain/entities/meal_plan.dart';

class GetMealPlans {
  Future<List<MealPlanEntity>> call() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [MealPlanEntity(id: 'mp1', title: 'Week 1 Plan')];
  }
}
