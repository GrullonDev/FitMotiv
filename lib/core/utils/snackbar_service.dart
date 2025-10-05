import 'package:fit_motiv/constants/app_colors.dart';
import 'package:flutter/material.dart';

/// Servicio para mostrar SnackBars y mensajes en la aplicación
/// Centraliza la lógica de presentación de mensajes al usuario
class SnackBarService {
  /// Clave global para el ScaffoldMessenger
  static final GlobalKey<ScaffoldMessengerState> scaffoldMessengerKey = GlobalKey<ScaffoldMessengerState>();

  /// Muestra un SnackBar de error
  static void showError(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.red.shade600,
      textColor: Colors.white,
      icon: Icons.error_outline,
      duration: duration ?? const Duration(seconds: 4),
    );
  }

  /// Muestra un SnackBar de éxito
  static void showSuccess(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.green.shade600,
      textColor: Colors.white,
      icon: Icons.check_circle_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra un SnackBar de información
  static void showInfo(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: AppColors.primary,
      textColor: Colors.white,
      icon: Icons.info_outline,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra un SnackBar de advertencia
  static void showWarning(String message, {Duration? duration}) {
    _showSnackBar(
      message: message,
      backgroundColor: Colors.orange.shade600,
      textColor: Colors.white,
      icon: Icons.warning_amber_outlined,
      duration: duration ?? const Duration(seconds: 3),
    );
  }

  /// Muestra un SnackBar para errores de red específicamente
  static void showNetworkError({Duration? duration}) {
    showError('Network error. Please check your internet connection', duration: duration ?? const Duration(seconds: 5));
  }

  /// Muestra un SnackBar para errores de sesión expirada
  static void showSessionExpired({Duration? duration}) {
    showError('Your session has expired. Please login again', duration: duration ?? const Duration(seconds: 5));
  }

  /// Método privado para mostrar SnackBars customizados
  static void _showSnackBar({
    required String message,
    required Color backgroundColor,
    required Color textColor,
    required IconData icon,
    required Duration duration,
  }) {
    final scaffoldMessenger = scaffoldMessengerKey.currentState;
    if (scaffoldMessenger == null) return;

    // Limpiar SnackBars anteriores
    scaffoldMessenger.clearSnackBars();

    final snackBar = SnackBar(
      content: Row(
        children: [
          Icon(icon, color: textColor, size: 20),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              message,
              style: TextStyle(color: textColor, fontSize: 14, fontWeight: FontWeight.w500),
            ),
          ),
        ],
      ),
      backgroundColor: backgroundColor,
      duration: duration,
      behavior: SnackBarBehavior.floating,
      margin: const EdgeInsets.all(16),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      action: SnackBarAction(
        label: 'Dismiss',
        textColor: textColor.withOpacity(0.8),
        onPressed: () {
          scaffoldMessenger.hideCurrentSnackBar();
        },
      ),
    );

    scaffoldMessenger.showSnackBar(snackBar);
  }

  /// Oculta el SnackBar actual si existe
  static void hideCurrentSnackBar() {
    scaffoldMessengerKey.currentState?.hideCurrentSnackBar();
  }

  /// Limpia todos los SnackBars en cola
  static void clearSnackBars() {
    scaffoldMessengerKey.currentState?.clearSnackBars();
  }
}
