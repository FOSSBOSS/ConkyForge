# ?? ConkyForge V10.41.1 - Universal Matrix Update

ConkyForge es un entorno de desarrollo web visual (WYSIWYG) diseñado para generar configuraciones avanzadas de **Conky** y scripts de renderizado gráfico mediante **Lua y Cairo API**. Permite a los usuarios diseñar widgets de escritorio de alta fidelidad, anillos concéntricos, relojes analógicos y barras de estado a través de una interfaz de arrastrar y soltar (Drag & Drop), eliminando la necesidad de escribir código declarativo o scripts matemáticos manualmente.

La versión **V10.41.1** (Universal Matrix Update) introduce una arquitectura de compatibilidad total que resuelve los problemas de renderizado en entornos mixtos X11/Wayland y gestiona dinámicamente la fragmentación de las librerías de Cairo introducidas en Conky 1.21+.

---

## ? Características Principales

* **Motor de Interfaz Drag & Drop:** Lienzo milimetrado con cuadrícula (Grid) de 20px para el posicionamiento rápido de bloques de información.
* **Gestión Dinámica de Color:** Paleta de colores globales inyectada directamente como variables HEX en `conky.conf` y ratios RGB en `visuals.lua`.
* **Modo Francotirador (Sniper Mode):** Sistema de ajuste de coordenadas X/Y a nivel de píxel haciendo doble clic en cualquier widget del lienzo.
* **Renderizado Vectorial Lua/Cairo:** Generación de gráficos de hardware puros (CPU/RAM Rings, ecualizadores, relojes analógicos y gráficos duales para GPUs AMD/NVIDIA).
* **Motor de Animación PNG:** Lógica de rotación de fotogramas (Frame-rate) vinculada a los ciclos de actualización (`${updates}`) de Conky para renderizar sprites PNG animados.
* **Persistencia Local:** Guardado y carga de proyectos en formato JSON nativo utilizando el `localStorage` del navegador web.

---

## ? Notas y Trucos de Forja (¡Importante!)

Para sacarle el máximo partido a las herramientas visuales, ten en cuenta estas reglas del motor interno:

### ? Cómo funcionan los PNG Animados
El motor Lua interpola y busca los fotogramas dinámicamente. Para que funcione sin dar `ERROR PNG`:
1. **Nomenclatura Secuencial:** Tus imágenes deben estar nombradas con números puros, **sin ceros a la izquierda**. (Ejemplo correcto: `frame1.png`, `frame2.png` ... `frame10.png`).
2. **Ruta Absoluta estricta:** En el campo "Prefijo" de la Forja, **debes poner siempre la `/` inicial** de tu disco duro.
3. **El Prefijo es el nombre base:** En el cajetín de texto, escribe la ruta completa terminando justo *antes* del número. 
   * *Ejemplo:* Si tus imágenes están en `/home/usuario/anim/fan1.png`, el prefijo exacto que debes escribir en la Forja es: `/home/usuario/anim/fan`

### ? Espaciado de Texto (Kerning)
Cuando añadas "Texto Horizontal" o "Texto Vertical", la herramienta te pedirá tres valores: `Texto, Tamaño, Espaciado`. 
* **El espaciado admite valores negativos** (ej. `-2`, `-5`). Esto es tremendamente útil para fuentes con mucho margen o si quieres crear un efecto estilizado donde las letras se solapen ligeramente.

---

## ?? Detalles Técnicos (Compatibilidad Wayland)

A partir de Conky 1.21, los desarrolladores separaron los bindings de Cairo (`cairo_xlib` y `cairo_wayland`) del módulo principal `cairo`. ConkyForge soluciona la retrocompatibilidad mediante **Llamadas Protegidas (`pcall`)** y **Auto-Detección de Superficie** en tiempo de ejecución, asignando el lienzo dinámicamente ya sea en XWayland o Wayland nativo.

---

## ? Instalación y Despliegue

ConkyForge no requiere instalación (es un archivo HTML estático), pero para facilitar la preparación del sistema host, proporcionamos un **Script Auto-Instalador Bash** (`install_conkyforge.sh`). Este script detecta tu gestor de paquetes, instala `conky-all` y configura los directorios base en `~/.config/conky/`.

---

## ? Guía de Uso Rápida

1.  Abre `conkyforge.html` en tu navegador.
2.  Ajusta los parámetros globales (fuente, resolución, zoom y colores).
3.  Arrastra y suelta widgets en el lienzo. Haz doble clic en ellos para activar el *Modo Francotirador*.
4.  Haz clic en **"FORJAR CONKY"**. Descargarás `conky.conf` y `visuals.lua`.
5.  Mueve ambos archivos a `~/.config/conky/` y ejecuta: `killall conky ; conky -c ~/.config/conky/conky.conf &`