# KDany's CS2 map source files

Welcome to my central repository for Counter-Strike 2 mapping projects. This repository serves as a personal portfolio and a public archive containing the raw source files, geometry, and custom assets for my custom maps built using the Source 2 Hammer Editor.

Feel free to explore the files, learn from the geometry setup, or use the source files to create your own community variants of my maps!

## 📂 Repository Structure & How to Import

This repository only stores the raw, uncompiled development source files located under the engine's `content/` directory. Compiled game files (`game/` directory containing `.vpk` files) and temporary compiler logs are strictly excluded via `.gitignore`.

Each map project has its own dedicated addon directory:
- `content/csgo_addons/[map_name_1]/maps/` -> Contains the primary `.vmap` file(s) for Map 1.
- `content/csgo_addons/[map_name_2]/maps/` -> Contains the primary `.vmap` file(s) for Map 2.

### 🛠️ Minimal Requirements to Import a Map:
To open and edit any of these maps in your own CS2 Workshop Tools:
1. Create a new addon inside the **CS2 Workshop Tools** manager.
2. Navigate to your Counter-Strike 2 installation folder, specifically: `Counter-Strike Global Offensive/content/csgo_addons/[your_addon_name]/maps/`.
3. Copy the desired **`.vmap`** file from this repository and drop it into that `maps` folder.
4. Open the Hammer Editor, hit **File > Open**, and select the `.vmap` file. 
*(Note: If a map utilizes custom, non-valve materials or models, you will also need to copy their respective source assets into the matching `materials/` or `models/` folders inside your content directory).*

## 📜 License & Community Usage

All projects and source files within this repository are licensed under the **Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)** License. 

### What you CAN do:
- 🌍 **Share & Adapt:** You are free to download, edit, re-texture, or remix these source files to create new community variants (e.g., Wingman versions, night/winter themes, Retake setups, or optimization mods).

### What you MUST do:
- 👤 **Attribution:** You must give appropriate credit, provide a link to the license, and indicate if changes were made. You must clearly state the original author's name and link back to this GitHub repository.
- 🔄 **ShareAlike:** If you remix, transform, or build upon any of these maps, you must distribute your contributions under the exact same CC BY-NC-SA 4.0 license as the original.

### What you CANNOT do:
- 💰 **Non-Commercial:** You may not use these materials for commercial purposes. This means you cannot sell these maps, use them on monetized/paywalled community servers, or enter them into paid tournaments without explicit prior permission.

For the full legal terms, please read the accompanying `LICENSE` file.

## 📝 How to Credit Me

If you use assets from this repository or publish a modified community version of any map found here on the Steam Workshop, please copy and paste the following line into your Workshop description:

> *Based on the original CS2 map by KDany - GitHub: https://github.com/KDany/cs2-maps/[path-to-the-map]*

Thank you for respecting the hundreds of hours that went into these projects! Good luck with your mapping!
