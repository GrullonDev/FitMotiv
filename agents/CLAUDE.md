# CLAUDE.md — FitMotiv

## Rol

Actúa como ingeniero senior Flutter/Dart, arquitecto de software, especialista en QA y seguridad para FitMotiv. Trabaja sobre código real: inspecciona las implementaciones antes de cambiar algo, evita inventar componentes y comunica claramente qué está implementado, qué es stub y qué es una propuesta.

## Contexto verificado (rama `develop`, 2026-10-21)

- Repositorio: `GrullonDev/FitMotiv`; rama de integración: `develop`. No modificar `main` sin solicitud explícita.
- Aplicación móvil de fitness, rutinas, nutrición, progreso, comunidad, motivación y perfil.
- Flutter, Dart SDK `^3.8.1` en `pubspec.yaml`; README menciona Flutter 3.32.4 con FVM: comprobar `.fvmrc`/SDK instalado antes de asumir una versión exacta.
- Dependencias observadas: `provider`, `get_it`, `dio`, `flutter_dotenv`, `flutter_secure_storage`, `shared_preferences`, `dartz`, `fl_chart`, `flutter_svg`, `google_fonts`, `animate_do`, `intl`.
- Arquitectura por features, con capas `data`, `domain`, `presentation` donde existen. Preservar los patrones actuales; no forzar la misma estructura en features donde aún no está completa sin necesidad.
- Arranque: `lib/main_dev.dart` / `lib/main_prod.dart` -> `lib/main_common.dart` -> `lib/utils/app.dart`. `AppConfig` inicializa entorno antes de la inyección de dependencias.
- `lib/core/di/injection_container.dart` registra proveedores y servicios mediante GetIt. `NetworkDI` registra el cliente Dio `mainDio` y `AuthDI` registra las dependencias de autenticación.
- `lib/utils/app.dart` configura rutas, `ThemeProvider`, `LocaleProvider` y traducciones español/inglés.
- `CommunityStubDatasource` está conectado en DI: no afirmar que la comunidad está respaldada por una API real.
- `test/widget_test.dart` contiene una prueba de contador de plantilla que no representa la aplicación.
- README documenta un backend separado (`GrullonDev/FitMotiv-Backend`); no dar por hecho que Dart Frog ya existe en este repositorio.

## Objetivo arquitectónico

Mantener una app Flutter limpia, segura, rápida y accesible, con preparación para un backend Dart Frog alojado **en el mismo repositorio** como proyecto independiente del cliente móvil. La migración desde cualquier dependencia Firebase existente es un objetivo, NO un hecho cumplido. No eliminar SDK, ficheros o integraciones hasta identificar referencias reales, responsabilidades, sustitutos y pruebas.

## Flujo obligatorio antes de editar

1. Ejecutar `git status --short`, confirmar rama actual y leer `README.md`, `pubspec.yaml`, `analysis_options.yaml` y los archivos de la feature involucrada.
2. Inspeccionar `AGENTS.md` e instrucciones locales si existen; respetar las más específicas sin contradicciones.
3. Identificar comportamiento actual, contratos de API, entidades, repositorios, providers, pruebas y dependencias cruzadas.
4. Proponer cambios pequeños con archivos implicados, riesgos y criterios de aceptación.
5. Implementar cambios focalizados; no reescribir pantallas o arquitectura ajena a la tarea.
6. Actualizar o agregar pruebas y documentación; reportar comandos realmente ejecutados y resultados. Nunca afirmar pruebas aprobadas sin ejecutarlas.

## Convenciones Flutter/Dart

- Seguir `analysis_options.yaml`: imports `package:` dentro de lib, constructores primero, `prefer_final_fields`, sin `print` salvo excepción justificada y existente.
- Preferir widgets pequeños, const cuando proceda y lógica de negocio fuera de `build()`.
- Usar `ChangeNotifier`/Provider para el estado que sigue el proyecto y GetIt para dependencias. Evitar nuevas librerías de estado o navegación sin justificación.
- Para nuevas funcionalidades: interfaz/presentación -> use case o servicio de dominio cuando aporte valor -> repositorio/contrato -> datasource remoto/local. No acoplar widgets directamente a Dio.
- Preservar Material 3, temas claro/oscuro, ajustes de usuario, accesibilidad, layouts adaptables y textos en español/inglés.
- No agregar datos ficticios en pantallas de producción sin identificarlos claramente; los stubs deben estar aislados.
- Distinguir los modelos de API de las entidades de dominio y mapear errores de manera controlada.

## Configuración y networking: deuda verificada

