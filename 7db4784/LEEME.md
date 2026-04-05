LEEME.md (Versión en Español)
Markdown
# 🛠️ ConkyForge V10.41 - Universal Matrix Update

ConkyForge es un entorno de desarrollo web visual (WYSIWYG) diseñado para generar configuraciones avanzadas de **Conky** y scripts de renderizado gráfico mediante **Lua y Cairo API**. Permite a los usuarios diseñar widgets de escritorio de alta fidelidad, anillos concéntricos, relojes analógicos y barras de estado a través de una interfaz de arrastrar y soltar (Drag & Drop), eliminando la necesidad de escribir código declarativo o scripts matemáticos manualmente.

La versión **V10.41** (Universal Matrix Update) introduce una arquitectura de compatibilidad total que resuelve los problemas de renderizado en entornos mixtos X11/Wayland y gestiona dinámicamente la fragmentación de las librerías de Cairo introducidas en Conky 1.21+.

---

## 🚀 Características Principales

* **Motor de Interfaz Drag & Drop:** Lienzo milimetrado con cuadrícula (Grid) de 20px para el posicionamiento rápido de bloques de información.
* **Gestión Dinámica de Color:** Paleta de colores globales inyectada directamente como variables HEX en `conky.conf` y ratios RGB en `visuals.lua`.
* **Modo Francotirador (Sniper Mode):** Sistema de ajuste de coordenadas X/Y a nivel de píxel haciendo doble clic en cualquier widget del lienzo.
* **Renderizado Vectorial Lua/Cairo:** Generación de gráficos de hardware puros (CPU/RAM Rings, ecualizadores, relojes analógicos y gráficos duales para GPUs AMD/NVIDIA) mediante funciones matemáticas pre-compiladas en Lua.
* **Motor de Animación PNG:** Lógica de rotación de fotogramas (Frame-rate) vinculada a los ciclos de actualización (`${updates}`) de Conky para renderizar sprites PNG animados.
* **Persistencia Local:** Guardado y carga de proyectos en formato JSON nativo utilizando el `localStorage` del navegador web.

---

## ⚙️ Detalles Técnicos (V10.41 Universal Matrix)

A partir de Conky 1.21, los desarrolladores separaron los bindings de Cairo (`cairo_xlib` y `cairo_wayland`) del módulo principal `cairo`. ConkyForge V10.41 soluciona la retrocompatibilidad mediante:

1.  **Llamadas Protegidas (`pcall`):** El script Lua generado utiliza `pcall` para importar las librerías gráficas. Si un usuario ejecuta un binario antiguo de Conky, la llamada fallará silenciosamente sin colapsar el entorno.
    ```lua
    require 'cairo'
    pcall(require, 'cairo_xlib')
    pcall(require, 'cairo_wayland')
    ```
2.  **Auto-Detección de Superficie (Surface Auto-Detection):** El motor gráfico verifica la disponibilidad de la superficie de dibujo en tiempo de ejecución (Runtime) y asigna el lienzo dinámicamente, asegurando el funcionamiento tanto en XWayland como en Wayland nativo futuro.
    ```lua
    if cairo_xlib_surface_create ~= nil then
        cs = cairo_xlib_surface_create(...)
    elseif cairo_wayland_surface_create ~= nil then
        cs = cairo_wayland_surface_create(...)
    end
    ```

---

## 📦 Instalación y Despliegue

ConkyForge no requiere instalación per se (es un archivo HTML estático), pero el sistema anfitrión necesita las dependencias de Conky. Para facilitar el despliegue, proporcionamos un **Script Auto-Instalador Bash**.

### Ejecutar el Auto-Instalador
Descarga y ejecuta el instalador en tu terminal. Este script detectará tu gestor de paquetes (APT, Pacman, DNF, Zypper), instalará `conky-all`, creará los directorios base en `~/.config/conky/` y configurará el autoinicio.

```bash
chmod +x install_conkyforge.sh
./install_conkyforge.sh
Nota para usuarios de Wayland puro (Ej. Ubuntu 26.04+): El instalador detectará si tu entorno carece de soporte X11/Lua-Cairo nativo y te ofrecerá descargar e integrar automáticamente un AppImage estático de Conky 1.19.2 a prueba de fallos.

📖 Guía de Uso
Abre el Taller: Ejecuta el archivo conkyforge.html en cualquier navegador web moderno (Firefox, Chrome, Edge).

Ajusta los Parámetros Globales: Define tu resolución, fuente del sistema (ej. DejaVu Sans, Ubuntu, Hack), tamaño del lienzo y colores en el panel lateral.

Añade Widgets: Selecciona elementos de las secciones Sistema, Red o Matriz Lua. Arrástralos por el lienzo.

Ajuste Fino: Haz doble clic en cualquier widget para abrir el Modo Francotirador y aplicar un offset micrométrico en X/Y.

Forjar: Haz clic en "FORJAR CONKY". Se descargarán dos archivos:

conky.conf: El archivo de configuración principal (texto y posicionamiento).

visuals.lua: El motor matemático para el renderizado vectorial.

Desplegar: Mueve ambos archivos a ~/.config/conky/ y reinicia Conky:

Bash
killall conky ; conky -c ~/.config/conky/conky.conf &
🧩 Dependencias Recomendadas del Host
Para que todos los módulos generados por la Forja obtengan datos reales, se recomienda tener instalados los siguientes paquetes en el sistema host:

conky-all (Binario principal con soporte Lua/Cairo activado).

curl (Para el módulo de IP Pública y Clima vía wttr.in).

lm-sensors (Para la lectura precisa de temperaturas de CPU/GPU).

playerctl (Para el módulo de control y lectura multimedia).

python3 (Si se utiliza el módulo personalizado de escaneo de Email).
