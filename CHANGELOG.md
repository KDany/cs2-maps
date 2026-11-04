# Changelog

All notable changes to the maps in this repository are documented here, per map.

Versioning:
- Every Steam Workshop update gets a version number (`vMAJOR.MINOR`), written at the start of the Workshop change note.
- The source state of each release is marked with a Git tag named `<map_name>-v<version>` (e.g. `de_dust2_long-v1.1`).
- The compiled `.vpk` of each release is attached to the matching [GitHub Release](https://github.com/KDany/cs2-maps/releases), so older versions can be restored if needed.

Version numbers:
- **MAJOR** — layout or gameplay changes (e.g. new routes, moved spawns or bombsites).
- **MINOR** — fixes, visual changes and optimizations without gameplay impact.

---

## de_dust2_long

Steam Workshop: [Dust II Long](https://steamcommunity.com/sharedfiles/filedetails/?id=3730804227)

### [Unreleased] — v1.1 (Optimization patch)
- First raw source files added to this repository.
- Removed unused decompiled data (world collision, compiled world data, unused models and template files) — download size reduced from ~154 MB to ~101 MB, no gameplay changes.
- Added a minimap (radar), generated automatically on build — a more detailed version is planned.

### v1.0 — 2026-05-22
- Initial Steam Workshop release.
