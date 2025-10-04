# Arquitectura de Red Genérica - FitMotiv

## Arquitectura Refactorizada

El sistema ha sido refactorizado para seguir una arquitectura **más escalable y genérica** que puede manejar todos los endpoints de la aplicación, no solo autenticación. Sigue los principios de **Clean Architecture** y **SOLID**.

## Nueva Estructura del Proyecto

```
lib/
├── core/
│   ├── network/                                    # Componentes genéricos de red
│   │   ├── base/
│   │   │   ├── base_datasource.dart               # DataSource base para todos los módulos
│   │   │   └── base_repository.dart               # Repository base para todos los módulos
│   │   ├── error_handlers/
│   │   │   └── api_error_handler.dart             # Manejo de errores genérico
│   │   └── services/
│   │       └── api_service.dart                   # Servicio HTTP genérico
│   └── di/
│       ├── network_di.dart                        # DI para componentes de red
│       ├── auth_di.dart                           # DI específico para auth
│       └── injection_container.dart               # Contenedor principal
└── features/
    └── auth/
        ├── data/
        │   ├── datasources/
        │   │   ├── auth_datasource.dart           # Interface que extiende BaseDataSource
        │   │   └── auth_remote_datasource.dart    # Implementación que extiende BaseRemoteDataSource
        │   └── repositories/
        │       └── auth_repository_impl.dart      # Implementación que extiende BaseRepositoryImpl
        └── domain/
            └── repositories/
                └── auth_repository.dart            # Interface que extiende BaseRepository
```

## Componentes Refactorizados

### 1. ApiService (`core/network/services/api_service.dart`)
- **Responsabilidad**: Servicio HTTP genérico para TODA la aplicación
- **Endpoints implementados**:
  
  **Autenticación:**
  - `POST /auth/register`, `POST /auth/login`, `POST /auth/logout`
  - `POST /auth/change-password`, `GET /auth/verify-token`, `POST /auth/refresh`
  - `POST /auth/forgot-password`, `POST /auth/reset-password`
  - `POST /auth/verify-email`, `POST /auth/resend-verification`
  - `GET|PUT|DELETE /auth/me`, `POST /auth/me/reactivate`
  
  **Fitness/Workout:**
  - `GET|POST /workouts`, `GET|PUT|DELETE /workouts/{id}`
  - `GET /exercises`, `POST /workouts/{id}/sessions`
  - `PUT|POST /workout-sessions/{id}`
  
  **Nutrición:**
  - `GET|POST /nutrition/meals`, `GET /nutrition/foods`
  - `GET|PUT /nutrition/goals`
  
  **Progreso:**
  - `GET|POST /progress/weight`, `GET|POST /progress/measurements`
  - `GET|POST /progress/photos`
  
  **Social/Comunidad:**
  - `GET /social/feed`, `POST /social/posts`
  - `POST|DELETE /social/posts/{id}/like`
  - `GET /social/friends`, `POST /social/friends/request`
  
  **Métodos genéricos:**
  - `get()`, `post()`, `put()`, `patch()`, `delete()`

### 2. ApiErrorHandler (`core/network/error_handlers/api_error_handler.dart`)
- **Responsabilidad**: Manejo de errores para TODA la aplicación
- **Características mejoradas**:
  - Soporte para más códigos de estado HTTP (402, 409, etc.)
  - Mensajes user-friendly con `getUserFriendlyMessage()`
  - Detección inteligente de tipos de error
  - Incluye información del endpoint en las excepciones
- **Excepciones disponibles**:
  - `ServerException`, `NetworkException`, `UnauthorizedException`
  - `ForbiddenException`, `NotFoundException`, `ValidationException`
  - `TokenExpiredException`, `AccountDeactivatedException`
  - `EmailNotVerifiedException`, `RateLimitException`
  - `ConflictException`, `PaymentRequiredException`, `TooManyRequestsException`

### 3. BaseDataSource & BaseRepository (`core/network/base/`)
- **Responsabilidad**: Clases base para todos los módulos
- **BaseDataSource características**:
  - `makeApiCall()` - Llamadas API genéricas con manejo de errores
  - `makeApiCallForList()` - Para endpoints que devuelven listas
  - `makeApiCallWithTransform()` - Con transformación personalizada
  - `extractDataFromResponse()` - Normalización de respuestas
- **BaseRepository características**:
  - `handleRepositoryCall()` - Manejo común de operaciones
  - `handleAuthenticationResult()` - Para operaciones de autenticación
  - `handleLogoutResult()` - Para operaciones de logout
  - `handleProfileResult()` - Para operaciones de perfil
  - `handlePaginatedResult()` - Para respuestas paginadas
  - `transformToModel()` - Transformación a modelos de dominio

