# VPK Industries

A fictional company behind the hidden easter egg rooms of my maps. Its machines stand in places players never see in a normal game; they can only be reached with `noclip`. The company and its machines are not tied to one map: the same names, screens and story are reused on every map that has such a room.

For the same content written as the company's own promo brochure, see [vpk-industries-inlore.md](./vpk-industries-inlore.md).

```
VPK INDUSTRIES                         "We own the world. Literally."
(Virtual Perfection Kernel Industries)
formerly BSP Industries (Binary Space Partitioning Industries)
│
└─ NONVIS DIVISION                     "Never rendered. Always running."
   │
   ├─ WEATHER PROGRAM (KD-WX)
   │  ├─ KD-WX-001  A.T.M.O.S.         "Nature is a setting."
   │  ├─ KD-WX-002  F.O.R.E.C.A.S.T.   "Forecast accuracy: 100%. We make it!"
   │  └─ KD-WX-003  S.T.R.A.T.O.S.     "Do not kick the server. Again."
   │
   └─ MAP CONTROL PROGRAM (KD-MCS)
      └─ KD-MCS-001 V.I.G.I.L.         "Everything is logged. Everything!"
```

## The company and the division

| | Name | Slogan | Meaning |
| :--- | :--- | :--- | :--- |
| **Company** | **VPK Industries** (full name: *Virtual Perfection Kernel Industries*) | *"We own the world. Literally."* | Creates and owns worlds, and claims to make them perfect. *Virtual*: its worlds are maps. *Kernel*: the core everything is controlled from. The short name is the map package format of Source 2 (`.vpk`). |
| **Division** | **Nonvis Division** | *"Never rendered. Always running."* | Runs everything from the background. Its machines are always in a part of the map that is never drawn for players; "vis" is the visibility calculation of the engine. |

## The machines

