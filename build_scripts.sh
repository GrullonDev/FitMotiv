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
    echo "  clean           - Limpiar proyecto"
    echo "  help            - Mostrar esta ayuda"
    echo ""
}

# Función para instalar dependencias
install_deps() {
    echo "📦 Instalando dependencias..."
    flutter pub get
}

# Función para limpiar proyecto
clean_project() {
    echo "🧹 Limpiando proyecto..."
    flutter clean
    flutter pub get
}

# Función para ejecutar en desarrollo
run_dev() {
    echo "🏃‍♂️ Ejecutando en modo desarrollo..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/iOS - sin flavor para evitar problemas con Xcode schemes
        flutter run -t lib/main_dev.dart
    else
        # Android - con flavor
        flutter run -t lib/main_dev.dart --flavor dev
    fi
}

# Función para ejecutar en producción
run_prod() {
    echo "🏃‍♂️ Ejecutando en modo producción..."
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS/iOS - sin flavor
        flutter run -t lib/main_prod.dart
    else
        # Android - con flavor
        flutter run -t lib/main_prod.dart --flavor prod
    fi
}

# Función para compilar APK de desarrollo
build_dev_android() {
    echo "🤖 Compilando APK de desarrollo para Android..."
    flutter build apk -t lib/main_dev.dart --flavor dev --debug
    echo "✅ APK de desarrollo generado en: build/app/outputs/flutter-apk/"
}

# Función para compilar APK de producción
build_prod_android() {
    echo "🤖 Compilando APK de producción para Android..."
    flutter build apk -t lib/main_prod.dart --flavor prod --release
    echo "✅ APK de producción generado en: build/app/outputs/flutter-apk/"
}

# Función para compilar iOS desarrollo
build_dev_ios() {
    echo "🍎 Compilando app de desarrollo para iOS..."
    flutter build ios -t lib/main_dev.dart --debug --no-codesign
    echo "✅ App de desarrollo para iOS compilada"
}

# Función para compilar iOS producción
build_prod_ios() {
    echo "🍎 Compilando app de producción para iOS..."
    flutter build ios -t lib/main_prod.dart --release --no-codesign
    echo "✅ App de producción para iOS compilada"
}

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter no está instalado o no está en el PATH"
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