### 4. Módulo Auth Refactorizado
- **AuthDataSource**: Extiende `BaseDataSource`
- **AuthRemoteDataSource**: Extiende `BaseRemoteDataSource`
- **AuthRepository**: Extiende `BaseRepository`
- **AuthRepositoryImpl**: Extiende `BaseRepositoryImpl`

### 5. Inyección de Dependencias Modular
- **NetworkDI**: Configura componentes de red genéricos
- **AuthDI**: Configura específicamente el módulo de autenticación
- **InjectionContainer**: Orquesta todos los módulos

## Beneficios de la Nueva Arquitectura

### 🔄 **Escalabilidad**
- Un solo `ApiService` maneja todos los endpoints
- Fácil agregar nuevos módulos (fitness, nutrition, social)
- Clases base reutilizables para todos los features

### 🛡️ **Mantenibilidad**
- Manejo de errores centralizado y consistente
- Lógica común en clases base
- Separación clara de responsabilidades

### 🔧 **Extensibilidad**
- Nuevos módulos solo necesitan extender clases base
- Endpoints genéricos disponibles para casos especiales
- Configuración modular de DI

### 📊 **Consistencia**
- Misma estructura de respuesta en todos los módulos
- Patrones de error unificados
- Transformación de datos estandarizada

## Uso para Nuevos Módulos

### Ejemplo: Módulo Fitness

```dart
// 1. Crear FitnessDataSource que extiende BaseDataSource
abstract class FitnessDataSource extends BaseDataSource {
  Future<Either<ApiException, List<Map<String, dynamic>>>> getWorkouts();
  Future<Either<ApiException, Map<String, dynamic>>> createWorkout(Map<String, dynamic> data);
}

// 2. Implementación que usa ApiService
class FitnessRemoteDataSource extends BaseRemoteDataSource implements FitnessDataSource {
  final ApiService _apiService;
  
  @override
  Future<Either<ApiException, List<Map<String, dynamic>>>> getWorkouts() async {
    return await makeApiCallForList(
      () async => extractListFromResponse((await _apiService.getWorkouts()).data),
      endpoint: '/workouts',
    );
  }
}

// 3. Repository que extiende BaseRepository
class FitnessRepositoryImpl extends BaseRepositoryImpl implements FitnessRepository {
  final FitnessDataSource _dataSource;
  
  @override
  Future<Either<ApiException, List<Workout>>> getWorkouts() async {
    final result = await handleRepositoryCall(() => _dataSource.getWorkouts());
    return transformToModelList(result, (data) => Workout.fromJson(data));
  }
}
```

## Configuración de Entorno

### Variables de Entorno (`.env`)
```properties
ENVIRONMENT=development
DEV_API_URL=http://localhost:8000
PROD_API_URL=https://api.tuapp.com/api
DEV_TIMEOUT_SECONDS=30
PROD_TIMEOUT_SECONDS=15
DEV_ENABLE_LOGGING=true
PROD_ENABLE_LOGGING=false
```

### URLs Base por Entorno
- **Desarrollo**: `http://localhost:8000/api`
- **Producción**: `https://api.tuapp.com/api`

## Manejo de Errores Mejorado

```dart
// Ejemplo de uso con mensajes user-friendly
final result = await authRepository.login(credentials);
result.fold(
  (error) {
    final userMessage = ApiErrorHandler.getUserFriendlyMessage(error);
    showSnackBar(userMessage); // Mensaje amigable para el usuario
    
    // Manejo específico por tipo
    if (error is ValidationException) {
      // Mostrar errores de validación campo por campo
      handleValidationErrors(error.errors);
    } else if (error is TokenExpiredException) {
      // Renovar token automáticamente
      refreshTokenAndRetry();
    }
  },
  (data) {
    // Login exitoso
    navigateToHome();
  },
);
```

## Próximos Pasos

1. **Crear modelos de Request/Response** para cada endpoint
2. **Implementar Use Cases** para cada operación de negocio
3. **Crear Providers/BLoCs** para manejo de estado
4. **Implementar token storage** con Secure Storage
5. **Agregar interceptors** para refresh automático de tokens
6. **Crear módulos adicionales** (fitness, nutrition, social) usando las clases base

## Dependencias

```yaml
dependencies:
  dio: ^5.3.2              # Cliente HTTP
  dio_cookie_manager: ^3.1.1  # Manejo de cookies
  cookie_jar: ^4.0.6       # Almacenamiento de cookies
  dartz: ^0.10.1           # Programación funcional (Either)
  get_it: ^7.2.0           # Inyección de dependencias
  flutter_dotenv: ^5.1.0   # Variables de entorno
```

La arquitectura está ahora preparada para escalar horizontalmente agregando nuevos features que sigan los mismos patrones establecidos.