| Code | Name | Stands for | Controls | Slogan |
| :--- | :--- | :--- | :--- | :--- |
| **KD-WX-001** | **A.T.M.O.S.** | *Atmospheric Tuning & Mood Override Station* | the map's environment entities: `light_environment`, `env_sky`, `env_cubemap_fog`, `env_wind`, `post_processing_volume`, `info_map_parameters` | *"Nature is a setting."* |
| **KD-WX-002** | **F.O.R.E.C.A.S.T.** | *Fully Overridden Random Event & Climate Activation Scheduling Terminal* | the weather state rolled every round (rain 90% / storm 10%; clear weather was lost in Incident Report #003) and the lightning | *"Forecast accuracy: 100%. We make it!"* |
| **KD-WX-003** | **S.T.R.A.T.O.S.** | *Seasonal Transmission & Regional Atmosphere Takeover System* | the central server cabinet that "broadcasts" the seasons (summer, night, later winter). On its roof: 2 antennas and 2 satellite dishes, purely for looks (in the lore: *"classified"*). On its side: the **emitter module**, where a smoke particle shows the KD-PX being released. | *"Do not kick the server. Again."* |
| **KD-MCS-001** | **V.I.G.I.L.** | *Vandalism Incident & General Infrastructure Log* | monitors the interactive parts of the map (e.g. street lights that can be shot out, later doors, alarms, ...) | *"Everything is logged. Everything!"* |

## Naming rules

- **Machine code:** `KD-<series>-<three-digit number>`. "KD" is the signature of the designer, KDany.
  - `WX`: Weather Program
  - `MCS`: Map Control Program (Map Control System)
  - `PX`: Particle eXperiments, the Kdanium compounds (see below)
  - New series can be added any time, e.g. `KD-SND-001` for sound.
- **Machine name:** an acronym written with dots (e.g. `A.T.M.O.S.`), with an English long form.
- **Map-independent:** screens and texts never name a specific map; only the content (active profile, monitored assets) changes.

## Kdanium and the KD-PX series

Every particle effect of VPK Industries is made of **Kdanium**, a synthetic element discovered by KDany.

| | |
| :--- | :--- |
| **Element** | Kdanium |
| **Symbol** | `Kd` |
| **Atomic number** | `404` (element not found: officially it does not exist) |
| **Properties** | Discovered by the Chief Scientist, Daniel K. With the right catalyst it can be formed into rain, snow, fire, smoke or anything else. It was discovered and first used in NONVIS-001 "Oasis"; where it is mass-produced today is classified. Nonvis facilities, Oasis included, only receive KD-PX shipments. |

Each particle effect is a numbered Kdanium compound of the **KD-PX** series (*Particle eXperiment*), like the machines of the other series.

| Code | File | Product | Compound |
| :--- | :--- | :--- | :--- |
| **KD-PX-001** | `kdpx_dyna_rain.vpcf` | DynaRain™ | **Kd₂O**, synthetic precipitation agent |
| **KD-PX-002** | `kdpx_dyna_rain_splash.vpcf` | DynaRain™ Splash | impact-reactive Kd₂O |
| **KD-PX-003** | `kdpx_fire.vpcf` | | **Kdanium oxide**, strongly exothermic |
| **KD-PX-004** | `kdpx_cigg_smoke.vpcf` | | aerosolized **Kd ash**, not to be inhaled |
| **KD-PX-005** | `kdpx_dyna_snow.vpcf` | DynaSnow™ | **Kd₂O(s)**, "Kdanium Crystal": the Kd₂O of DynaRain™ in its crystalline phase |
| KD-PX-006 *(planned)* | `kdpx_snow_ground.vpcf` | | **Kd frost**, Kd₂O deposited on the ground |
| KD-PX-007 *(planned)* | `kdpx_blizzard.vpcf` | | supersaturated **Kd₂O(s) aerosol**, the winter counterpart of a storm |

**Expanded catalogue.** The rest of the series is lore only for now; the file names are the planned names if such a particle is ever made.

| Code | Planned file | Product | Compound | Description | Side effect |
| :--- | :--- | :--- | :--- | :--- | :--- |
| **KD-PX-000** | | **Prima Materia** | pure, undiluted Kdanium | The original formula; fuel of the Rainmaker Mk I. Never released, for obvious reasons. | see Incident Report #001 |
| **KD-PX-008** | `kdpx_dyna_dust.vpcf` | **DynaDust™** | Kd silicate | Sandstorm and drifting dust; the official air of Dust II. | sand in places sand never reached |
| **KD-PX-009** | `kdpx_golden_motes.vpcf` | **Golden Motes™** | Kd glitter | Dust motes floating in sunbeams. *"Makes every corner look expensive."* | the map suddenly looks too nice |
| **KD-PX-010** | `kdpx_vent_vapor.vpcf` | **Vent Vapor™** | Kd steam | Steam from vents and drains. | mild humidity in your pockets |
| **KD-PX-011** | `kdpx_volumetric_fog.vpcf` | **Volumetric Mystery™** | Kd fog | Distant fog that anything can come out of. | enemies always come from where you are not looking |
| **KD-PX-012** | `kdpx_smoke_screen.vpcf` | **SmokeScreen Pro™** | Kd aerosol, 18 s | The content of a smoke grenade. *"One-way smokes sold separately."* | your teammate always throws it in the wrong place |
| **KD-PX-013** | `kdpx_flash.vpcf` | **Flash Concentrate™** | concentrated Kd photons | The filling of a flashbang. | only works on teammates |
| **KD-PX-014** | `kdpx_molotov.vpcf` | **Molotov Lite™** | Kdanium oxide gel | A burning patch on the ground; extinguished by smoke, by contract. | the fire always spreads exactly onto your step |
| **KD-PX-015** | `kdpx_impact_dust.vpcf` | **Impact Dust™** | Kd debris | Dust and sparks of bullet impacts. *"Every miss a little more beautiful."* | |
| **KD-PX-016** | `kdpx_stattrak_residue.vpcf` | **StatTrak™ Residue** | Kd counter powder | Starts counting on contact. What it counts is not documented. | the number only goes up |
| **KD-PX-017** | `kdpx_rankup_sparkles.vpcf` | **Rank-Up Sparkles™** | festive Kd confetti | Sparkles on a rank up. | currently out of stock |
| **KD-PX-018** | `kdpx_defuse_confetti.vpcf` | **Defuse Confetti™** | Kd paper | Confetti when the bomb is defused. Or not. | starts 10 seconds late |
| **KD-PX-064** | | **Tick Fog™** | time-shifted Kd | *"Not our product. Do not ask."* Somehow your shot always lands one tick later. | see the "Missed that shot?" poster |
| **KD-PX-128** | | **Phantom Footstep Aerosol** | audible Kd | Sprays footsteps into the air. Officially does not exist. | footsteps that are not there |
| **KD-PX-404** | `kdpx_missing_texture.vpcf` | **Missing Texture Gas** | pink and black checkerboard aerosol | Hammer's missing texture in gaseous form. *"Not found."* | everything turns pink and black |

The classified products have programmer numbers instead of the next free code: 64 and 128 for the tick rates, 404 for "not found". The company denies any connection between KD-PX-064 / KD-PX-128 and the side effects that look exactly like them.

- **File names:** every custom particle starts with `kdpx_`, so searching for `kdpx` in the Asset Browser lists all of them. The compound number is only used in the lore and on signs, not in the file name.
- **Product names:** a product name (e.g. *DynaRain™*) is optional; *Dyna* marks particles whose size and rate are set from Hammer (see the [rain particle doc](./rain-dynamic-particle.md)).
- The current rain particles are still named `rain_dynamic.vpcf` and `rain_ground_dynamic.vpcf`; the `kdpx_` names above are the planned names.

**Snow, KD-PX-005:** rain and snow are the same compound in two phases: Kd₂O as a liquid is DynaRain™, Kd₂O(s) is DynaSnow™. The winter module of S.T.R.A.T.O.S. simply cools it down. Every flake is serial-numbered, because VPK Industries does not leave it to chance that no two are alike. Storage: "below 0 °K", according to the label on the tank; the unit is wrong on purpose, as nothing can be below absolute zero.

**Side effects.** VPK Industries advertises Kdanium as the most perfect element ever made. The warnings are only ever found in footnotes, fine print and the occasional asterisk:

| Exposure | Known side effect |
| :--- | :--- |
| Skin contact | Irritation, itching, a faint teal glow that lasts until the next round |
| Inhalation (fumes, smoke, KD-PX-004) | Headache, slowed reflexes (*"up to 20 ms; VPK Industries is not responsible for lost aim duels"*) |
| Prolonged exposure to DynaRain™ | Hearing footsteps that are not there |
| Licking DynaSnow™ | Brain freeze, the sudden urge to buy an AWP on an eco round |
| Any exposure | Crosshair slowly drifting towards the floor, uncontrollable team flashes, deranking |
| Long-term exposure | The urge to rush B on maps without a B site; seeing rain indoors; smelling of wet sand |

The tone stays the same everywhere: the product is perfect, the side effects are *"rare, mild and entirely your fault"*.

For the full, in-universe scientific paper on Kdanium (discovery, chemistry, mass production and its use in S.T.R.A.T.O.S.), see [kdanium-paper-inlore.md](./kdanium-paper-inlore.md).

## Backstory

- The company was founded in the GoldSrc era as **BSP Industries** (*Binary Space Partitioning Industries*), named after the map format of the GoldSrc and Source engines (`.bsp`). It partitioned space and built the first worlds.
- In the Source 2 era it operates as **VPK Industries** (*Virtual Perfection Kernel Industries*), after the new map format (`.vpk`). It still owns the world, now in the pursuit of perfection. The Nonvis Division runs everything from where no player ever looks.
- The weather machine started as the **Rainmaker**. The first prototype, the **Rainmaker Mk I**, exploded during the development of the *Aftershock* update (`de_dust2_long` v1.2, the update about explosions). It never saw daylight: no player has ever seen it working, and all that is left of it is *Incident Report #001*.
- The rebuilt **Rainmaker Mk II** was later extended to control every season, not only rain, and was renamed **KD-WX-003 S.T.R.A.T.O.S.** Its cabinet still carries the old name.
- The Rainmaker Mk I was, officially, not perfect.
- The winter module of S.T.R.A.T.O.S. is not installed yet: it is still waiting for the Kd₂O crystallization license. When it arrives, the F.O.R.E.C.A.S.T. will roll snow and blizzard instead of rain and storm.

## Staff

Every employee of VPK Industries is called **Daniel K.** Their employee ID is `EMP-0001`, and none of their badges has a photo. Nobody in the company mentions this.

| Name | Position | Note |
| :--- | :--- | :--- |
| Daniel K. | Chief Executive Officer | Visionary. Rarely seen. |
| Daniel K. | Chief Scientist | Discovered Kdanium. Named it by accident. |
| Daniel K. | Head of the Weather Program | Responsible for the rain settings of F.O.R.E.C.A.S.T. |
| Daniel K. | HR Manager | Has conducted exactly one job interview. |
| Daniel K. | Janitor | Put the note on the S.T.R.A.T.O.S. server. |

- **Employee of the Month:** Daniel K., every month.
- **Shift schedule:** every position is staffed around the clock; a shift handover takes zero seconds.
- **Job openings:** none. The company is fully staffed.

## Facilities

Every hidden room belongs to a numbered **Nonvis facility**. A facility can be deployed on several maps of the same family. No facility produces Kdanium: the production site is classified, and the facilities only receive KD-PX shipments.

| Code | Code name | Status |
| :--- | :--- | :--- |
| **NONVIS-000** | "HQ" | Location unknown. Probably the void. |
| **NONVIS-001** | "Oasis" | Operational. The hidden rooms of the Dust II variants (`de_dust2_long`, and later ones). The name: the facility that brings rain to the desert. Kdanium was discovered and first used here; today Oasis only receives KD-PX shipments like every other facility. |
| NONVIS-002+ | | Under construction, or already there and you do not know about it. |

## Premium content

VPK Industries sells its weather. Motto: *"The darkness is free. The light costs extra."*

| Product | Description |
| :--- | :--- |
| **Weather Pass™ – Season 1: Nightfall** | A season pass for the weather. *Season 2: Winter* is available for pre-order. |
| **Clear Sky Unlock** | 4.99: brings back clear weather. Not available, even after purchase (see Incident Report #003). |
| **Raindrop Pack +10%** | 10% denser DynaRain™. *"More wet for your money."* |
| **Lightning Loot Box™** | Lightning in a random colour. 0.01% chance of gold. |
| **Light Subscription™** | Street lights are paid monthly. When one is shot out, the repair is billed to the vandal, based on the V.I.G.I.L. log. |
| **Thunder+** | Ad-free thunder. |

## Incident reports

| No. | Incident | Result |
| :--- | :--- | :--- |
| **#001** | The Rainmaker Mk I exploded during Project Aftershock. | The Mk I was decommissioned; the Mk II was built. |
| **#002** | Someone kicked the S.T.R.A.T.O.S. server. | The janitor put a note on it: *"DO NOT KICK THE SERVER. AGAIN."* |
| **#003** | Coffee was spilled on F.O.R.E.C.A.S.T. | The clear weather setting was lost. Since then the roll is rain 90% / storm 10%. |

## Other details

- **Company values:** *"Perfection. Control. Deniability."*
- **Customer support:** phone number `404`.
- **Merchandise:** the VPK Industries umbrella, sold separately. *"Because we know what's coming."*
- **Patents:** *"Patent pending: Wet."*

## Branding

| Logo | Description | Files ([`docs/images/vpk-industries/`](./images/vpk-industries/)) |
| :--- | :--- | :--- |
| **VPK Industries** | A square partitioned like a BSP tree; the first two splits draw a yellow **V**. A nod to the company's BSP Industries past. | `vpk-industries_logo_2048x640.png` (with name and slogan), `vpk-industries_logo_icon_1024.png` (transparent), `vpk-industries_logo_icon_navy_1024.png` |
| **Nonvis Division** | A wireframe cube with its hidden edges dashed ("never rendered") and an eye in the middle (it sees everything). | `nonvis-division_logo_2048x640.png`, `nonvis-division_logo_icon_1024.png`, `nonvis-division_logo_icon_navy_1024.png` |

| Colour | Hex | Use |
| :--- | :--- | :--- |
| Nonvis Navy | `#18223A` | background of logos and signs |
| Enamel White | `#ECEEF0` | text, logo lines |
| Hazard Yellow | `#E0B030` | the V, the eye, highlights, warnings |
| Signal Red | `#B2221E` | "CLASSIFIED", incidents |
| Terminal Teal | `#96D4C7` | screens, the Nonvis slogan |

- **Fonts:** Bebas Neue for names and titles, JetBrains Mono for technical text.
- **Voice:** short, confident sentences, ™ on every product, friendly menace (*"Thank you for not kicking the server."*).

Posters (1024×1536) for the walls of the rooms, same folder:

| File | Poster |
| :--- | :--- |
| `poster_rain-is-a-privilege_1024x1536.png` | *"Rain is a privilege."*: a DynaRain™ drop of Kd₂O, Weather Pass™ ad |
| `poster_report-all-vandalism_1024x1536.png` | *"Report all vandalism. V.I.G.I.L. already did."*, with the Nonvis eye |
| `poster_employee-of-the-month_1024x1536.png` | Employee of the Month: Daniel K., "photo unavailable", every month |
| `poster_the-darkness-is-free_1024x1536.png` | *"The darkness is free. The light costs extra."*: Light Subscription™, a street lamp with a price tag |
| `poster_kdanium_1024x1536.png` | *"The element of perfection."*: the Kd 404 periodic table tile |
| `poster_days-without-an-incident_1024x1536.png` | Days without an incident: **0**, the three incident reports, *"Safety is our number two priority."* |
| `poster_do-not-kick-the-server_1024x1536.png` | *"Do not kick the server. Again."*: the S.T.R.A.T.O.S. cabinet and a crossed-out boot (Incident Report #002) |
| `poster_we-are-not-hiring_1024x1536.png` | *"Join the Nonvis Division"* with a "POSITION FILLED" stamp; every position: Daniel K. |
| `poster_clear-sky-unlock_1024x1536.png` | *"Miss the sun?"*: Clear Sky Unlock for 4.99, locked sun, "UNAVAILABLE" stamp |
| `poster_dynasnow-coming-soon_1024x1536.png` | DynaSnow™ coming soon: flake No. 000 000 001, *"Store below 0 °K… wait, no."*, *"Do not lick."* |
| `poster_incident-report-001_1024x1536.png` | Incident Report #001 as a redacted paper document with a "CLASSIFIED" stamp |
| `poster_lightning-loot-box_1024x1536.png` | *"Feeling lucky?"*: Lightning Loot Box™, 0.01% chance of gold |
| `poster_wash-your-hands_1024x1536.png` | *"Wash your hands."*: a tap running Kd₂O, soap bubbles; Kdanium residue may cause local rain, mild glowing, unscheduled weather |
| `poster_playable-area-this-way_1024x1536.png` | Green wayfinding sign: playable area →, *"You are here: nowhere"*, route: noclip |
| `poster_thunder-plus_1024x1536.png` | *"Thunder+. Now ad-free."* |
| `poster_kdanium-safety-data-sheet_1024x1536.png` | Kdanium Safety Data Sheet as a paper document: hazard pictograms, *"Hazards: none.\*"*, first aid (*"Ingestion: you were told."*), disposal: noclip it into the void, "APPROVED" stamp |
| `poster_missed-that-shot_1024x1536.png` | *"Missed that shot? It wasn't your fault. It wasn't ours either.\*"*: the crosshair 20 ms behind the target; the fine print denies any link to KD-PX products |
| `poster_feeling-the-urge_1024x1536.png` | *"Feeling the urge?"*: the AWP in the buy menu for $4,750 with $1,400 in the bank, *"Insufficient funds. Buy anyway?"*; buying it on an eco round *"is a completely normal decision.\*"*, *"not related to DynaSnow™ consumption. Probably."* |

Nonvis Division posters (with the Nonvis logo in the footer):

| File | Poster |
| :--- | :--- |
| `poster_nonvis_this-area-does-not-exist_1024x1536.png` | *"This area does not exist."*: a fully dashed, "not rendered" cube; *"If you can see it, something went wrong."* |
| `poster_nonvis_clearance-levels_1024x1536.png` | Clearance levels 0–4: player, spectator, noclip, Hammer, Daniel K. *"Your current level: 2. Please leave."* |
| `poster_nonvis_never-rendered_1024x1536.png` | *"Never rendered. Always running."*: a wireframe mesh sphere, *"We do our best work where you never look."* |

## Texts used in the rooms

| Where | Text |
| :--- | :--- |
| Screen header | `VPK INDUSTRIES · NONVIS DIVISION`, with the program name below it |
| Warning | `CLASSIFIED · NONVIS CLEARANCE REQUIRED` |
| Machine plate | `MODEL KD-WX-003 · DESIGNED BY KDANY · OPERATED BY NONVIS DIVISION` |
| S.T.R.A.T.O.S. screen | `FORMERLY "RAINMAKER Mk II"` and `Mk I - DECOMMISSIONED (INCIDENT REPORT #001)` |
| Wall (optional) | `EST. IN THE GOLDSRC ERA AS BSP INDUSTRIES` |
| Barrel / tank | `KD-PX-001 · Kd₂O · SYNTHETIC PRECIPITATION AGENT · DO NOT DRINK` |
| Cooled tank | `KD-PX-005 · Kd₂O(s) · CRYSTALLINE PHASE · KEEP BELOW 0 °K… WAIT, NO.` (the wrong unit is on purpose) |
| Periodic table tile | a large **Kd**, `404` in the corner, *Kdanium* below |
| Warning sign | `KDANIUM STORAGE · CONTAINS UNSTABLE WEATHER` |
| Door sign | `NONVIS-001 FACILITY · CODE NAME: OASIS · SECTOR: DUST II · AUTHORIZED PERSONNEL ONLY · PLEASE RETURN TO THE PLAYABLE AREA!`, with both logos (one number per facility) |

## Screens

Screen textures (1024×512, glowing monitors) are in [`docs/images/nonvis-division/`](./images/nonvis-division/):

| File | Machine |
| :--- | :--- |
| `kd-wx-001_atmos_1024x512.png` | A.T.M.O.S. |
| `kd-wx-002_forecast_1024x512.png` | F.O.R.E.C.A.S.T. |
| `kd-wx-003_stratos_1024x512.png` | S.T.R.A.T.O.S. |
| `kd-mcs-001_vigil_1024x512.png` | V.I.G.I.L., all assets online |
| `kd-mcs-001_vigil_incident_1024x512.png` | V.I.G.I.L., one incident |
| `kd-mcs-001_vigil_frame_1024x512.png` | V.I.G.I.L., empty frame for `point_worldtext` lines |

Machine plates (1024×512, brushed metal, not glowing) for the cabinets, same folder:

| File | Machine | Detail |
| :--- | :--- | :--- |
| `kd-wx-001_atmos_plate_1024x512.png` | A.T.M.O.S. | engraved motto, uplink to S.T.R.A.T.O.S. |
| `kd-wx-002_forecast_plate_1024x512.png` | F.O.R.E.C.A.S.T. | engraved motto, uplink to S.T.R.A.T.O.S. |
| `kd-wx-003_stratos_plate_1024x512.png` | S.T.R.A.T.O.S. | scratched-off old name, handwritten sticky note "DO NOT KICK THE SERVER. AGAIN." |
| `kd-mcs-001_vigil_plate_1024x512.png` | V.I.G.I.L. | engraved motto, standalone unit |

Facility door sign (1024×512, enamel sign with hazard border), same folder: `nonvis-001_door_sign_1024x512.png` for NONVIS-001 "Oasis".

KD-PX shipment crates, same folder:
- `kdpx_shipping_label_1024x768.png`: the waybill. From: *[CLASSIFIED]*, to: NONVIS-001 Oasis, contents (DynaRain™ ×22, Splash ×22, smoke), weight *"[?] (not found)"*, carrier *[REDACTED]*, signed by Daniel K., handling boxes (*"Keep dry (ironic)"*, *"Do not lick"*, *"Keep below 0 °K… wait, no."*), barcode `KDPX-404-0001-OASIS`, *"Priority: weather"*.
- `kdpx_pictogram_<name>_512.png` (transparent, for decals): KD-PX hazard pictograms `kdanium`, `weather` (*contains weather*), `health-hazard` (*may cause deranking*), `radioactive` (*highly radioactive*), `cryogenic` (*keep below 0 °K*), `explosive`.

Emitter warning sign (1024×1024), same folder: `kd-wx-003_emitter_warning_1024x1024.png`, for the side emitter module of S.T.R.A.T.O.S.: *"KD-PX emitter · active emission"*, *"Do not inhale the weather."*, *"Do not block the outlet with your hand, your face or your coffee."*, *"The smoke is not a malfunction."*, minimum distance 2 m.

To use a screen or plate on a map, copy the image into that map's addon (e.g. `<map_name>/materials/...`) and make a material from it. Turn on **Self Illum** for the screens so they glow in a dark room; the plates do not need it.
