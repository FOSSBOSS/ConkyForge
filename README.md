# 🛠️ ConkyForge V10.41.1 - Universal Matrix Update

ConkyForge is a visual, web-based WYSIWYG (What You See Is What You Get) development environment designed to generate advanced **Conky** configurations and graphical rendering scripts via the **Lua and Cairo API**. It empowers users to design high-fidelity desktop widgets, concentric rings, analog clocks, and status bars through a Drag & Drop interface, eliminating the need to manually write declarative code or mathematical scripts.

Version **V10.41.1** (Universal Matrix Update) introduces a full-compatibility architecture that resolves rendering issues in mixed X11/Wayland environments and dynamically manages the Cairo library fragmentation introduced in Conky 1.21+.

---

## ✨ Key Features

* **Drag & Drop Engine:** Millimetric canvas with a 20px grid for rapid positioning of information blocks.
* **Dynamic Color Management:** Global color palette injected directly as HEX variables into `conky.conf` and RGB ratios into `visuals.lua`.
* **Sniper Mode:** Pixel-perfect X/Y coordinate adjustment system accessible by double-clicking any widget on the canvas.
* **Lua/Cairo Vector Rendering:** Generation of pure hardware graphics (CPU/RAM Rings, equalizers, analog clocks, and dual graphs for AMD/NVIDIA GPUs).
* **PNG Animation Engine:** Frame-rate rotation logic tied to Conky's update cycles (`${updates}`) to render animated PNG sprites.
* **Local Persistence:** Save and load projects in native JSON format using the web browser's `localStorage`.

---

## 💡 Forge Tips & Tricks (Important!)

To get the most out of the visual tools, keep these internal engine rules in mind:

### 🖼️ How Animated PNGs Work
The Lua engine interpolates and fetches frames dynamically. To avoid `PNG ERROR` messages:

1.  **Sequential Naming:** Your images must be named with pure numbers, **without leading zeros**. (Correct example: `frame1.png`, `frame2.png` ... `frame10.png`).
2.  **Strict Absolute Path:** In the Forge's "Prefix" field, **you must always start with the initial `/`** of your file system.
3.  **The Prefix is the Base Name:** In the text prompt, write the full path ending exactly *before* the number. 
    * *Example:* If your images are located at `/home/user/anim/fan1.png`, the exact prefix you must enter in the Forge is: `/home/user/anim/fan`

### ⌨️ Text Spacing (Kerning)
When adding "Horizontal Text" or "Vertical Text", the tool will ask for three values: `Text, Size, Spacing`.
* **Spacing accepts negative values** (e.g., `-2`, `-5`). This is incredibly useful for fonts with wide natural kerning or if you want to create a stylized effect where letters slightly overlap.

---

## ⚙️ Technical Details (Wayland Compatibility)

Starting with Conky 1.21, developers decoupled the Cairo bindings (`cairo_xlib` and `cairo_wayland`) from the main `cairo` module. ConkyForge handles backward compatibility using **Protected Calls (`pcall`)** and **Surface Auto-Detection** at runtime, dynamically allocating the canvas whether you are running XWayland or native Wayland.

---

## 🚀 Installation and Deployment

ConkyForge does not require installation (it is a static HTML file), but to streamline host system preparation, we provide an **Automated Bash Installer Script** (`install_conkyforge.sh`). This script detects your package manager, installs `conky-all`, and sets up the base directories at `~/.config/conky/`.

---

## 📖 Quick Usage Guide

1.  Open `conkyforge.html` in your browser.
2.  Tweak global parameters (font, resolution, zoom, and colors).
3.  Drag and drop widgets onto the canvas. Double-click them to activate *Sniper Mode*.
4.  Click on **"FORGE CONKY"**. You will download `conky.conf` and `visuals.lua`.
5.  Move both files to `~/.config/conky/` and run: 
    ```bash
    killall conky ; conky -c ~/.config/conky/conky.conf &
    ```