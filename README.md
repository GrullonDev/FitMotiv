## FitMotiv 💪

FitMotiv es una aplicación Flutter moderna, elegante y personalizable para gestionar rutinas de ejercicio, nutrición y motivación diaria.

---

## 🔍 Tabla de Contenidos
1. [Características](#características)
2. [Tecnologías](#tecnologías)
3. [Arquitectura y Estructura](#arquitectura-y-estructura)
4. [Instalación y Ejecución](#instalación-y-ejecución)
5. [Contribuciones](#contribuciones)
6. [Licencia](#licencia)

---

## ✨ Características
- **Dashboard**: Saludo personalizado, progreso de peso, cita motivacional, workout del día y receta saludable.
- **Planes y Rutinas**: Gestión de planes de alimentación y vista de rutinas por categorías (All, Cardio, Strength, Flexibility).
- **Progreso**: Gráficas semanales, mensuales y anuales de métricas (peso, medidas, actividad) y metas.
- **Comunidad**: Feed social con publicaciones, likes, comentarios y navegación por pestañas.
- **Perfil**: Avatar, estado de membresía, metas personales y recompensas.
- **Configuraciones**: Preferencias de notificaciones, modo oscuro y sección de soporte.

---

## 🛠️ Tecnologías
- **Flutter** 3.32.4 (gestión con **FVM**).
- **Dart** 3.x
- **State Management**: Provider + GetIt
- **Animaciones**: animate_do
- **Tipografía**: google_fonts (Poppins)
- **SVG**: flutter_svg
- **Gráficas**: percent_indicator

---

## 🏗️ Arquitectura y Estructura
Se utiliza Clean Architecture con organización por features:

```
lib/
├── main.dart             # Punto de entrada
├── app.dart              # Configuración de MaterialApp y rutas
├── core/di/              # Inyección de dependencias (GetIt)
├── constants/            # Colores y estilos de texto
├── models/               # Entidades y sample_data
├── features/             # data, domain, presentation por feature
├── screens/              # Pantallas (Dashboard, Plans, Routines, Progress, Community, Profile, Settings)
└── widgets/              # Componentes reutilizables (cards, bottom navigation, etc.)
```

---

## 🚀 Instalación y Ejecución
### Requisitos
- **FVM** (Flutter Version Manager)

```bash
dart pub global activate fvm
```
Clonar y usar la versión específica:
```bash
git clone <repo-url>
cd fit_motiv
fvm install 3.32.4
fvm use 3.32.4
```

### Comandos
1. Instalar dependencias:
   ```bash
   fvm flutter pub get
   ```
2. Ejecutar la app:
   ```bash
   fvm flutter run
   ```

---

## Contribuciones
1. Dale ⭐ al proyecto.
2. Haz un *fork* y crea una rama (`feature/nueva-funcionalidad`).
3. Realiza cambios y commitea con mensajes claros.
4. Empuja tu rama y abre un Pull Request describiendo tu aporte.

¡Gracias por contribuir! 🙏

---

## 📝 Licencia
Este proyecto está bajo licencia MIT. Consulta `LICENSE` para más detalles.
