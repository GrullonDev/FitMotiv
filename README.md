<div align="center">
  <h1>
    <img src="https://img.shields.io/badge/FitMotiv-Fitness%20App-purple?style=for-the-badge&logo=flutter&logoColor=white" alt="FitMotiv"/>
  </h1>
  
  <p>
    <strong>Desarrollado con <span style="color: #e74c3c;">♥</span> usando Flutter por <a href="https://github.com/GrullonDev">@GrullonDev</a></strong>
  </p>
  
  <p>FitMotiv es una aplicación Flutter moderna, elegante y personalizable para gestionar rutinas de ejercicio, nutrición y motivación diaria.</p>
</div>

---

<div style="background: linear-gradient(90deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; margin: 20px 0;">
  <h2 style="color: white; margin: 0;">
    <span style="background: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 5px;">�</span>
    Tabla de Contenidos
  </h2>
</div>

<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 25px; border-radius: 12px; margin: 20px 0; box-shadow: 0 8px 32px rgba(102, 126, 234, 0.3);">
  
  <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 15px; color: white;">
    
    <div style="background: rgba(255,255,255,0.1); padding: 15px; border-radius: 8px; backdrop-filter: blur(10px);">
      <h4 style="margin: 0 0 10px 0; color: #f39c12; font-size: 16px; text-align: center;">🚀 Inicio Rápido</h4>
      <div style="font-size: 14px; line-height: 1.8;">
        <a href="#configuración-inicial" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px; transition: background-color 0.3s;">⚙️ Configuración Inicial</a>
        <a href="#backend-y-urls" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🔗 Backend y URLs</a>
        <a href="#flavors-y-entornos" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🏗️ Flavors y Entornos</a>
        <a href="#vs-code-setup" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">💻 VS Code Setup</a>
      </div>
    </div>

    <div style="background: rgba(255,255,255,0.1); padding: 15px; border-radius: 8px; backdrop-filter: blur(10px);">
      <h4 style="margin: 0 0 10px 0; color: #2ecc71; font-size: 16px; text-align: center;">📚 Información del Proyecto</h4>
      <div style="font-size: 14px; line-height: 1.8;">
        <a href="#características" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">✨ Características</a>
        <a href="#tecnologías" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🛠️ Tecnologías</a>
        <a href="#arquitectura-y-estructura" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🏛️ Arquitectura y Estructura</a>
        <a href="#instalación-y-ejecución" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🚀 Instalación y Ejecución</a>
      </div>
    </div>

    <div style="background: rgba(255,255,255,0.1); padding: 15px; border-radius: 8px; backdrop-filter: blur(10px);">
      <h4 style="margin: 0 0 10px 0; color: #e74c3c; font-size: 16px; text-align: center;">� Herramientas y Scripts</h4>
      <div style="font-size: 14px; line-height: 1.8;">
        <a href="#scripts-de-build" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">📝 Scripts de Build</a>
        <a href="#variables-de-entorno" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🔐 Variables de Entorno</a>
        <a href="#archivos-sensibles-gitignore" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">�️ Archivos Sensibles</a>
        <a href="#troubleshooting" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🔧 Troubleshooting</a>
      </div>
    </div>

    <div style="background: rgba(255,255,255,0.1); padding: 15px; border-radius: 8px; backdrop-filter: blur(10px);">
      <h4 style="margin: 0 0 10px 0; color: #9b59b6; font-size: 16px; text-align: center;">🤝 Colaboración</h4>
      <div style="font-size: 14px; line-height: 1.8;">
        <a href="#contribuciones" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🤝 Contribuciones</a>
        <a href="#licencia" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">📄 Licencia</a>
        <a href="#contacto-y-soporte" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">� Contacto y Soporte</a>
        <a href="#gracias" style="color: #ecf0f1; text-decoration: none; display: block; margin: 4px 0; padding: 3px 8px; border-radius: 4px;">🎉 ¡Gracias!</a>
      </div>
    </div>

  </div>

  <div style="margin-top: 20px; text-align: center; padding-top: 15px; border-top: 1px solid rgba(255,255,255,0.2);">
    <p style="color: #bdc3c7; margin: 0; font-size: 14px;">
      💡 <strong>Navegación rápida:</strong> Usa <code style="background: rgba(255,255,255,0.1); padding: 2px 6px; border-radius: 3px; color: #ecf0f1;">Ctrl+F</code> (o <code style="background: rgba(255,255,255,0.1); padding: 2px 6px; border-radius: 3px; color: #ecf0f1;">Cmd+F</code> en Mac) para buscar secciones específicas
    </p>
  </div>

