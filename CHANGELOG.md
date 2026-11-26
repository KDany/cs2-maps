# Changelog

All notable changes to the maps in this repository are documented here, per map.

Versioning:
- Every Steam Workshop update gets a version number (`vMAJOR.MINOR`, or `vMAJOR.MINOR.PATCH` for a patch), written at the start of the Workshop change note.
- Each map has a **release** Workshop item, e.g. *Dust II Long*, map name `de_dust2_long`, versions like `v1.1`.
- New versions are playtested privately before release, built under the same map name. Playtest builds may be numbered like `v1.1-beta.1`, `v1.1-beta.2`; they are not part of this repository and are not tagged.
- A version number is only "used up" by a release: all playtest builds of a version lead to the same release version (e.g. `v1.1-beta.1` → `v1.1-beta.2` → `v1.1`).
- The repository only contains the release map files (e.g. `de_dust2_long/`). Work in progress is done on a branch and merged into `master` when the update is released on the Workshop.
- Only releases are tagged in Git: `<map_name>-v<version>` (e.g. `de_dust2_long-v1.1`, `de_dust2_long-v1.3.1`), on the commit the release build was made from.
- The compiled `.vpk` of each release is attached to the matching [GitHub Release](https://github.com/KDany/cs2-maps/releases), so older versions can be restored if needed.

Version numbers:
- **MAJOR** — changes to the map's design that affect how it is played: layout, routes, spawns or bombsites of the existing game modes.
- **MINOR** — new game modes or features, adopting CS2 game updates (e.g. the new bomb explosion), fixes, visual changes and optimizations. Named updates (e.g. *Nightfall*) always get a new MINOR.
- **PATCH** — a small, unnamed follow-up update with fixes only, no new features (e.g. `v1.3.1` after `v1.3`). Left out when it is 0: `v1.3`, not `v1.3.0`.
- After `v1.9` comes `v1.10`, and after `v1.3.9` comes `v1.3.10` — the parts are separate numbers, not decimals.

---

## de_dust2_long

Steam Workshop: [Dust II Long](https://steamcommunity.com/sharedfiles/filedetails/?id=3730804227)

### v1.3 — 2026-11-26 (Nightfall)
Source: tag [`de_dust2_long-v1.3`](https://github.com/KDany/cs2-maps/releases/tag/de_dust2_long-v1.3).

- Added the **night variant**, `de_dust2_long_night`, published in the same Workshop item. Both maps are built from the same source: everything that differs between day and night lives in an environment prefab (`maps/prefabs/env_summer.vmap`, `maps/prefabs/env_night.vmap`), and `de_dust2_long_night.vmap` is generated from the main map before each release (see the README).
  - Rainy night under a cloudy, moonlit sky: dynamic rain with splashes ([rain particle doc](./docs/rain-dynamic-particle.md)) and wet surfaces.
  - Lightning and thunder at random intervals ([lightning doc](./docs/lightning.md)).
  - Rain sounds that follow the player: open rain outside, muffled rain under cover, dripping water in the tunnels.
  - Street lamps and lanterns light up the map, and most of them can be shot out.
  - Retakes spawns and the radar for the night map (`game_files/maps/de_dust2_long_night_retake.txt`, `game_files/resource/overviews/de_dust2_long_night.txt`).
- Moved the day environment (sun, sky, fog, wind, map parameters, ground and background effects) into the `env_summer` prefab.
- Added loading screen map icons for both maps, based on the official Dust II icon (`panorama/images/map_icons/`).
- Reduced the bomb damage radius from 700 to 500.
- Fixed a visible gap under the new door that closes off Short.

### v1.2 — 2026-11-06 (Aftershock)
Source: tag [`de_dust2_long-v1.2`](https://github.com/KDany/cs2-maps/releases/tag/de_dust2_long-v1.2).

- Added the **Retakes** game mode: custom CT and T spawns and bomb plant positions for bombsite A (`game_files/maps/de_dust2_long_retake.txt`), and custom Retakes boundaries for bombsite A.
- Added the new CS2 bomb explosion: the blast now spreads as a shockwave that is blocked by walls, and the blast preview under the health bar works (navigation mesh added) ([steam-workshop#9](https://github.com/KDany/steam-workshop/issues/9)).
- Removed the leftover bombsite B of the original Dust II: rounds no longer pick bombsite B in Retakes, and the "B" marker is gone from the radar.
- Removed an invisible leftover mesh face that players could collide with.

### v1.1 — 2026-11-05 (Optimization & bugfixes)
Playtested as `v1.1-beta.1` – `v1.1-beta.3`. Source: tag [`de_dust2_long-v1.1`](https://github.com/KDany/cs2-maps/releases/tag/de_dust2_long-v1.1).

- First raw source files added to this repository.
- Removed unused decompiled data (world collision, compiled world data, unused models and template files) — download size reduced from ~154 MB to ~101 MB, no gameplay changes.
- Fixed the missing minimap: added a radar based on the official Dust II radar, showing only the remaining part of the map (closed off cuts, T spawn zone at Long doors) ([steam-workshop#2](https://github.com/KDany/steam-workshop/issues/2)).
- Fixed too dark player and viewmodel lighting at A Short: replaced a broken light probe volume and removed two duplicate ones ([steam-workshop#3](https://github.com/KDany/steam-workshop/issues/3)).
- Fixed missing collision on the door in the new wall at Short — thrown weapons and grenades no longer fall through it ([steam-workshop#4](https://github.com/KDany/steam-workshop/issues/4)).

### v1.0 — 2026-05-22
- Initial Steam Workshop release.
