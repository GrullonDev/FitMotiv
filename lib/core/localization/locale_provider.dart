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
      }
    };

    return localizedValues[_locale.languageCode]?[key] ?? key;
  }
}