</div>

---

<div style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 20px; border-radius: 10px; margin: 20px 0;">
  <h2 style="color: white; margin: 0;">
    <span style="background: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 5px;">⚙️</span>
    Configuración Inicial
  </h2>
</div>

### Setup Automático (Recomendado)
```bash
# Clona el repositorio
git clone https://github.com/GrullonDev/FitMotiv.git
cd fit_motiv

# Ejecuta el script de configuración
./setup_env.sh
```

### Setup Manual
```bash
# 1. Copia el archivo de variables de entorno
cp .env.example .env

# 2. Edita .env con tus URLs reales
nano .env  # o usa tu editor preferido

# 3. Instala dependencias
flutter pub get

# 4. Ejecuta la aplicación
flutter run -t lib/main_dev.dart
```

---

## 🌐 Backend y URLs

### ⚠️ IMPORTANTE: Backend Local Requerido

Para ejecutar la aplicación en modo desarrollo, **necesitas tener el backend ejecutándose localmente**.

#### Obtener el Backend:
```bash
# Clona el repositorio del backend
git clone https://github.com/GrullonDev/FitMotiv-Backend.git

# Sigue las instrucciones del README del backend para:
# 1. Configurar la base de datos
# 2. Instalar dependencias
# 3. Ejecutar el servidor local

# El backend por defecto corre en: http://localhost:8000
```

#### URLs Configuradas:
- **Desarrollo**: `http://localhost:8000` (Backend local requerido)

#### ¿No tienes el backend?
Si no puedes ejecutar el backend localmente:
1. Contacta al administrador del proyecto para acceso
2. O cambia `DEV_API_URL` en `.env` a una URL de testing disponible
3. Algunas funciones pueden no estar disponibles sin el backend

---

## 🌟 Flavors y Entornos

Este proyecto soporta múltiples entornos con diferentes configuraciones:

### Configuraciones Disponibles:
- **Dev (Desarrollo)**: Conecta al backend local

### Comandos Rápidos:
```bash
# Desarrollo (requiere backend local)
flutter run -t lib/main_dev.dart

# Producción
flutter run -t lib/main_prod.dart

# Usando scripts
./build_scripts.sh run-dev
./build_scripts.sh run-prod
```

### Android Flavors:
```bash
# APK de desarrollo
flutter build apk -t lib/main_dev.dart --flavor dev --debug

# APK de producción
flutter build apk -t lib/main_prod.dart --flavor prod --release
```

---

## 🎯 VS Code Setup

### Configuraciones de Launch (F5):
1. **FitMotiv (Dev)** - Desarrollo con backend local

### Cómo usar:
1. Abre VS Code en el directorio del proyecto
2. Presiona **F5**
3. Selecciona la configuración deseada
4. ¡La app se ejecuta automáticamente!

### Tareas Disponibles (Ctrl+Shift+P → "Tasks: Run Task"):
- 🔧 Flutter: Run Development
- 🚀 Flutter: Run Production  
- 🤖 Build: Android APK (Dev/Prod)
- 🍎 Build: iOS (Dev/Prod)
- 📦 Flutter: Get Dependencies
- 🧹 Flutter: Clean Project
- 🔍 Flutter: Analyze
- 🧪 Flutter: Test

### Shortcuts Útiles:
| Acción | Shortcut | Descripción |
|--------|----------|-------------|
| Start Debugging | **F5** | Inicia con la configuración seleccionada |
| Run without Debugging | **Ctrl+F5** | Ejecuta sin debugger |
| Stop | **Shift+F5** | Detiene la ejecución |
| Hot Reload | **Ctrl+F5** (durante debug) | Recarga cambios |

---

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
- **Flutter** 3.32.4 (gestión con **FVM**)
- **Dart** 3.x
- **State Management**: Provider + GetIt
- **Animaciones**: animate_do
- **Tipografía**: google_fonts (Poppins)
- **SVG**: flutter_svg
- **Gráficas**: percent_indicator
- **Environment**: flutter_dotenv
- **Architecture**: Clean Architecture + Feature-based

---

