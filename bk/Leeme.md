# 🛠️ ConkyForge - Manual de Usuario

¡Bienvenido a ConkyForge! Una herramienta visual y en tu navegador para diseñar tus widgets de Conky sin tener que escribir interminables líneas de código a mano.

## 📋 Requisitos Previos (Dependencias)
Para que todos los módulos funcionen a la perfección, necesitas instalar algunos paquetes en tu distribución Linux:

* **Conky con soporte Lua/Cairo:** Asegúrate de tener instalado el paquete `conky-all` (en Ubuntu/Debian) o tener `conky` compilado con soporte lua.
* **Playerctl:** Para controlar reproductores multimedia. (`sudo apt install playerctl` o equivalente).
* **Audacious:** (Opcional) Si vas a usar el módulo nativo de Audacious.
* **Sensors:** Para medir temperaturas y ventiladores. (`sudo apt install lm-sensors`).
* **Nvidia-smi:** Para el anillo concéntrico de la GPU (solo necesario si usas tarjetas NVIDIA).
* **Python 3:** Requerido para el script de lectura de correo electrónico.

## 🚀 Cómo usar ConkyForge

1.  **Abre el editor:** Haz doble clic en el archivo HTML de ConkyForge para abrirlo en tu navegador.
2.  **Configura tu lienzo:** En el panel izquierdo, ajusta el ancho, el alto, los colores y la resolución de tu pantalla.
3.  **Añade Widgets:** Pulsa en los botones del panel izquierdo para ir añadiendo elementos al lienzo.
4.  **Coloca y ajusta:** Arrastra los widgets a la posición que desees. Puedes estirar su tamaño agarrando la esquina inferior derecha.
    * *Truco de Francotirador:* Si haces doble clic sobre un bloque, podrás ajustar su posición sumando o restando píxeles exactos (X e Y) para alinearlo a la perfección.
5.  **Forjar Conky:** Pulsa el botón inferior "FORJAR CONKY". El navegador descargará automáticamente dos archivos:
    * `conky.conf`: El motor principal.
    * `visuals.lua`: La magia que dibuja los anillos, gráficas complejas y fuentes personalizadas.

## 📂 Dónde colocar los archivos

Mueve los archivos descargados a tu carpeta personal de configuración de Conky:
```bash
mkdir -p ~/.config/conky/
mv Descargas/conky.conf ~/.config/conky/
mv Descargas/visuals.lua ~/.config/conky/

Asegúrate de que la "Ruta absoluta archivo LUA" en el panel izquierdo de ConkyForge coincida con la ruta donde has guardado el archivo visuals.lua (Ejemplo: /home/TU_USUARIO/.config/conky/visuals.lua).

✉️ Configurar el Correo (mail.py)
Si usas el widget de correo:

Abre el archivo mail.py con un editor de texto.

Cambia USERNAME por tu correo electrónico.

Cambia PASSWORD por tu contraseña. Si usas Gmail u Outlook, necesitarás crear una "Contraseña de aplicación" desde las opciones de seguridad de tu cuenta. No funciona con la contraseña normal.

Guarda el archivo en ~/.config/conky/mail.py y dale permisos de ejecución: chmod +x ~/.config/conky/mail.py.
