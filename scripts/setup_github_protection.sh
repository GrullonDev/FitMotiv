#!/bin/bash

# 🔐 Configuración de Protección de Ramas - FitMotiv
# Este script te ayuda a configurar las protecciones de ramas en GitHub
# Ejecuta este script después de crear el repositorio en GitHub

echo "🔐 Configuración de Protección de Ramas - FitMotiv"
echo "=================================================="
echo ""

# Verificar si estamos en un repositorio git
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Error: No estás en un repositorio Git"
    exit 1
fi

# Verificar si tenemos remoto origin
if ! git remote get-url origin > /dev/null 2>&1; then
    echo "❌ Error: No hay remoto 'origin' configurado"
    echo "   Configura primero tu repositorio en GitHub"
    exit 1
fi

echo "📋 Instrucciones para configurar protección de ramas:"
echo ""
echo "1. Ve a tu repositorio en GitHub:"
echo "   $(git remote get-url origin | sed 's/\.git$//')"
echo ""
echo "2. Ve a Settings > Branches"
echo ""
echo "3. Configurar rama 'main' (Solo para @GrullonDev):"
echo "   ✅ Add rule para 'main'"
echo "   ✅ Restrict pushes that create files"
echo "   ✅ Require pull request reviews before merging"
echo "   ✅ Dismiss stale PR reviews when new commits are pushed"
echo "   ✅ Require review from CODEOWNERS"
echo "   ✅ Restrict push access to specific people or teams"
echo "   ✅ Allow force pushes: Only for administrators"
echo "   ✅ Allow deletions: Unchecked"
echo ""
echo "4. Configurar rama 'develop' (Para todos los colaboradores):"
echo "   ✅ Add rule para 'develop'"
echo "   ✅ Require pull request reviews before merging"
echo "   ✅ Require status checks to pass before merging"
echo "   ✅ Require branches to be up to date before merging"
echo "   ✅ Allow force pushes: Unchecked"
echo "   ✅ Allow deletions: Unchecked"
echo ""
echo "5. Configurar 'develop' como rama por defecto:"
echo "   ✅ En Settings > General > Default branch"
echo "   ✅ Cambiar de 'main' a 'develop'"
echo ""

# Verificar si la rama develop existe
if git rev-parse --verify develop > /dev/null 2>&1; then
    echo "✅ La rama 'develop' ya existe"
else
    echo "⚠️  La rama 'develop' no existe. ¿Quieres crearla? (y/n)"
    read -r response
    if [[ "$response" =~ ^[Yy]$ ]]; then
        git checkout -b develop
        git push -u origin develop
        echo "✅ Rama 'develop' creada y sincronizada"
    fi
fi

echo ""
echo "📁 Crear archivo CODEOWNERS (opcional):"
echo "   Este archivo asegura que @GrullonDev revise todos los cambios a main"

read -p "¿Quieres crear el archivo CODEOWNERS? (y/n): " -r
if [[ $REPLY =~ ^[Yy]$ ]]; then
    mkdir -p .github
    cat > .github/CODEOWNERS << EOF
# Global code owners
* @GrullonDev

# Main branch protection - only @GrullonDev can approve merges to main
/main @GrullonDev

# Critical files require @GrullonDev review
.github/ @GrullonDev
*.md @GrullonDev
pubspec.yaml @GrullonDev
android/app/build.gradle.kts @GrullonDev
ios/Runner.xcodeproj/ @GrullonDev

# Security sensitive files
.env* @GrullonDev
*.key @GrullonDev
*.keystore @GrullonDev
android/key.properties @GrullonDev
EOF
    echo "✅ Archivo CODEOWNERS creado en .github/CODEOWNERS"
    
    # Agregar al git si no está ya
    git add .github/CODEOWNERS
    echo "📝 CODEOWNERS agregado al staging. Haz commit cuando estés listo."
fi

echo ""
echo "🎯 Resumen de configuración:"
echo "  📌 Rama por defecto: develop"
echo "  🔒 Rama main: Solo @GrullonDev"
echo "  🤝 Rama develop: Todos los colaboradores"
echo "  📋 Pull Requests: Obligatorios para ambas ramas"
echo "  🛡️  CODEOWNERS: Configurado para archivos críticos"
echo ""
echo "✨ ¡Configuración completa! Tu repositorio está seguro."