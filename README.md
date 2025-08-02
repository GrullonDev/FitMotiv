# FitMotiv 💪

Una aplicación Flutter elegante y moderna para fitness y motivación personal.

## 🚀 Características

### Dashboard Principal
- **Saludo personalizado**: Bienvenida con el nombre del usuario
- **Progreso de pérdida de peso**: Barra de progreso visual con indicador de metas
- **Cita motivacional**: Mensaje inspirador diario
- **Workout del día**: Rutina de ejercicios recomendada con duración y descripción
- **Receta saludable**: Sugerencia nutricional con información calórica y tiempo de preparación

### Diseño UI/UX
- **Colores armoniosos**: Paleta de verdes y tonos neutros
- **Animaciones suaves**: Transiciones con `animate_do`
- **Tipografía moderna**: Google Fonts (Poppins)
- **Navegación intuitiva**: Bottom navigation bar customizada
- **Cards elegantes**: Diseño con sombras y bordes redondeados

## 📱 Pantallas Implementadas

### 🏠 Dashboard (Pantalla Principal)
- Header con saludo personalizado y botón de configuración
- Card de progreso con barra de porcentaje
- Sección de cita motivacional con gradiente
- Card de workout con imagen, duración y botón de acción
- Card de receta con ilustración, información nutricional y botón

### 🎨 Componentes Personalizados
- `ProgressCard`: Muestra el progreso de objetivos
- `WorkoutCard`: Presenta el ejercicio del día
- `RecipeCard`: Exhibe recetas saludables
- `CustomBottomNavigationBar`: Navegación inferior personalizada

## 🛠️ Tecnologías Utilizadas

### Dependencias Principales
```yaml
dependencies:
  flutter: sdk: flutter
  google_fonts: ^6.1.0      # Tipografías elegantes
  flutter_svg: ^2.0.9       # Soporte para SVG
  percent_indicator: ^4.2.3   # Indicadores de progreso
  animate_do: ^3.1.2         # Animaciones predefinidas
```

### Estructura del Proyecto
```
lib/
├── main.dart                    # Punto de entrada de la aplicación
├── screens/
│   └── dashboard_screen.dart    # Pantalla principal del dashboard
├── widgets/
│   ├── progress_card.dart       # Widget de progreso
│   ├── workout_card.dart        # Widget de ejercicios
│   ├── recipe_card.dart         # Widget de recetas
│   └── bottom_navigation_bar.dart # Navegación inferior
└── constants/
    ├── app_colors.dart          # Definición de colores
    └── app_text_styles.dart     # Estilos de texto
```

## 🚀 Instalación y Ejecución

1. **Instalar dependencias**:
   ```bash
   flutter pub get
   ```

2. **Ejecutar la aplicación**:
   ```bash
   flutter run
   ```

Desarrollado con ❤️ usando Flutter