## 🏗️ Arquitectura y Estructura

### Clean Architecture con organización por features:

```
lib/
├── main.dart                 # Punto de entrada principal
├── main_dev.dart            # Entrada para desarrollo
├── main_prod.dart           # Entrada para producción  
├── main_common.dart         # Código común compartido
├── app.dart                 # Configuración de MaterialApp y rutas
├── core/
│   ├── config/              # Configuración de entornos (AppConfig)
│   └── di/                  # Inyección de dependencias (GetIt)
├── constants/               # Colores y estilos de texto
├── models/                  # Entidades y sample_data
├── features/                # Organización por características
│   ├── auth/
│   │   ├── domain/         # Entities, UseCases
│   │   └── presentation/   # Screens, Widgets
│   ├── dashboard/
│   ├── plans/
│   ├── routines/
│   ├── progress/
│   ├── community/
│   └── profile_settings/
├── screens/                 # Pantallas legacy (compatibilidad)
└── widgets/                 # Componentes reutilizables
```

### Arquitectura de Configuración:
```
AppConfig (Singleton)
├── AppFlavor (enum: dev/prod)
├── Environment URLs (.env)
├── Timeout configurations
└── Logging settings
```

---

## 🚀 Instalación y Ejecución

### Requisitos
- **Flutter** 3.32.4 o superior
- **Dart** 3.x
- **FVM** (Flutter Version Manager) - Recomendado

#### Instalar FVM:
```bash
dart pub global activate fvm
```

### Pasos de Instalación:

#### 1. Clonar el repositorio:
```bash
git clone https://github.com/GrullonDev/FitMotiv.git
cd fit_motiv
```

#### 2. Configurar Flutter (con FVM):
```bash
fvm install 3.32.4
fvm use 3.32.4
```

#### 3. Configurar variables de entorno:
```bash
# Copia el archivo de ejemplo
cp .env.example .env

# Edita con tus configuraciones
nano .env
```

#### 4. Instalar dependencias:
```bash
fvm flutter pub get
# O sin FVM: flutter pub get
```

#### 5. Ejecutar la aplicación:
```bash
# Desarrollo (requiere backend local)
fvm flutter run -t lib/main_dev.dart

# Producción
fvm flutter run -t lib/main_prod.dart

# O usar scripts
./build_scripts.sh run-dev
```

---

## 🛠️ Scripts de Build y Utilidades

El proyecto incluye scripts automatizados para facilitar el desarrollo y mejorar la seguridad:

### 🔧 **Hacer ejecutables (solo la primera vez):**
```bash
chmod +x build_scripts.sh
chmod +x setup_env.sh
chmod +x check_security.sh
```

### 🚀 **Scripts de Build:**
```bash
# Ver ayuda
./build_scripts.sh help

# Ejecutar aplicación
./build_scripts.sh run-dev      # Desarrollo
./build_scripts.sh run-prod     # Producción

# Compilar APKs (Android)
./build_scripts.sh dev-android  # APK debug
./build_scripts.sh prod-android # APK release

# Compilar iOS
./build_scripts.sh dev-ios      # iOS debug
./build_scripts.sh prod-ios     # iOS release

# Utilidades
./build_scripts.sh install     # Instalar dependencias
./build_scripts.sh clean       # Limpiar proyecto
```

### 🔐 **Script de Verificación de Seguridad:**
```bash
# Verificar antes de hacer commit
./check_security.sh

# Funciones del script:
# ✅ Detecta archivos sensibles en staging
# ✅ Verifica .gitignore
# ✅ Revisa configuración git
# ✅ Compara .env con .env.example
# ✅ Escanea histórico reciente
```

### <span style="color: #9b59b6;">�</span> **Script de Configuración Inicial:**
```bash
# Configura todo automáticamente
./setup_env.sh
```

### <span style="color: #e74c3c;">🔐</span> **Script de Protección GitHub:**
```bash
# Configura protección de ramas en GitHub
./scripts/setup_github_protection.sh

# Funciones del script:
# 🔒 Guía para proteger rama main (solo @GrullonDev)
# 🤝 Configurar rama develop (colaboradores)
# 📋 Crear archivo CODEOWNERS
# 🎯 Configurar develop como rama por defecto
```