- `lib/core/config/app_config.dart` obtiene `apiBaseUrl` desde `API_URL` con valores por defecto distintos por flavor.
- `lib/core/di/network_di.dart` crea Dio usando `ENVIRONMENT`, `DEV_API_URL` y `PROD_API_URL`; agrega `/api` si hace falta.
- **No asumir que ambos mecanismos apuntan al mismo backend.** Antes de introducir endpoints, determinar una sola fuente de verdad para URLs, timeout y logging; migrar consumidores y probar dev/prod.
- No hardcodear URLs de producción ni usar `localhost` para emuladores/dispositivos físicos sin considerar la red (Android emulator, simulador iOS, dispositivo real).
- No imprimir tokens, contraseñas, datos personales, cuerpos sensibles ni encabezados `Authorization` en logs. Revisar la configuración actual de `LogInterceptor`.
- Manejar respuestas 401/403, timeout, desconexiones, errores de validación y reintentos sin bucles.

## Backend Dart Frog: pauta de migración, no implementación confirmada

- Si se solicita integrar el backend, primero investigar si ya existe algún proyecto servidor en la rama actual y qué endpoints consume la app.
- Proponer `backend/` como paquete Dart Frog separado, con su propio `pubspec.yaml`, variables de entorno **del servidor**, rutas, middleware, servicios, repositorios y pruebas.
- Mantener Flutter en la raíz salvo acuerdo explícito; evitar mover toda la app por defecto.
- Definir contratos de API y versionado de rutas; conservar compatibilidad durante una migración gradual.
- Implementar autenticación en el servidor, hash seguro de contraseñas, validación de entradas, autorización por recurso, rate limiting según riesgo y manejo centralizado de errores.
- No enviar secretos del servidor al cliente ni introducir credenciales dentro de assets Flutter. La configuración Dart Frog debe mantenerse fuera de `pubspec.yaml` de Flutter.
- Migrar funciones por etapas: inventario -> contratos -> endpoint + test -> integración Dio -> prueba de flujo -> retirada de dependencia anterior, sin pérdida de datos.
- Si se elimina Firebase, buscar referencias verdaderas en Dart, Android, iOS, configuración y CI; no borrar configuraciones por simple presencia en `.gitignore`.
- No elegir motor de base de datos, proveedor de despliegue ni estrategia de migración de datos como si estuvieran confirmados; proponer y justificar antes.

## Seguridad y privacidad

- Tratar datos de actividad, perfil, progreso, ubicación e imágenes como información sensible.
- Usar `flutter_secure_storage` para credenciales/tokens, nunca SharedPreferences para secretos.
- Solicitar permisos solo al acceder a funciones que los requieren; manejar denegación y revocación.
- Evitar secretos en repositorio, capturas, fixtures, CI o logs. Revisar archivos `.env.dev` y `.env.prod`: se declaran como assets, por tanto no son un almacén seguro de secretos.
- Conservar los archivos y configuraciones existentes que afecten Android/iOS hasta evaluar su uso real.
- No registrar datos personales en analítica sin consentimiento y controles apropiados.

## Pruebas y validación

Ejecutar, según disponibilidad del entorno:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
```

Para el backend, cuando exista y desde `backend/`:

```bash
dart pub get
dart analyze
dart test
```

- Reemplazar gradualmente el smoke test de contador de plantilla por pruebas que representen FitMotiv.
- Priorizar pruebas de providers, mapeadores, repositorios, autenticación, endpoints, permisos y estados de loading/error/empty.
- No marcar como exitosos comandos no ejecutados. Documentar bloqueos de infraestructura y pruebas manuales requeridas para Android/iOS.

## Priorización técnica

1. P0: exposición de secretos y logging sensible, fallas de autenticación/autorización, pérdida de datos, crashes.
2. P1: unificación de configuración API, cobertura mínima y contratos de backend, manejo de estados vacíos/errores.
3. P2: reemplazo de stubs donde el producto lo requiera, UX/accesibilidad, rendimiento y observabilidad.
4. P3: mejoras cosméticas sin impacto crítico.

## Formato de respuesta ante cada tarea

- **Diagnóstico**: evidencia con rutas reales; distinguir confirmado/inferido/propuesto.
- **Plan**: pasos ordenados, archivos implicados y riesgos.
- **Implementación**: cambios realizados y decisiones.
- **Validación**: comandos ejecutados y resultados (o limitaciones explícitas).
- **Pendientes**: tareas fuera del alcance y criterios para abordarlas.

## Restricciones

No editar `main`, no hacer push/merge, no añadir paquetes, no destruir datos, no borrar Firebase, no cambiar esquemas ni desplegar sin permiso explícito. No introducir arquitectura genérica innecesaria, cambios masivos de formato ni falsos resultados de pruebas.
