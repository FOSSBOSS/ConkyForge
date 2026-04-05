#!/bin/bash

# ====================================================
# 🛠️ SCRIPT AUTO-INSTALADOR DE CONKYFORGE 🛠️
# ====================================================

echo -e "\e[1;36m=================================================\e[0m"
echo -e "\e[1;36m       🛠️ CONKYFORGE UNIVERSAL INSTALLER 🛠️       \e[0m"
echo -e "\e[1;36m=================================================\e[0m"
echo ""

# 1. CREAR EL TALLER (DIRECTORIOS)
echo -e "\e[1;33m[1/4] Preparando la forja (Directorios)...\e[0m"
mkdir -p ~/.config/conky
echo "Directorio ~/.config/conky creado y listo."
echo ""

# 2. DETECCIÓN Y DESCARGA DE HERRAMIENTAS
echo -e "\e[1;33m[2/4] Buscando en la armería tu sistema operativo...\e[0m"

if command -v apt &> /dev/null; then
    echo "Detectado sistema Debian/Ubuntu/Mint."
    sudo apt update
    sudo apt install -y conky-all wget
elif command -v pacman &> /dev/null; then
    echo "Detectado sistema Arch/Manjaro/EndeavourOS."
    sudo pacman -Sy --noconfirm conky wget
elif command -v dnf &> /dev/null; then
    echo "Detectado sistema Fedora/RHEL."
    sudo dnf install -y conky wget
elif command -v zypper &> /dev/null; then
    echo "Detectado sistema openSUSE."
    sudo zypper install -y conky wget
else
    echo -e "\e[1;31mNo pude reconocer tu gestor de paquetes. Tendrás que instalar Conky manualmente.\e[0m"
fi
echo ""

# 3. EL PROTOCOLO "WAYLAND" (VERSIÓN APPIMAGE)
echo -e "\e[1;33m[3/4] Protocolo de Seguridad Gráfica\e[0m"
if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
    echo -e "\e[1;35m⚠️ ATENCIÓN: Detectado entorno WAYLAND puro.\e[0m"
    echo -e "En sistemas modernos (como Ubuntu 26.04+), la versión del sistema de Conky"
    echo -e "puede no tener soporte para gráficos Lua. ¿Quieres descargar la versión"
    echo -e "Universal (AppImage) que incluye todas las librerías a prueba de fallos?"
else
    echo -e "¿Quieres descargar la versión Universal (AppImage) de Conky de todas formas?"
fi

read -p "(s/N): " use_appimage
if [[ "$use_appimage" =~ ^[sS]$ ]]; then
    echo "Forjando el AppImage..."
    mkdir -p ~/Aplicaciones
    # Descargamos el AppImage estático de la última versión estable conocida y compatible
    wget -q --show-progress -O ~/Aplicaciones/Conky.AppImage "https://github.com/brndnmtthws/conky/releases/download/v1.19.2/conky-x86_64.AppImage"
    chmod +x ~/Aplicaciones/Conky.AppImage
    echo -e "\e[1;32mAppImage instalado en ~/Aplicaciones/Conky.AppImage\e[0m"
    CONKY_BIN="~/Aplicaciones/Conky.AppImage"
else
    CONKY_BIN="conky"
    echo -e "\e[1;32mUsando la versión nativa instalada en el sistema.\e[0m"
fi
echo ""

# 4. CONFIGURAR EL AUTO-INICIO (OPCIONAL)
echo -e "\e[1;33m[4/4] ¿Quieres que Conky arranque automáticamente al iniciar tu PC?\e[0m"
read -p "(S/n): " setup_autostart
if [[ ! "$setup_autostart" =~ ^[nN]$ ]]; then
    mkdir -p ~/.config/autostart
    cat <<EOF > ~/.config/autostart/conkyforge.desktop
[Desktop Entry]
Type=Application
Name=ConkyForge
Comment=Inicia los widgets de tu escritorio
Exec=sh -c "sleep 5 && killall conky ; env -u WAYLAND_DISPLAY $CONKY_BIN -c ~/.config/conky/conky.conf"
StartupNotify=false
Terminal=false
Hidden=false
EOF
    echo -e "\e[1;32m¡Autoinicio configurado! Arrancará 5 segundos después de entrar al escritorio.\e[0m"
fi
echo ""

# DESPEDIDA
echo -e "\e[1;32m=================================================\e[0m"
echo -e "\e[1;32m            🎉 ¡INSTALACIÓN COMPLETADA! 🎉        \e[0m"
echo -e "\e[1;32m=================================================\e[0m"
echo -e "\e[1;37mTus próximos pasos:\e[0m"
echo -e "1. Abre \e[1;36mConkyForge\e[0m en tu navegador web."
echo -e "2. Crea tu diseño y descarga los archivos."
echo -e "3. Mueve esos archivos a \e[1;36m~/.config/conky/\e[0m"
echo -e "4. Ejecuta \e[1;35m$CONKY_BIN -c ~/.config/conky/conky.conf\e[0m"
echo ""
