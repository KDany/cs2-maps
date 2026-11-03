[![License](https://img.shields.io/github/license/KDany/cs2-maps?logo=creativecommons&logoColor=white&color=brightgreen)](./LICENSE)
[![Game: Counter-Strike 2](https://img.shields.io/badge/Game-Counter--Strike%202-orange?logo=counterstrike&logoColor=white)](https://www.counter-strike.net/)
[![Forks](https://img.shields.io/github/forks/KDany/cs2-maps?logo=github)](https://github.com/KDany/cs2-maps/forks)
[![Last commit](https://img.shields.io/github/last-commit/KDany/cs2-maps)](https://github.com/KDany/cs2-maps/commits)
[![PRs: not accepted](https://img.shields.io/badge/PRs-not%20accepted-red)](./CONTRIBUTING.md)
[![Bugs: report here](https://img.shields.io/badge/Bugs-report%20here-yellow?logo=github)](https://github.com/KDany/steam-workshop/issues/new/choose)

# KDany's CS2 map source files

Welcome to my central repository for Counter-Strike 2 mapping projects. This repository serves as a personal portfolio and a public archive containing the raw source files, geometry, and custom assets for my custom maps built using the Source 2 Hammer Editor.

Feel free to explore the files, learn from the geometry setup, or use the source files to create your own community variants of my maps — just like in the good old 1.6 days!

## 📂 Repository Structure

This repository only stores the raw, uncompiled development source files that live under the engine's `content/` directory. Compiled game files (the `game/` directory with `.vpk` / `_c` files) and temporary compiler output are excluded via `.gitignore`.

Each map project has its own dedicated addon directory, mirroring the CS2 folder layout:

```
content/csgo_addons/<map_name>/
├── maps/        -> the primary .vmap file(s)
├── materials/   -> custom materials and textures (if any)
├── models/      -> custom models (if any)
└── sounds/      -> custom sounds (if any)
```

> **Large files:** Textures, models and audio are stored with [Git LFS](https://git-lfs.com/). Run `git lfs install` once before cloning, otherwise you will only get small pointer files instead of the real assets. Alternatively, use GitHub's **Code > Download ZIP**, which includes the LFS files.

## 🛠️ How to Open a Map in Hammer

1. Open the **CS2 Workshop Tools** and create a new addon. Give it **the same name** as the map's folder in this repository (e.g. `de_mymap`).
2. Close the tools, then copy the **entire contents** of `content/csgo_addons/<map_name>/` from this repository into your own
   `.../steamapps/common/Counter-Strike Global Offensive/content/csgo_addons/<map_name>/` folder (merge/overwrite when asked).
3. Launch the Workshop Tools with your addon, open Hammer, choose **File > Open**, and select the `.vmap` file from the `maps/` folder.

Copying the whole folder (not just the `.vmap`) makes sure that every custom material, model and sound the map depends on is in place.

## 🗺️ My CS2 Maps Portfolio

| Map Name | Game Mode | Raw Source Files (GitHub) | Playable Version (Steam Workshop) | Status / Notes |
| :--- | :--- | :--- | :--- | :--- |
| *Coming soon* | | | | |

<!--
Template row — copy it above when a map is uploaded:
| **de_mymap** | Defusal (5v5) | [Open Folder](./content/csgo_addons/de_mymap/) | [Steam Workshop](https://steamcommunity.com/sharedfiles/filedetails/?id=XXXXXXXXXX) | 🟢 Released |
Status legend: 🟢 Released · 🟡 Beta · 🔴 Alpha / Testing
-->

## 🌍 Community Variants

Made a Wingman cut, a night/winter version, a retake setup or any other variant of one of these maps? Open a [Community variant listing](https://github.com/KDany/cs2-maps/issues/new?template=variant_listing.yml) issue with a link to your fork and/or Workshop item and I will happily list it here!

| Variant | Based on | Author | Links |
| :--- | :--- | :--- | :--- |
| *None yet — be the first!* | | | |

## 📜 License & Community Usage

Copyright (c) 2026 KDany ([GitHub: KDany](https://github.com/KDany), [Steam ID: 76561198011807358](https://steamcommunity.com/profiles/76561198011807358))

All of my own work in this repository (map geometry, layouts and custom assets) is licensed under the **[Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)](https://creativecommons.org/licenses/by-nc-sa/4.0/)** license. The summary below is for convenience only — the legally binding terms are in the [`LICENSE`](./LICENSE) file.

### What you CAN do:
- 🌍 **Share & Adapt:** You are free to download, edit, re-texture, or remix these source files and publish community variants (e.g. Wingman versions, night/winter themes, retake setups, or optimization mods), including on the Steam Workshop.

### What you MUST do:
- 👤 **Attribution:** Give appropriate credit (see [How to Credit Me](#-how-to-credit-me)), provide a link to the license, and indicate that you made changes.
- 🔄 **ShareAlike:** If you remix, transform, or build upon these maps, you must distribute your version under the same license (CC BY-NC-SA 4.0 or a later version of it).

### What you CANNOT do:
- 💰 **NonCommercial:** You may not use these materials for purposes primarily intended for commercial advantage or monetary compensation.

In practice, I consider the following to be commercial use, and they require my prior written permission:
- selling the map or its source files, or putting them behind a paywall,
- using the map as a paid / premium feature of a server (e.g. VIP-only access),
- using the map in events or productions where money is made from it (e.g. paid-entry tournaments, sponsored content).

Playing the map on regular community servers, streaming it, or making videos about it is totally fine. **If you are unsure, just ask** by opening a [Permission request](https://github.com/KDany/cs2-maps/issues/new?template=permission_request.yml).

### Third-party content
The license only covers my own work. Stock Counter-Strike 2 materials, models, prefabs and other assets referenced by these maps belong to **Valve Corporation** and are subject to Valve's own terms. This project is not affiliated with or endorsed by Valve.

## 📝 How to Credit Me

If you use assets from this repository or publish a modified community version of any map found here (e.g. on the Steam Workshop), please copy and paste the following line into your description:

> *Based on the original CS2 map by KDany — https://github.com/KDany/cs2-maps — licensed under CC BY-NC-SA 4.0. Changes were made.*

## 🐞 Bug Reports & Feedback

Found a bug or have feedback about one of my **released maps** (getting stuck, clipping, missing textures, visibility, balance, etc.)? Please report it in my dedicated issue tracker:

👉 **[KDany/steam-workshop — Issue Tracker](https://github.com/KDany/steam-workshop/issues/new/choose)**

This also includes problems with the source files themselves (e.g. a map does not open in Hammer, or source assets are missing). All fixes to the original maps are made by me, based on the reports in the tracker.

## 🚫 No Pull Requests

This repository is a download archive, not a collaborative project. **Pull requests are not accepted** and will be closed without review. If you want to change a map, download or fork it and maintain your own version — that is exactly what the license allows. See [CONTRIBUTING.md](./CONTRIBUTING.md).

## 📬 Contact

- Map bugs & feedback: [KDany/steam-workshop](https://github.com/KDany/steam-workshop/issues/new/choose)
- Permission requests (e.g. commercial use): [Permission request](https://github.com/KDany/cs2-maps/issues/new?template=permission_request.yml)
- Getting your variant listed: [Community variant listing](https://github.com/KDany/cs2-maps/issues/new?template=variant_listing.yml)
- Steam: [KDany](https://steamcommunity.com/profiles/76561198011807358)

Thank you for respecting the hundreds of hours that went into these projects! Good luck with your mapping!
