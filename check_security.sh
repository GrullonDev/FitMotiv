#!/bin/bash

# Script de verificación de seguridad para FitMotiv
# Ejecuta: ./check_security.sh

echo "🔐 Verificación de Seguridad - FitMotiv"
echo "======================================"

# Colores para output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Función para mostrar errores
show_error() {
    echo -e "${RED}❌ $1${NC}"
}

# Función para mostrar warnings
show_warning() {
    echo -e "${YELLOW}⚠️  $1${NC}"
}

# Función para mostrar éxito
show_success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# Función para mostrar info
show_info() {
    echo -e "${BLUE}ℹ️  $1${NC}"
}

# Verificar si git está inicializado
if [ ! -d ".git" ]; then
    show_error "Este directorio no es un repositorio git"
    exit 1
fi

echo ""
show_info "Verificando archivos sensibles..."

# Variables para tracking
has_issues=false

# Archivos que nunca deben estar en git
sensitive_files=(
    ".env"
    ".env.local"
    ".env.development"
    ".env.production"
    "ios/Runner/GoogleService-Info.plist"
    "android/app/google-services.json"
    "android/key.properties"
    "android/app/upload-keystore.jks"
    "android/app/release-keystore.jks"
    "lib/firebase_options.dart"
)

# Verificar archivos sensibles específicos
echo ""
echo "🔍 Verificando archivos críticos..."
for file in "${sensitive_files[@]}"; do
    if [ -f "$file" ]; then
        # Verificar si está siendo trackeado por git
        if git ls-files --error-unmatch "$file" >/dev/null 2>&1; then
            show_error "CRÍTICO: $file está siendo trackeado por git"
            has_issues=true
        else
            show_success "$file existe pero está correctamente ignorado"
        fi
    fi
done

# Verificar patrones peligrosos en git status
echo ""
echo "🔍 Verificando archivos staged..."
staged_files=$(git diff --cached --name-only)
if [ -n "$staged_files" ]; then
    while IFS= read -r file; do
        # Verificar extensiones peligrosas
        case "$file" in
            *.env|*.key|*.p12|*.p8|*.jks|*.keystore)
                show_error "PELIGRO: $file está staged (extensión sensible)"
                has_issues=true
                ;;
            *key.properties|*firebase*|*google-services*)
                show_error "PELIGRO: $file está staged (archivo de configuración)"
                has_issues=true
                ;;
            *.log|*.tmp|*.backup)
                show_warning "Revisar: $file (archivo temporal/log)"
                ;;
        esac
    done <<< "$staged_files"
    
    if [ "$has_issues" = false ]; then
        show_success "Archivos staged verificados"
    fi
else
    show_info "No hay archivos staged"
fi

# Verificar archivos no trackeados peligrosos
echo ""
echo "🔍 Verificando archivos no trackeados..."
untracked_files=$(git ls-files --others --exclude-standard)
dangerous_untracked=()

if [ -n "$untracked_files" ]; then
    while IFS= read -r file; do
        case "$file" in
            *.env|*.key|*.p12|*.p8|*.jks|*.keystore)
                dangerous_untracked+=("$file")
                ;;
            *key.properties|*firebase*|*google-services*)
                dangerous_untracked+=("$file")
                ;;
        esac
    done <<< "$untracked_files"
    
    if [ ${#dangerous_untracked[@]} -gt 0 ]; then
        show_warning "Archivos sensibles no trackeados encontrados:"
        for file in "${dangerous_untracked[@]}"; do
            echo "  - $file"
        done
        show_info "Asegúrate de que estén en .gitignore"
    else
        show_success "No se encontraron archivos no trackeados peligrosos"
    fi
fi

# Verificar .gitignore
echo ""
echo "🔍 Verificando .gitignore..."
if [ -f ".gitignore" ]; then
    # Verificar que contiene reglas básicas
    essential_rules=(".env" "*.keystore" "*.p12" "key.properties")
    missing_rules=()
    
    for rule in "${essential_rules[@]}"; do
        if ! grep -q "$rule" .gitignore; then
            missing_rules+=("$rule")
        fi
    done
    
    if [ ${#missing_rules[@]} -gt 0 ]; then
        show_warning ".gitignore podría necesitar estas reglas:"
        for rule in "${missing_rules[@]}"; do
            echo "  - $rule"
        done
    else
        show_success ".gitignore contiene reglas esenciales"
    fi
else
    show_error ".gitignore no existe"
    has_issues=true
fi

# Verificar configuración de usuario git
echo ""
echo "🔍 Verificando configuración git..."
git_email=$(git config user.email)
if [[ "$git_email" == *"@"* ]]; then
    show_success "Email git configurado: $git_email"
else
    show_warning "Email git no configurado correctamente"
fi

# Verificar el archivo .env.example
echo ""
echo "🔍 Verificando template de variables..."
if [ -f ".env.example" ]; then
    show_success ".env.example existe"
    if [ -f ".env" ]; then
        # Comparar claves
        if command -v comm >/dev/null 2>&1; then
            example_keys=$(grep -E '^[A-Z_]+=.*' .env.example | cut -d'=' -f1 | sort)
            env_keys=$(grep -E '^[A-Z_]+=.*' .env | cut -d'=' -f1 | sort)
            missing_in_env=$(comm -23 <(echo "$example_keys") <(echo "$env_keys"))
            
            if [ -n "$missing_in_env" ]; then
                show_warning "Variables en .env.example pero no en .env:"
                echo "$missing_in_env" | sed 's/^/  - /'
            fi
        fi
    else
        show_warning ".env no existe, cópialo desde .env.example"
    fi
else
    show_warning ".env.example no existe"
fi

# Verificar histórico de commits peligrosos (últimos 10)
echo ""
echo "🔍 Verificando histórico reciente..."
recent_commits=$(git log --oneline -10 --name-only | grep -E '\.(env|key|p12|p8|jks|keystore)$|key\.properties|firebase|google-services' | head -5)
if [ -n "$recent_commits" ]; then
    show_warning "Archivos sensibles en commits recientes:"
    echo "$recent_commits" | sed 's/^/  - /'
    show_info "Considera usar git filter-branch para limpiar el historial"
fi

# Resumen final
echo ""
echo "========================================"
if [ "$has_issues" = true ]; then
    show_error "VERIFICACIÓN FALLIDA"
    echo ""
    echo "🚨 ACCIONES REQUERIDAS:"
    echo "1. NO hagas commit hasta resolver los problemas"
    echo "2. Remueve archivos sensibles del staging: git reset HEAD <archivo>"
    echo "3. Agrega reglas faltantes al .gitignore"
    echo "4. Si ya commitiste archivos sensibles, limpia el historial"
    echo ""
    exit 1
else
    show_success "VERIFICACIÓN EXITOSA"
    echo ""
    echo "✨ Todo está seguro para commit"
    echo "💡 Recuerda siempre revisar los archivos antes de commit"
    echo ""
fi

# Mostrar comandos útiles
echo "🛠️  Comandos útiles:"
echo "  git status                    # Ver estado actual"
echo "  git reset HEAD <archivo>      # Quitar archivo del staging"
echo "  git rm --cached <archivo>     # Quitar archivo del tracking"
echo "  ./setup_env.sh               # Configurar entorno"
echo ""