### 💡 **Flujo Recomendado:**
```bash
# 1. Configurar entorno (solo una vez)
./setup_env.sh

# 2. Antes de cada commit
./check_security.sh
git add .
git commit -m "feat: nueva funcionalidad"

# 3. Para development
./build_scripts.sh run-dev
```

---

## 🔐 Variables de Entorno

### Archivo .env (NO se sube al repositorio)

Crea tu archivo `.env` basado en `.env.example`:

```bash
# URLs de API
DEV_API_URL=http://localhost:8000          # Backend local
PROD_API_URL=https://api.tuapp.com/api     # Servidor remoto

# Configuraciones de timeout
DEV_TIMEOUT_SECONDS=30
PROD_TIMEOUT_SECONDS=15

# Logging
DEV_ENABLE_LOGGING=true
PROD_ENABLE_LOGGING=false
```

### Uso en código:
```dart
import 'package:fit_motiv/core/config/app_config.dart';

// Obtener URL según el entorno
String apiUrl = AppConfig.instance.apiBaseUrl;

// Construir URLs completas
String loginUrl = AppConfig.instance.getApiUrl('/auth/login');

// Verificar entorno
if (AppConfig.instance.isDevelopment) {
  print('Ejecutando en desarrollo');
}
```

### Agregar nuevas variables:
1. Agrega al archivo `.env.example`
2. Agrega a tu `.env` personal
3. Extiende `AppConfig` para leer la variable

---

## 🚫 Archivos Sensibles (GitIgnore)

El proyecto utiliza un `.gitignore` avanzado que excluye automáticamente archivos sensibles y temporales:

### 🔐 **Variables de Entorno y Configuración:**
- `.env`, `.env.*`, `*.env` - Variables de entorno
- `firebase_options.dart` - Configuración Firebase generada
- `local.properties` - Configuraciones locales de Android

### 🔥 **Firebase y Servicios Cloud:**
- `/ios/Runner/GoogleService-Info.plist`
- `/android/app/google-services.json`
- `/ios/firebase_app_id_file.json`

### 🔑 **Claves y Certificados:**
**iOS:**
- `*.p12`, `*.p8`, `*.mobileprovision`, `*.cer`
- `AuthKey_*.p8` - Claves de autenticación Apple

**Android:**
- `*.jks`, `*.keystore`, `key.properties`
- `upload-keystore.jks`, `release-keystore.jks`

### 🏗️ **Build Artifacts:**
- `/build/`, `**/build/` - Archivos compilados
- `/android/app/debug`, `/android/app/release`
- DerivedData/, xcuserdata/ - Archivos Xcode

### 💻 **Configuraciones de IDEs:**
- `.vscode/settings.json`, `.vscode/launch.json` (personales)
- `.idea/`, `*.iml` - Android Studio/IntelliJ
- `xcuserdata/` - Configuraciones Xcode

### 🖥️ **Archivos del Sistema:**
- `.DS_Store`, `Thumbs.db` - Cache del sistema
- `*.log`, `logs/` - Archivos de registro
- `*.tmp`, `.cache/` - Archivos temporales

### 📱 **Testing y Performance:**
- `coverage/`, `*.lcov` - Reports de cobertura
- `*.trace`, `*.profile` - Archivos de profiling
- `crash_logs/`, `*.crash` - Reports de crash

### ⚠️ **CRÍTICO - Nunca Subir:**
- 🚫 **Archivos `.env`** con URLs y claves API
- 🚫 **Certificados y keystores** para firma
- 🚫 **Configuraciones Firebase** con credenciales
- 🚫 **Logs** que puedan contener datos sensibles
- 🚫 **Archivos de crash** con información del sistema

### ✅ **Buenas Prácticas:**
- ✅ Usa `.env.example` como plantilla
- ✅ Documenta nuevas exclusiones en el `.gitignore`
- ✅ Revisa `git status` antes de cada commit
- ✅ Configura alerts para archivos sensibles

---

## 🆘 Troubleshooting

### Problemas Comunes:

#### "AppConfig no ha sido inicializado"
```bash
# Solución:
1. Verifica que existe el archivo .env
2. Ejecuta: flutter pub get
3. Reinicia la aplicación
```

#### "Failed host lookup: localhost"
```bash
# Solución:
1. Asegúrate de que el backend esté ejecutándose
2. Verifica que la URL en .env sea correcta
3. En emulador Android, usa: 10.0.2.2:8000 en lugar de localhost:8000
```

