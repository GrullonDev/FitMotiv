import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocaleProvider extends ChangeNotifier {
  LocaleProvider() {
    _loadLocale();
  }

  Locale _locale = const Locale('es');
  Locale get locale => _locale;

  void setLocale(Locale locale) async {
    if (!['en', 'es'].contains(locale.languageCode)) return;
    _locale = locale;
    notifyListeners();

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('language_code', locale.languageCode);
  }

  void _loadLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final languageCode = prefs.getString('language_code') ?? 'es';
    _locale = Locale(languageCode);
    notifyListeners();
  }

  String translate(String key) {
    // Basic translation map for core elements
    final Map<String, Map<String, String>> localizedValues = {
      'en': {
        'home': 'Home',
        'plans': 'Plans',
        'routines': 'Routines',
        'progress': 'Progress',
        'community': 'Community',
        'profile': 'Profile',
        'nutrition': 'Nutrition',
        'weight': 'Weight',
        'height': 'Height',
        'feed': 'Feed',
        'members': 'Members',
        'messages': 'Messages',
        'settings': 'Settings',
        'language': 'Language',
        'english': 'English',
        'spanish': 'Spanish',
        'no_posts': 'No posts yet',
        'no_members': 'No members yet',
        'no_conversations': 'No conversations yet',
        'post': 'Post',
        'chat': 'Chat',
        'start_new_chat': 'Start New Chat',
        'refresh': 'Refresh',
        'body_metrics': 'Body Metrics',
        'account_info': 'Account Info',
        'meal_plans': 'Meal Plans',
        'recipes': 'Recipes',
        'tips': 'Tips',
        'personalized_meal_plans': 'Personalized Meal Plans',
        'weight_loss_plan': 'Weight Loss Plan',
        'weight_loss_desc': 'Focus on calorie deficit and high protein.',
        'muscle_building': 'Muscle Building',
        'muscle_building_desc': 'High carb and high protein for bulk.',
        'view_plan': 'View Plan',
        'coming_soon': 'Coming Soon',
        'recommended': 'Recommended',
        'days': 'days',
        'beginner': 'Beginner',
        'advanced': 'Advanced',
        'recipes_placeholder': 'Delicious recipes coming soon to help your journey!',
        'tips_placeholder': 'Daily tips and advice will appear here.',
        'breakfast': 'Breakfast',
        'lunch': 'Lunch',
        'dinner': 'Dinner',
        'snacks': 'Snacks',
        'proteins': 'Proteins',
        'carbs': 'Carbs',
        'fats': 'Fats',
        'shopping_list': 'Shopping List',
        'water_tracker': 'Water Tracker',
        'glasses': 'glasses',
        'search_recipes': 'Search recipes...',
        'ingredients': 'Ingredients',
        'preparation': 'Preparation',
        'easy': 'Easy',
        'medium': 'Medium',
        'vegan': 'Vegan',
        'did_you_know': 'Did you know?',
        'water_target': 'Daily Target: 8 glasses',
        'water_reached': 'Great job! Stay hydrated.',
      },
      'es': {
        'home': 'Inicio',
        'plans': 'Planes',
        'routines': 'Rutinas',
        'progress': 'Progreso',
        'community': 'Comunidad',
        'profile': 'Perfil',
        'nutrition': 'Nutrición',
        'weight': 'Peso',
        'height': 'Altura',
        'feed': 'Noticias',
        'members': 'Miembros',
        'messages': 'Mensajes',
        'settings': 'Ajustes',
        'language': 'Idioma',
        'english': 'Inglés',
        'spanish': 'Español',
        'no_posts': 'Aún no hay publicaciones',
        'no_members': 'Aún no hay miembros',
        'no_conversations': 'Aún no hay conversaciones',
        'post': 'Publicar',
        'chat': 'Chat',
        'start_new_chat': 'Iniciar nuevo chat',
        'refresh': 'Refrescar',
        'body_metrics': 'Métricas Corporales',
        'account_info': 'Información de Cuenta',
        'meal_plans': 'Planes de Comida',
        'recipes': 'Recetas',
        'tips': 'Consejos',
        'personalized_meal_plans': 'Planes de Comida Personalizados',
        'weight_loss_plan': 'Plan de Pérdida de Peso',
        'weight_loss_desc': 'Enfoque en déficit calórico y alta proteína.',
        'muscle_building': 'Construcción Muscular',
        'muscle_building_desc': 'Alto en carbohidratos y proteínas para volumen.',
        'view_plan': 'Ver Plan',
        'coming_soon': 'Próximamente',
        'recommended': 'Recomendado',
        'days': 'días',
        'beginner': 'Principiante',
        'advanced': 'Avanzado',
        'recipes_placeholder': '¡Próximamente deliciosas recetas para ayudar en tu meta!',
        'tips_placeholder': 'Consejos diarios y recomendaciones aparecerán aquí.',
        'breakfast': 'Desayuno',
        'lunch': 'Almuerzo',
        'dinner': 'Cena',
        'snacks': 'Meriendas',
        'proteins': 'Proteínas',
        'carbs': 'Carbos',
        'fats': 'Grasas',
        'shopping_list': 'Lista de Compras',
        'water_tracker': 'Control de Agua',
        'glasses': 'vasos',
        'search_recipes': 'Buscar recetas...',
        'ingredients': 'Ingredientes',
        'preparation': 'Preparación',
        'easy': 'Fácil',
        'medium': 'Medio',
        'vegan': 'Vegano',
        'did_you_know': '¿Sabías que?',
        'water_target': 'Meta diaria: 8 vasos',
        'water_reached': '¡Buen trabajo! Mantente hidratado.',
      },
    };

    return localizedValues[_locale.languageCode]?[key] ?? key;
  }
}
