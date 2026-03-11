``markdown
# 🛠️ ConkyForge - User Guide

Welcome to ConkyForge! A visual, browser-based tool to design your Conky widgets without writing endless lines of code manually.

## 📋 Prerequisites (Dependencies)
To ensure all modules work perfectly, you need to install a few packages on your Linux distribution:

* **Conky with Lua/Cairo support:** Ensure you have the `conky-all` package installed (on Ubuntu/Debian) or `conky` compiled with lua support.
* **Playerctl:** To control media players. (`sudo apt install playerctl` or equivalent).
* **Audacious:** (Optional) If you plan to use the native Audacious module.
* **Sensors:** To read temperatures and fan speeds. (`sudo apt install lm-sensors`).
* **Nvidia-smi:** For the concentric GPU ring (only required if using NVIDIA graphic cards).
* **Python 3:** Required for the email checking script.

## 🚀 How to use ConkyForge

1.  **Open the editor:** Double-click the ConkyForge HTML file to open it in your web browser.
2.  **Set up your canvas:** On the left panel, adjust the width, height, colors, and your screen resolution.
3.  **Add Widgets:** Click the buttons on the left panel to spawn elements onto the canvas.
4.  **Place and resize:** Drag the widgets to your desired position. You can resize them by dragging the bottom-right corner.
    * *Sniper Trick:* If you double-click a block, you can adjust its position by adding or subtracting exact pixels (X and Y offsets) for perfect alignment.
5.  **Forge Conky:** Press the bottom "FORJAR CONKY" button. The browser will automatically download two files:
    * `conky.conf`: The main engine.
    * `visuals.lua`: The magic handling rings, complex graphs, and custom fonts.

## 📂 Where to place the files

Move the downloaded files to your personal Conky configuration folder:
```bash
mkdir -p ~/.config/conky/
mv Downloads/conky.conf ~/.config/conky/
mv Downloads/visuals.lua ~/.config/conky/
Make sure the "Ruta absoluta archivo LUA" (Absolute Lua path) in the ConkyForge left panel matches the exact path where you saved the visuals.lua file (Example: /home/YOUR_USER/.config/conky/visuals.lua).

✉️ Email Setup (mail.py)
If you use the Email widget:

Open the mail.py file with a text editor.

Change USERNAME to your email address.

Change PASSWORD to your password. If you use Gmail or Outlook, you will need to generate an "App Password" from your account's security settings. Regular passwords will not work.

Save the file in ~/.config/conky/mail.py and grant execution permissions: chmod +x ~/.config/conky/mail.py.
