# FitMotiv Backend

REST API for the FitMotiv fitness app, built with [Dart Frog](https://dart-frog.dev) and PostgreSQL.

## Prerequisites

- Dart SDK >= 3.8.1
- [Podman](https://podman.io) & `podman compose` (for PostgreSQL). Docker/Docker Compose also works.
- [Dart Frog CLI](https://dart-frog.dev): `dart pub global activate dart_frog_cli`

## Quick Start

```bash
# 1. Start PostgreSQL (use podman compose or docker compose)
podman compose up -d

# 2. Copy and configure environment variables
cp .env.example .env
# Edit .env — set DB_PASSWORD and generate a JWT_SECRET:
#   openssl rand -base64 64

# 3. Install dependencies
dart pub get

# 4. Run migrations and seed data
dart run lib/database/seeds/seed_data.dart

# 5. Start the dev server
dart_frog dev
```

The server starts at `http://localhost:8080`.

## API Endpoints

### Health

| Method | Path                 | Auth | Description       |
|--------|----------------------|------|-------------------|
| GET    | `/api/v1/health`     | No   | Health check      |

### Authentication

| Method | Path                    | Auth | Description              |
|--------|-------------------------|------|--------------------------|
| POST   | `/api/v1/auth/register` | No   | Create account           |
| POST   | `/api/v1/auth/login`    | No   | Login (returns tokens)   |
| POST   | `/api/v1/auth/refresh`  | No   | Rotate refresh token     |
| POST   | `/api/v1/auth/logout`   | Yes  | Revoke refresh token     |

### Users

| Method | Path               | Auth | Description          |
|--------|--------------------|------|----------------------|
| GET    | `/api/v1/users/me` | Yes  | Current user profile |
| PATCH  | `/api/v1/users/me` | Yes  | Update profile       |

### Workouts

| Method | Path                        | Auth | Description              |
|--------|-----------------------------|------|--------------------------|
| GET    | `/api/v1/workouts`          | No   | List workouts            |
| GET    | `/api/v1/workouts/random`   | No   | Random workout           |
| GET    | `/api/v1/workouts/:id`      | No   | Workout by ID            |

### Progress

| Method | Path                          | Auth | Description               |
|--------|-------------------------------|------|---------------------------|
| GET    | `/api/v1/progress/weight`     | Yes  | Weight log entries        |
| POST   | `/api/v1/progress/weight`     | Yes  | Log weight                |
| GET    | `/api/v1/progress/goals`      | Yes  | User goals                |
| POST   | `/api/v1/progress/goals`      | Yes  | Create goal               |
| PATCH  | `/api/v1/progress/goals/:id`  | Yes  | Toggle goal completed     |
| GET    | `/api/v1/progress/sessions`   | Yes  | Workout sessions          |
| POST   | `/api/v1/progress/sessions`   | Yes  | Log workout session       |

### Nutrition

| Method | Path                            | Auth | Description          |
|--------|---------------------------------|------|----------------------|
| GET    | `/api/v1/nutrition/meals`       | No   | Meal plans           |
| GET    | `/api/v1/nutrition/recipes`     | No   | List recipes         |
| GET    | `/api/v1/nutrition/recipes/random` | No | Random recipe       |
| GET    | `/api/v1/nutrition/recipes/:id` | No   | Recipe by ID         |
| GET    | `/api/v1/nutrition/water`       | Yes  | Today's water intake |
| PUT    | `/api/v1/nutrition/water`       | Yes  | Update water intake  |

### Quotes

| Method | Path                      | Auth | Description     |
|--------|---------------------------|------|-----------------|
| GET    | `/api/v1/quotes`          | No   | List quotes     |
| GET    | `/api/v1/quotes/random`   | No   | Random quote    |

## Project Structure

```
backend/
├── lib/
│   ├── core/
│   │   ├── config/env.dart           # Environment configuration
│   │   ├── database/database.dart    # PostgreSQL connection pool
│   │   ├── database/migrator.dart    # Database migration runner
│   │   ├── middleware/auth_middleware.dart  # JWT auth middleware
│   │   └── utils/
│   │       ├── json_response.dart    # Standardized JSON responses
│   │       ├── jwt_service.dart      # JWT token creation/verification
│   │       ├── password_hasher.dart  # BCrypt password hashing
│   │       └── request_helpers.dart  # Request body parsing & validation
│   ├── database/seeds/seed_data.dart # Seed data for development
│   ├── features/
│   │   ├── auth/data/                # Auth repository
│   │   ├── nutrition/data/           # Nutrition repository
│   │   ├── progress/data/            # Progress repository
│   │   ├── quotes/data/              # Quotes repository
│   │   ├── users/data/               # Users repository
│   │   └── workouts/data/            # Workouts repository
│   └── server_init.dart              # Server initialization
├── routes/
│   └── api/v1/                       # File-system based routing
├── docker-compose.yml                # PostgreSQL container (works with podman compose)
├── .env.example                      # Environment template
└── pubspec.yaml
```

## Database

PostgreSQL 16 via Podman (or Docker). Migrations run automatically on server start
and are defined in `lib/core/migrator.dart`.

### Tables

- `users` — accounts with hashed passwords
- `refresh_tokens` — rotation-based refresh tokens
- `workouts` — workout catalog
- `exercises` — exercises per workout
- `weight_log` — user weight entries
- `goals` — user fitness goals
- `workout_sessions` — completed workout records
- `meal_plans`, `recipes` — nutrition content
- `water_log` — daily water intake
- `quotes` — motivational quotes

## Environment Variables

See `.env.example` for the full list. Key ones:

| Variable                     | Description                   |
|------------------------------|-------------------------------|
| `DB_HOST`, `DB_PORT`, etc.   | PostgreSQL connection         |
| `JWT_SECRET`                 | Secret for signing JWTs       |
| `ACCESS_TOKEN_EXPIRY_MINUTES`| Access token lifetime (default: 15) |
| `REFRESH_TOKEN_EXPIRY_DAYS`  | Refresh token lifetime (default: 30) |
| `MAX_LOGIN_ATTEMPTS`         | Failed logins before lockout  |
| `LOGIN_LOCKOUT_MINUTES`      | Lockout duration              |