#### "The Xcode project does not define custom schemes"
```bash
# Solución (ya implementada):
- Usa los comandos sin --flavor para iOS
- Los flavors funcionan automáticamente con diferentes entry points
```

#### Errores de dependencias:
```bash
# Limpiar y reinstalar:
flutter clean
flutter pub get

# O usar script:
./build_scripts.sh clean
./build_scripts.sh install
```

#### Problemas con FVM:
```bash
# Reinstalar versión:
fvm install 3.32.4
fvm use 3.32.4
fvm flutter doctor
```

### Comandos de Diagnóstico:
```bash
# Verificar instalación
flutter doctor

# Analizar código
flutter analyze

# Ver dispositivos
flutter devices

# Verificar configuración del proyecto
./build_scripts.sh help
```

---

<div align="center" style="margin: 30px 0;">
  <a href="#📋-tabla-de-contenidos" style="background: linear-gradient(135deg, #f1c40f 0%, #f39c12 100%); color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; box-shadow: 0 2px 10px rgba(241, 196, 15, 0.3);">
    ⬆️ Volver al Índice
  </a>
</div>

<div style="background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); padding: 20px; border-radius: 10px; margin: 20px 0;">
  <h2 style="color: white; margin: 0;">
    <span style="background: rgba(255,255,255,0.2); padding: 5px 10px; border-radius: 5px;">🤝</span>
    Contribuciones
  </h2>
</div>

<div style="background: #f8f9fa; border-left: 4px solid #3498db; padding: 15px; margin: 15px 0; border-radius: 5px;">
  <strong>📋 Para Desarrolladores Nuevos:</strong>
  <p>Todas las contribuciones deben realizarse creando una rama desde <code>develop</code>. La rama <code>main</code> está protegida y solo el maintainer del proyecto puede hacer merge hacia ella.</p>
</div>

### <span style="color: #3498db;">🚀</span> ¿Cómo contribuir?

1. **Dale ⭐ al proyecto** si te parece útil
2. **Fork** el repositorio
3. **Clona** tu fork y configura el entorno:
   ```bash
   git clone https://github.com/tu-usuario/FitMotiv.git
   cd FitMotiv
   ./setup_env.sh
   ```
4. **Cambia a la rama develop** (IMPORTANTE):
   ```bash
   git checkout develop
   git pull origin develop
   ```
5. **Crea una rama** para tu feature desde develop:
   ```bash
   git checkout -b feature/nueva-funcionalidad
   ```
6. **Desarrolla** tu funcionalidad:
   - Sigue la arquitectura existente
   - Agrega tests si es posible
   - Mantén el código limpio y documentado
7. **Prueba** tu código antes de commitear:
   ```bash
   flutter analyze
   flutter test
   ./check_security.sh
   ./build_scripts.sh run-dev
   ```
