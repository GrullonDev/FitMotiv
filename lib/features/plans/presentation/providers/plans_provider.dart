import 'package:fit_motiv/features/plans/data/datasources/plans_supabase_datasource.dart';
import 'package:flutter/material.dart';

/// Provider que gestiona los datos de nutrición y planes desde Supabase
class PlansProvider extends ChangeNotifier {
  PlansProvider({required PlansSupabaseDatasource datasource}) : _datasource = datasource {
    loadAll();
  }

  final PlansSupabaseDatasource _datasource;

  List<Map<String, dynamic>> _mealPlans = [];
  List<Map<String, dynamic>> _recipes = [];
  List<Map<String, dynamic>> _tips = [];
  List<Map<String, dynamic>> _articles = [];
  Map<String, dynamic>? _dailyRecipe;
  int _todayWaterGlasses = 0;
  bool _isLoading = false;
  String? _error;
  String _selectedCategory = '';

  List<Map<String, dynamic>> get mealPlans => _mealPlans;
  List<Map<String, dynamic>> get recipes => _recipes;
  List<Map<String, dynamic>> get tips => _tips;
  List<Map<String, dynamic>> get articles => _articles;
  Map<String, dynamic>? get dailyRecipe => _dailyRecipe;
  int get todayWaterGlasses => _todayWaterGlasses;
  bool get isLoading => _isLoading;
  String? get error => _error;
  String get selectedCategory => _selectedCategory;

  /// Recipes filtradas por categoría seleccionada
  List<Map<String, dynamic>> get filteredRecipes {
    if (_selectedCategory.isEmpty) return _recipes;
    return _recipes.where((r) => r['category'] == _selectedCategory).toList();
  }

  /// Categorías disponibles de las recetas
  List<String> get availableCategories {
    final cats = _recipes.map((r) => r['category'] as String? ?? '').where((c) => c.isNotEmpty).toSet().toList();
    cats.sort();
    return cats;
  }

  /// Carga todo el contenido de nutrición
  Future<void> loadAll() async {
    _isLoading = true;
    _error = null;
    Future.microtask(() => notifyListeners());

    try {
      final results = await Future.wait([
        _datasource.getMealPlans(),
        _datasource.getRecipes(),
        _datasource.getTips(),
        _datasource.getArticles(),
        _datasource.getRandomRecipe(),
        _datasource.getTodayWaterGlasses().then((v) => v),
      ]);

      _mealPlans = results[0] as List<Map<String, dynamic>>;
      _recipes = results[1] as List<Map<String, dynamic>>;
      _tips = results[2] as List<Map<String, dynamic>>;
      _articles = results[3] as List<Map<String, dynamic>>;
      _dailyRecipe = results[4] as Map<String, dynamic>?;
      _todayWaterGlasses = results[5] as int;
      _error = null;
    } catch (e) {
      _error = e.toString();
      debugPrint('❌ Error loading plans: $e');
    } finally {
      _isLoading = false;
      Future.microtask(() => notifyListeners());
    }
  }

  /// Selecciona una categoría de filtro
  void selectCategory(String category) {
    _selectedCategory = _selectedCategory == category ? '' : category;
    notifyListeners();
  }

  /// Agrega un vaso de agua y persiste en Supabase
  Future<void> addWaterGlass() async {
    if (_todayWaterGlasses < 20) {
      _todayWaterGlasses++;
      notifyListeners();
      await _datasource.updateWaterGlasses(_todayWaterGlasses);
    }
  }

  /// Refresca todos los datos
  Future<void> refreshAll() async => loadAll();
}
