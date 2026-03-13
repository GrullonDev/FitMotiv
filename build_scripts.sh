#!/bin/bash

# Scripts para compilar la aplicación con diferentes flavors

echo "🚀 FitMotiv Build Scripts"
echo "========================="

# Función para mostrar ayuda
show_help() {
    echo "Uso: ./build_scripts.sh [COMANDO]"
    echo ""
    echo "Comandos disponibles:"
    echo "  dev-android     - Compilar APK de desarrollo para Android"
    echo "  prod-android    - Compilar APK de producción para Android"
    echo "  dev-ios         - Compilar app de desarrollo para iOS"
    echo "  prod-ios        - Compilar app de producción para iOS"
    echo "  run-dev         - Ejecutar app en modo desarrollo"
    echo "  run-prod        - Ejecutar app en modo producción"
    echo "  install         - Instalar dependencias"
    echo "  clean           - Limpieza estándar (fvm flutter clean + pub get)"
    echo "  deep-clean      - Limpieza profunda (borra Pods, .dart_tool + reinstall)"
    echo "  ultra-clean     - Limpieza máxima (borra TODO, incluso fvm local, sin reinstall)"
    echo "  help            - Mostrar esta ayuda"
    echo ""
}

# Función para instalar dependencias
install_deps() {
    echo "📦 Instalando dependencias..."
    if command -v fvm &> /dev/null && [ -f .fvmrc ]; then
        fvm flutter pub get
    else
        flutter pub get
    fi
}

# Función para limpiar proyecto
clean_project() {
    local deep=$1
    local install=$2
    echo "🧹 Limpiando proyecto..."
    
    # Determinar comando base (preferir fvm)
    local flutter_cmd="flutter"
    if command -v fvm &> /dev/null && [ -f .fvmrc ]; then
        flutter_cmd="fvm flutter"
    fi

    # Limpieza estándar de Flutter
    $flutter_cmd clean

    if [ "$deep" == "deep" ] || [ "$deep" == "ultra" ]; then
        echo "🚿 Realizando limpieza PROFUNDA (Deep Clean)..."
        
        # Eliminar carpetas que se pueden regenerar
        echo "🗑️ Eliminando .dart_tool, Pods, build, etc."
        rm -rf .dart_tool
        rm -rf build
        rm -rf .flutter-plugins
        rm -rf .flutter-plugins-dependencies
        rm -rf .pub-cache/
        
        # iOS
        if [ -d "ios" ]; then
            echo "🍎 Limpiando iOS Pods..."
            rm -rf ios/Pods
            rm -rf ios/.symlinks
            rm -rf ios/Podfile.lock
            rm -rf ios/Flutter/Flutter.framework
            rm -rf ios/Flutter/Flutter.podspec
        fi

        # macOS
        if [ -d "macos" ]; then
            echo "💻 Limpiando macOS Pods..."
            rm -rf macos/Pods
            rm -rf macos/.symlinks
            rm -rf macos/Podfile.lock
        fi

        # Android
        if [ -d "android" ]; then
            echo "🤖 Limpiando Android build artifacts..."
            rm -rf android/.gradle
            rm -rf android/app/build
        fi

        # Sistema
        echo "🧹 Eliminando archivos temporales del sistema (.DS_Store, etc.)..."
        find . -name ".DS_Store" -delete
        find . -name "*.log" -delete
    fi

    if [ "$deep" == "ultra" ]; then
        echo "🔥 Realizando limpieza ULTRA (Eliminando cache de fvm locally if exists)..."
        # Ojo: esto borra el SDK local de fvm en este proyecto si está configurado para estar aquí
        if [ -d ".fvm/versions" ]; then
            rm -rf .fvm/versions
        fi
    fi

    if [ "$install" != "no-install" ]; then
        echo "📦 Reinstalando dependencias..."
        $flutter_cmd pub get
        
        if ([ "$deep" == "deep" ] || [ "$deep" == "ultra" ]) && [ -d "ios" ] && [[ "$OSTYPE" == "darwin"* ]]; then
            echo "🍎 Reinstalando Pods de iOS..."
            if command -v pod &> /dev/null; then
                cd ios && pod install && cd ..
            fi
        fi
    else
        echo "⚠️  No se reinstalaron dependencias. El proyecto ocupará el mínimo espacio posible."
    fi

    echo "✅ Proyecto limpio y listo."
}

# Determinar comando base (preferir fvm si está configurado)
FLUTTER="flutter"
if command -v fvm &> /dev/null && [ -f .fvmrc ]; then
    FLUTTER="fvm flutter"
fi

# Función para ejecutar en desarrollo
run_dev() {
    echo "🏃‍♂️ Ejecutando en modo desarrollo..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/iOS - sin flavor para evitar problemas con Xcode schemes
        $FLUTTER run -t lib/main_dev.dart
    else
        # Android - con flavor
        $FLUTTER run -t lib/main_dev.dart --flavor dev
    fi
}

# Función para ejecutar en producción
run_prod() {
    echo "🏃‍♂️ Ejecutando en modo producción..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/iOS - sin flavor
        $FLUTTER run -t lib/main_prod.dart
    else
        # Android - con flavor
        $FLUTTER run -t lib/main_prod.dart --flavor prod
    fi
}

# Función para compilar APK de desarrollo
build_dev_android() {
    echo "🤖 Compilando APK de desarrollo para Android..."
    $FLUTTER build apk -t lib/main_dev.dart --flavor dev --debug
    echo "✅ APK de desarrollo generado en: build/app/outputs/flutter-apk/"
}

# Función para compilar APK de producción
build_prod_android() {
    echo "🤖 Compilando APK de producción para Android..."
    $FLUTTER build apk -t lib/main_prod.dart --flavor prod --release
    echo "✅ APK de producción generado en: build/app/outputs/flutter-apk/"
}

# Función para compilar iOS desarrollo
build_dev_ios() {
    echo "🍎 Compilando app de desarrollo para iOS..."
    $FLUTTER build ios -t lib/main_dev.dart --debug --no-codesign
    echo "✅ App de desarrollo para iOS compilada"
}

# Función para compilar iOS producción
build_prod_ios() {
    echo "🍎 Compilando app de producción para iOS..."
    $FLUTTER build ios -t lib/main_prod.dart --release --no-codesign
    echo "✅ App de producción para iOS compilada"
}

# Verificar si Flutter está instalado (o fvm)
if ! command -v flutter &> /dev/null && ! command -v fvm &> /dev/null; then
    echo "❌ Error: Ni Flutter ni FVM están instalados o no están en el PATH"
    exit 1
fi

# Procesar argumentos
case "$1" in
    "dev-android")
        build_dev_android
        ;;
    "prod-android")
        build_prod_android
        ;;
    "dev-ios")
        build_dev_ios
        ;;
    "prod-ios")
        build_prod_ios
        ;;
    "run-dev")
        run_dev
        ;;
    "run-prod")
        run_prod
        ;;
    "install")
        install_deps
        ;;
    "clean")
        clean_project
        ;;
    "deep-clean")
        clean_project "deep"
        ;;
    "ultra-clean")
        clean_project "ultra" "no-install"
        ;;
    "help"|"")
        show_help
        ;;
    *)
        echo "❌ Comando no reconocido: $1"
        echo ""
        show_help
        exit 1
        ;;
esac