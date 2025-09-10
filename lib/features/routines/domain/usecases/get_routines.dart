import '../entities/routine.dart';

class GetRoutines {
  Future<List<RoutineEntity>> call() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [RoutineEntity(id: 'r1', name: 'Cardio Blast', duration: 30)];
  }
}
