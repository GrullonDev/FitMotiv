# codex.md — FitMotiv: guía de implementación para agentes

> **Nota de compatibilidad:** Codex reconoce convencionalmente `AGENTS.md` como archivo de instrucciones. Este `codex.md` puede servir como guía humana, pero para carga automática conviene copiar su contenido a `AGENTS.md` en la raíz.

## Misión y ámbito

Eres un agente de programación que modifica FitMotiv (`GrullonDev/FitMotiv`), empezando por `develop`. Entrega cambios pequeños, comprobables, seguros y compatibles con Flutter/Dart. No asumas que una capacidad documentada en el README está completamente implementada.

## Hechos del código revisado

- Flutter + Dart SDK `^3.8.1`; `provider`, `get_it`, `dio`, `flutter_dotenv`, `flutter_secure_storage`, `shared_preferences`.
- Entradas: `lib/main_dev.dart`, `lib/main_prod.dart`; arranque común: `lib/main_common.dart`.
- Configuración: `lib/core/config/app_config.dart`.
- DI: `lib/core/di/injection_container.dart`, `lib/core/di/network_di.dart`, `lib/core/di/auth_di.dart`.
- Aplicación y rutas: `lib/utils/app.dart`; Material 3, `LocaleProvider`, `ThemeProvider`.
- Features vistas en DI: `auth`, `dashboard`, `plans`, `routines`, `progress`, `community`, `profile_settings`.
- La comunidad se registra mediante `CommunityStubDatasource`: verificar funcionalidad antes de afirmar soporte remoto.
- Backend externo documentado en README; un servidor Dart Frog embebido es una **meta de migración**, no una implementación comprobada.
- `test/widget_test.dart` conserva un test de contador de plantilla no representativo.

## Protocolo de ejecución

1. Leer `git status --short`, comprobar rama, inspeccionar instrucciones existentes y archivos relacionados.
2. Localizar rutas, clases, tests y puntos de integración concretos. No inventar archivos ni nombres de API.
3. Formular un plan breve para tareas no triviales y explicar impacto en contratos/datos/UX.
4. Editar solamente los archivos necesarios; preservar cambios previos del usuario.
5. Formatear, analizar, probar la funcionalidad y revisar `git diff --check`.
6. Resumir archivos cambiados, verificaciones realizadas, fallos y riesgos. No ejecutar git push/merge ni modificar main sin autorización.

## Reglas del repositorio

- Respetar `analysis_options.yaml`: imports `package:`, `sort_constructors_first`, `prefer_final_fields`, `avoid_print`.
- Mantener Provider + GetIt; no agregar Riverpod/Bloc ni un nuevo sistema de navegación sin requerimiento.
- UI desacoplada de red; los widgets usan providers/casos de uso/repositories en vez de instanciar Dio.
- Reutilizar estilo Material 3, ambos temas y localización es/en; considerar tamaños de pantalla, accesibilidad, contraste, estados loading/error/empty y flujo de permisos.
- Respetar interfaces de repositorios, mapeos DTO-entidad y testabilidad.
- No incorporar credenciales ni datos de usuario reales en ejemplos o tests.

## Deudas detectadas: resolver con evidencia

**Dos fuentes de URL/configuración:** `AppConfig.apiBaseUrl` lee `API_URL`, mientras `NetworkDI._getApiBaseUrl()` depende de `ENVIRONMENT`, `DEV_API_URL` y `PROD_API_URL` y compone `/api`. Para tareas de networking, primero establecer qué consumidores usan cada una, acordar una fuente única, mantener compatibilidad y probar ambos flavors.

**Registro de tráfico HTTP:** `NetworkDI` puede habilitar `LogInterceptor(requestBody: true, requestHeader: true)`. Evaluar filtrado de tokens/PII y desactivar logs sensibles en producción.

**Archivos de entorno como assets:** `pubspec.yaml` incluye `.env.dev` y `.env.prod` en assets. Ninguna clave allí debe tratarse como secreta; revisar datos publicados al compilar.

**Pruebas:** sustituir el test de contador por pruebas auténticas del producto. No afirmar que toda la suite pasa sin ejecutarla.

**Reproducibilidad:** `.gitignore` excluye `pubspec.lock`; evaluar el impacto en builds de aplicación y proponer seguimiento del lockfile si es apropiado.

## Trabajo solicitado: migración futura a Dart Frog

Al recibir una tarea de backend:

1. Inspeccionar primero el árbol actual, rutas HTTP consumidas, modelos y autenticación. Buscar Firebase en `pubspec.yaml`, fuentes, Android/iOS y workflows; nunca asumirlo instalado por una solicitud histórica.
2. Si aún no hay servidor integrado, sugerir `backend/` como proyecto Dart Frog independiente, conservando la app Flutter en raíz.
3. Documentar rutas, métodos, payloads, códigos HTTP, reglas de autorización y compatibilidad con Dio ANTES de cambiar el cliente.
4. Aplicar validación, respuestas de error consistentes, hash de password, almacenamiento de sesiones/tokens seguro y acceso autenticado a recursos de cada usuario.
5. Añadir pruebas unitarias/de rutas y pruebas de integración contra el cliente.
6. Migrar cada feature progresivamente y retirar la integración anterior solo con paridad funcional verificada y plan de datos/rollback.
7. No seleccionar PostgreSQL/SQLite/ORM/despliegue sin evaluar necesidades y confirmar la decisión.

## Comandos de validación

Desde raíz Flutter, si las herramientas están disponibles:

```bash
flutter pub get
dart format --output=none --set-exit-if-changed lib test
flutter analyze
flutter test
git diff --check
```

Entradas de desarrollo/producción según archivos existentes:

```bash
flutter run -t lib/main_dev.dart
flutter run -t lib/main_prod.dart
```

Antes de compilar con `--flavor`, verificar configuración efectiva de Gradle y Xcode; el README no sustituye esa verificación.

Cuando exista `backend/`:

```bash
cd backend
dart pub get
dart analyze
dart test
```

No inventar resultados de comandos ni ejecutar un despliegue sin autorización.

## Definition of Done

- Requisito implementado y alcance acotado.
- Arquitectura y contratos preservados o cambios documentados.
- Seguridad y datos sensibles evaluados.
- Tests actualizados y resultado reportado, con límites explícitos.
- No errores nuevos del analizador atribuibles al cambio.
- UX es/en, light/dark y estados de error revisados cuando corresponda.
- Diff sin archivos generados, secretos o cambios accidentales.
- Resumen final: qué cambió, qué se validó, qué falta.

## Formato de entrega

**Objetivo → Evidencia → Cambios → Pruebas → Riesgos/Pendientes**. Referenciar nombres de archivo y rutas exactas. Diferenciar claramente hechos verificados de recomendaciones.