8. **Commitea** con mensajes claros siguiendo [Conventional Commits](https://www.conventionalcommits.org/):
   ```bash
   git add .
   git commit -m "feat: agrega nueva funcionalidad X"
   ```
9. **Push** a tu rama:
   ```bash
   git push origin feature/nueva-funcionalidad
   ```
10. **Abre un Pull Request** hacia la rama `develop` describiendo:
    - ¿Qué cambiaste?
    - ¿Por qué lo cambiaste?
    - ¿Cómo probaste los cambios?
    - ¿Incluiste tests?

<div style="background: #fff3cd; border: 1px solid #ffeaa7; padding: 15px; border-radius: 5px; margin: 15px 0;">
  <strong>⚠️ Importante:</strong>
  <ul>
    <li>Siempre crea ramas desde <code>develop</code>, nunca desde <code>main</code></li>
    <li>Los PRs deben apuntar a <code>develop</code>, no a <code>main</code></li>
    <li>Ejecuta <code>./check_security.sh</code> antes de cada commit</li>
    <li>Mantén tu rama actualizada con <code>develop</code> frecuentemente</li>
  </ul>
</div>

### Guías de Contribución:

#### Estructura de commits:
- `feat:` Nueva funcionalidad
- `fix:` Corrección de bugs
- `docs:` Documentación
- `style:` Cambios de formato
- `refactor:` Refactorización
- `test:` Tests
- `chore:` Tareas de mantenimiento

#### Antes de enviar PR:
- [ ] El código pasa `flutter analyze`
- [ ] La app funciona en dev y prod
- [ ] Has probado en iOS y Android (si es posible)
- [ ] La documentación está actualizada
- [ ] No hay archivos sensibles en el commit

### ¿Necesitas ayuda?
- 🐛 **Bugs**: Crea un issue describiendo el problema
- 💡 **Ideas**: Abre un issue con la etiqueta "enhancement"
- ❓ **Preguntas**: Usa las discussions del repositorio

¡Gracias por contribuir! 🙏

---

## 📝 Licencia

Este proyecto está bajo licencia **MIT**. 

### ¿Qué significa esto?
- ✅ Puedes usar el código comercialmente
- ✅ Puedes modificar el código
- ✅ Puedes distribuir el código
- ✅ Puedes usar el código privadamente
- ❗ Debes incluir el aviso de copyright
- ❗ Debes incluir el texto de la licencia

Consulta el archivo `LICENSE` para más detalles.

---

## 📞 Contacto y Soporte

### Desarrollador Principal:
- **GitHub**: [@GrullonDev](https://github.com/GrullonDev)
- **Proyecto**: [FitMotiv](https://github.com/GrullonDev/FitMotiv)

### Enlaces Relacionados:
- 🔗 **Backend**: [FitMotiv-Backend](https://github.com/GrullonDev/FitMotiv-Backend)
- 📱 **App Store**: *Próximamente*
- 🤖 **Google Play**: *Próximamente*

### Soporte:
- 🐛 **Issues**: [GitHub Issues](https://github.com/GrullonDev/FitMotiv/issues)
- 💬 **Discussions**: [GitHub Discussions](https://github.com/GrullonDev/FitMotiv/discussions)

---

<div align="center" style="margin: 20px 0;">
  <a href="#📋-tabla-de-contenidos" style="background: linear-gradient(135deg, #95a5a6 0%, #7f8c8d 100%); color: white; padding: 8px 16px; border-radius: 20px; text-decoration: none; font-size: 14px; box-shadow: 0 2px 10px rgba(149, 165, 166, 0.3);">
    ⬆️ Índice
  </a>
</div>

## 🎉 ¡Gracias!

**FitMotiv** es un proyecto que busca ayudar a las personas a mantenerse activas y saludables. Tu contribución hace la diferencia.

### Próximas características:
- [ ] Integración con wearables
- [ ] Modo offline
- [ ] Notificaciones push
- [ ] Gamificación avanzada
- [ ] Integración con redes sociales

### Tecnologías futuras:
- [ ] GraphQL
- [ ] Real-time notifications
- [ ] AI-powered recommendations
- [ ] Advanced analytics

**<span style="color: #3498db;">¡Únete al desarrollo y ayúdanos a hacer FitMotiv aún mejor!</span>** <span style="color: #e74c3c;">💪</span>

---

<div align="center" style="background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 15px; margin: 30px 0;">
  <h3 style="color: white; margin: 0;">
    <span style="color: #f39c12;">🏆</span> Desarrollado con <span style="color: #e74c3c;">♥</span> usando Flutter
  </h3>
  <p style="color: #ecf0f1; margin: 10px 0;">
    <strong>Por <a href="https://github.com/GrullonDev" style="color: #3498db; text-decoration: none;">@GrullonDev</a></strong>
  </p>
  <div style="margin-top: 20px;">
    <a href="https://github.com/GrullonDev" style="color: #ecf0f1; margin: 0 10px; text-decoration: none;">
      <span style="background: rgba(255,255,255,0.1); padding: 8px 12px; border-radius: 20px;">
        🐙 GitHub
      </span>
    </a>
    <a href="https://flutter.dev" style="color: #ecf0f1; margin: 0 10px; text-decoration: none;">
      <span style="background: rgba(255,255,255,0.1); padding: 8px 12px; border-radius: 20px;">
        💙 Flutter
      </span>
    </a>
  </div>
</div>

<div align="center" style="margin: 20px 0;">
  <a href="#📋-tabla-de-contenidos" style="background: linear-gradient(135deg, #3498db 0%, #2980b9 100%); color: white; padding: 12px 24px; border-radius: 25px; text-decoration: none; font-weight: bold; box-shadow: 0 4px 15px rgba(52, 152, 219, 0.3); transition: all 0.3s ease;">
    ⬆️ Volver al Índice
  </a>
</div>
