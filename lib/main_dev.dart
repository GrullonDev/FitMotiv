import 'package:flutter/material.dart';
import 'package:fit_motiv/core/config/app_config.dart';
import 'package:fit_motiv/main_common.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inicializar configuración para desarrollo
  await AppConfig.instance.initialize(flavor: AppFlavor.dev);
  
  // Inicializar dependencias comunes
  await initializeApp();
  
  runApp(const MyApp());
}