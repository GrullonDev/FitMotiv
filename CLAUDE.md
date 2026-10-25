# FitMotiv - Claude Code Project Rules

## Branch Protection Policy

### MANDATORY — All AI agents (Codex, Claude Code, etc.) MUST follow these rules:

1. **NEVER create PRs that target `main` directly.** All PRs must target `develop`.
2. **NEVER create PRs that target `develop` without explicit authorization from @GrullonDev.**
3. **NEVER merge any PR.** Only @GrullonDev can authorize and perform merges.
4. **All work must be done on feature branches** following the naming convention:
   - `codex/<descriptive-name>` for Codex agent work
   - `claude/<descriptive-name>` for Claude Code work
   - `feature/<descriptive-name>` for human feature work
   - `fix/<descriptive-name>` for bug fixes

### PR Workflow

1. Create a feature branch from `develop`
2. Push changes to the feature branch
3. Create a **draft** PR targeting `develop`
4. Wait for QA review and @GrullonDev approval
5. Only @GrullonDev merges to `develop`
6. Only @GrullonDev merges `develop` into `main`

### Merge Authorization

- `feature/* → develop`: Requires @GrullonDev approval
- `develop → main`: Requires @GrullonDev explicit authorization
- Direct pushes to `main` or `develop`: **PROHIBITED**

## Project Architecture

- **Frontend**: Flutter app (Dart) — root directory
- **Backend**: Dart Frog REST API — `backend/` directory
- **Database**: PostgreSQL 16 via Docker/Podman
- **Container Runtime**: Podman (preferred) or Docker

## Development Setup

- Backend runs on port **8080** (not 8000)
- Use `podman compose up -d` to start PostgreSQL
- Backend is in the **same repo** under `backend/`, not a separate repository

## Code Standards

- Dart analysis must pass with zero errors
- All SQL queries must use parameterized queries (no string interpolation)
- Auth endpoints must use the shared `authMiddleware()` — no inline JWT parsing
- All list endpoints must support pagination
- Error handling must propagate to the UI — never silently return empty results
