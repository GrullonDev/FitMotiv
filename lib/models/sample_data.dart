class WorkoutData {

  WorkoutData({
    required this.name,
    required this.description,
    required this.duration,
    required this.difficulty,
    required this.equipment,
    required this.category,
  });
  final String name;
  final String description;
  final int duration; // in minutes
  final String difficulty;
  final List<String> equipment;
  final String category;
}

class RecipeData {

  RecipeData({
    required this.name,
    required this.description,
    required this.prepTime,
    required this.calories,
    required this.rating,
    required this.ingredients,
    required this.instructions,
  });
  final String name;
  final String description;
  final int prepTime; // in minutes
  final int calories;
  final double rating;
  final List<String> ingredients;
  final List<String> instructions;
}

// Datos de ejemplo
class SampleData {
  static List<WorkoutData> workouts = [
    WorkoutData(
      name: 'Quick Cardio Blast',
      description: 'Get your heart pumping with this high-intensity workout.',
      duration: 15,
      difficulty: 'Intermediate',
      equipment: ['None'],
      category: 'Cardio',
    ),
    WorkoutData(
      name: 'Strength Builder',
      description:
          'Build lean muscle with this focused strength training session.',
      duration: 30,
      difficulty: 'Beginner',
      equipment: ['Dumbbells'],
      category: 'Strength',
    ),
    WorkoutData(
      name: 'Yoga Flow',
      description: 'Relax and stretch with this gentle yoga sequence.',
      duration: 20,
      difficulty: 'Beginner',
      equipment: ['Yoga Mat'],
      category: 'Flexibility',
    ),
  ];

  static List<RecipeData> recipes = [
    RecipeData(
      name: 'Avocado Toast with Egg',
      description:
          'A nutritious and delicious breakfast option to start your day right.',
      prepTime: 10,
      calories: 320,
      rating: 4.8,
      ingredients: [
        '1 slice whole grain bread',
        '1/2 ripe avocado',
        '1 egg',
        'Salt and pepper to taste',
        'Optional: cherry tomatoes',
      ],
      instructions: [
        'Toast the bread until golden brown',
        'Mash the avocado and spread on toast',
        'Cook the egg to your preference',
        'Place egg on top of avocado',
        'Season with salt and pepper',
        'Garnish with cherry tomatoes if desired',
      ],
    ),
    RecipeData(
      name: 'Protein Smoothie Bowl',
      description:
          'A refreshing and protein-packed smoothie bowl perfect post-workout.',
      prepTime: 5,
      calories: 280,
      rating: 4.9,
      ingredients: [
        '1 banana',
        '1/2 cup mixed berries',
        '1 scoop protein powder',
        '1/2 cup almond milk',
        'Granola for topping',
      ],
      instructions: [
        'Blend banana, berries, protein powder, and almond milk',
        'Pour into a bowl',
        'Top with granola and fresh fruit',
        'Enjoy immediately',
      ],
    ),
  ];

  static List<String> motivationalQuotes = [
    "The only bad workout is the one that didn't happen.",
    "Your body can do it. It's your mind you need to convince.",
    "Fitness is not about being better than someone else. It's about being better than you used to be.",
    "The groundwork for all happiness is good health.",
    "Take care of your body. It's the only place you have to live.",
    "Every workout is progress, no matter how small.",
    "Strong is the new beautiful.",
    "Your only limit is you.",
  ];
}
