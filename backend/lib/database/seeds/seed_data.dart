import '../../core/database/database.dart';

class SeedData {
  SeedData(this._db);
  final Database _db;

  Future<void> run() async {
    await _seedQuotes();
    await _seedWorkouts();
    await _seedMealPlans();
    await _seedRecipes();
  }

  Future<void> _seedQuotes() async {
    final result = await _db.query('SELECT count(*) FROM quotes');
    final count = result.first[0] as int;
    if (count > 0) return;

    await _db.query(r'''
      INSERT INTO quotes (text, author, category) VALUES
        ('The only bad workout is the one that didn''t happen.', 'Unknown', 'workout'),
        ('Your body can do it. It''s your mind you need to convince.', 'Unknown', 'motivation'),
        ('Fitness is not about being better than someone else. It''s about being better than you used to be.', 'Khloe Kardashian', 'fitness'),
        ('The groundwork for all happiness is good health.', 'Leigh Hunt', 'health'),
        ('Take care of your body. It''s the only place you have to live.', 'Jim Rohn', 'health'),
        ('Every workout is progress, no matter how small.', 'Unknown', 'workout'),
        ('Strong is the new beautiful.', 'Unknown', 'motivation'),
        ('Your only limit is you.', 'Unknown', 'motivation'),
        ('The pain you feel today will be the strength you feel tomorrow.', 'Arnold Schwarzenegger', 'workout'),
        ('Don''t wish for a good body, work for it.', 'Unknown', 'motivation')
    ''');
  }

  Future<void> _seedWorkouts() async {
    final result = await _db.query('SELECT count(*) FROM workouts');
    final count = result.first[0] as int;
    if (count > 0) return;

    await _db.query(r'''
      INSERT INTO workouts (name, description, duration, difficulty, category, equipment, is_public) VALUES
        ('Quick Cardio Blast', 'Get your heart pumping with this high-intensity workout.', 15, 'Intermediate', 'Cardio', ARRAY['None'], true),
        ('Strength Builder', 'Build lean muscle with this focused strength training session.', 30, 'Beginner', 'Strength', ARRAY['Dumbbells'], true),
        ('Yoga Flow', 'Relax and stretch with this gentle yoga sequence.', 20, 'Beginner', 'Flexibility', ARRAY['Yoga Mat'], true),
        ('HIIT Extreme', 'Push your limits with this high-intensity interval session.', 25, 'Advanced', 'Cardio', ARRAY['None'], true),
        ('Full Body Burn', 'Complete full-body workout targeting all major muscle groups.', 45, 'Intermediate', 'Full Body', ARRAY['Dumbbells', 'Resistance Bands'], true),
        ('Core Crusher', 'Strengthen your core with these targeted exercises.', 20, 'Intermediate', 'Core', ARRAY['Yoga Mat'], true)
    ''');
  }

  Future<void> _seedMealPlans() async {
    final result = await _db.query('SELECT count(*) FROM meal_plans');
    final count = result.first[0] as int;
    if (count > 0) return;

    await _db.query(r'''
      INSERT INTO meal_plans (title, description, calories, icon, badge_text, is_recommended) VALUES
        ('Plan Para Bajar de Peso', 'Plan de alimentación balanceado diseñado para perder grasa de forma saludable.', '1,500 - 1,800 kcal', 'restaurant', '7 días', true),
        ('Plan Ganancia Muscular', 'Plan alto en proteínas para apoyar el crecimiento muscular.', '2,500 - 3,000 kcal', 'fitness_center', 'Avanzado', false),
        ('Plan Keto', 'Dieta cetogénica baja en carbohidratos para una rápida quema de grasa.', '1,800 - 2,200 kcal', 'eco', 'Popular', false)
    ''');
  }

  Future<void> _seedRecipes() async {
    final result = await _db.query('SELECT count(*) FROM recipes');
    final count = result.first[0] as int;
    if (count > 0) return;

    await _db.query(r'''
      INSERT INTO recipes (title, description, time, calories, category, rating) VALUES
        ('Tostada de Aguacate', 'Un desayuno nutritivo y delicioso para empezar bien el día.', '15 min', '320 kcal', 'Vegano', 4.8),
        ('Ensalada de Quinoa', 'Rica en proteínas y fibra, perfecta para después del entrenamiento.', '20 min', '450 kcal', 'Vegano', 4.6),
        ('Batido de Frutos Rojos', 'Antioxidantes naturales en un batido refrescante.', '5 min', '250 kcal', 'Vegano', 4.9),
        ('Salmón a la Parrilla', 'Rico en omega-3 con vegetales asados.', '25 min', '550 kcal', 'Alta Proteína', 4.7)
    ''');
  }
}
