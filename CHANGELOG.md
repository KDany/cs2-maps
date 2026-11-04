# Changelog

All notable changes to the maps in this repository are documented here, per map.

Versioning:
- Every Steam Workshop update gets a version number (`vMAJOR.MINOR`), written at the start of the Workshop change note.
- Each map has two Workshop items:
  - **Release** — e.g. *Dust II Long*, map name `de_dust2_long`, versions like `v1.1`.
  - **Playtest** — e.g. *Dust II Long (Playtest)*, map name `de_dust2_long_dev`, pre-release builds of the next version like `v1.1-beta.1`, `v1.1-beta.2`.
- A version number is only "used up" by a release: all playtest betas of a version lead to the same release version (e.g. `v1.1-beta.1` → `v1.1-beta.2` → `v1.1`).
- The source state of every upload is marked with a Git tag:
  - release: `<map_name>-v<version>` (e.g. `de_dust2_long-v1.1`),
  - playtest: `<map_name>_dev-v<version>-beta.<n>` (e.g. `de_dust2_long_dev-v1.1-beta.2`).
- The repository only contains the release map files (e.g. `de_dust2_long/`). The playtest build is made from the same source, with the `.vmap` saved under the `_dev` map name in a separate local addon (see `tools/sync-dev-addon.ps1`).
- The compiled `.vpk` of each release is attached to the matching [GitHub Release](https://github.com/KDany/cs2-maps/releases), so older versions can be restored if needed.

Version numbers:
- **MAJOR** — layout or gameplay changes (e.g. new routes, moved spawns or bombsites).
- **MINOR** — fixes, visual changes and optimizations without gameplay impact.

---

## de_dust2_long

Steam Workshop: [Dust II Long](https://steamcommunity.com/sharedfiles/filedetails/?id=3730804227) · Playtest: [Dust II Long (Playtest)](https://steamcommunity.com/sharedfiles/filedetails/?id=3730701113)

### [Unreleased] — v1.1 (Optimization patch)
In playtest: `v1.1-beta.1`

- First raw source files added to this repository.
- Removed unused decompiled data (world collision, compiled world data, unused models and template files) — download size reduced from ~154 MB to ~101 MB, no gameplay changes.
- Added a minimap (radar), generated automatically on build — a more detailed version is planned.

### v1.0 — 2026-05-22
- Initial Steam Workshop release.
