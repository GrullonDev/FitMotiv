#!/bin/bash

# Script de configuración inicial para FitMotiv
# Ejecuta: ./setup_env.sh

echo "🚀 Configuración inicial de FitMotiv"
echo "=================================="

# Verificar si Flutter está instalado
if ! command -v flutter &> /dev/null; then
    echo "❌ Error: Flutter no está instalado o no está en el PATH"
    echo "   Instala Flutter desde: https://flutter.dev/docs/get-started/install"
    exit 1
fi

echo "✅ Flutter encontrado: $(flutter --version | head -n 1)"

# Verificar si existe .env
if [ ! -f ".env" ]; then
    echo "📝 Creando archivo .env desde .env.example..."
    if [ -f ".env.example" ]; then
        cp .env.example .env
        echo "✅ Archivo .env creado"
        echo "⚠️  IMPORTANTE: Edita el archivo .env con tus configuraciones reales"
        echo "   Especialmente las URLs de API:"
        echo "   - DEV_API_URL: URL de tu servidor de desarrollo"
        echo "   - PROD_API_URL: URL de tu servidor de producción"
    else
        echo "❌ Error: Archivo .env.example no encontrado"
        exit 1
    fi
else
    echo "✅ Archivo .env ya existe"
fi

# Instalar dependencias
echo "📦 Instalando dependencias de Flutter..."
flutter pub get

if [ $? -eq 0 ]; then
    echo "✅ Dependencias instaladas correctamente"
else
    echo "❌ Error instalando dependencias"
    exit 1
fi

# Verificar análisis de código
echo "🔍 Ejecutando análisis de código..."
flutter analyze

if [ $? -eq 0 ]; then
    echo "✅ Análisis de código completado sin errores"
else
    echo "⚠️  Hay issues en el análisis de código, pero puedes continuar"
fi

# Verificar dispositivos disponibles
echo "📱 Verificando dispositivos disponibles..."
flutter devices

echo ""
echo "🎉 ¡Configuración completada!"
echo ""
echo "📋 Próximos pasos:"
echo "1. Edita el archivo .env con tus URLs reales"
echo "2. IMPORTANTE: Asegúrate de tener el backend ejecutándose en localhost:8000"
echo "3. Obtén el backend de: https://github.com/GrullonDev/FitMotiv-Backend"
echo "4. Abre VS Code en este directorio"
echo "5. Presiona F5 y selecciona 'FitMotiv (Dev)'"
echo "6. O ejecuta: flutter run -t lib/main_dev.dart"
echo ""
echo "📖 Documentación completa en README.md"
echo ""
echo "🆘 Si tienes problemas:"
echo "- Revisa que el archivo .env tenga las URLs correctas"
echo "- Verifica que el backend esté ejecutándose en localhost:8000"
echo "- Asegúrate de tener un dispositivo/emulador conectado"
echo "- Ejecuta: flutter doctor para verificar tu instalación"