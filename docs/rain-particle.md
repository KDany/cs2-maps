# Rain particle (`rain_medium.vpcf`)

A single rain particle that is reused for every rain area of a map. Each `info_particle_system` in Hammer tells the particle **how large its area is** and **how many drops it emits**, so all areas share one `.vpcf` file and the rain has the same density everywhere.

- File: `particles/rain_medium.vpcf` (in the addon's content folder)
- Used by: the night environment prefab (`maps/prefabs/env_night.vmap`)
- Inputs: control point **1**, set per entity with **Data CP** / **Data CP Value**

## How it works

| Data CP Value | Meaning |
| :--- | :--- |
| X | half the width of the rain area (along the red / X axis) |
| Y | half the length of the rain area (along the green / Y axis) |
| Z | emission rate (drops per second) |

- The drops are created on a horizontal rectangle of `2·X × 2·Y` units, centred on the entity, **at the entity's height**.
- They fall until they hit the ground or a roof (*Collision via traces*), so the height of the area does not need to be set: place the entity at the **top** of the area.
- The emission rate comes from the Z value, so a small and a large area get the same density when the rate is scaled with the area (see [Emission rate](#emission-rate)).

## Particle setup (Particle Editor)

### Base Properties
| Property | Value | Why |
| :--- | :--- | :--- |
| max particles | `1000` | Upper limit of live drops per system. With the default `250` the large areas hit the limit and look sparser than the small ones. |

### Pre Emission Operator: Set control point positions (preview only)
Gives control point 1 a value in the Particle Editor, where no Hammer entity sets it. **Disabled in the game**, so it never overrides the values from Hammer.

| Property | Value |
| :--- | :--- |
| first control point number | `1` |
| first control point location | `152 224 117` (any test size and rate) |
| second / third / fourth control point number | `5`, `6`, `7` (unused points) |
| control point to offset positions | `0` |
| set positions in world space | off |
| **operator enabled in tools or game** | **Only Enabled in Tools** |

### Emitter: Emit continuously
| Property | Value |
| :--- | :--- |
| emission rate | type **CP Component**, CP# `1`, component `.Z`, Multiply By `1` |

### Initializer: Position within box random
| Property | Value |
| :--- | :--- |
| min | type **Control Point Value**, CP# `1`, Scale `-1 -1 0` |
| max | type **Control Point Value**, CP# `1`, Scale `1 1 0` |
| control point number | `0` (the box is centred on the entity) |

The Z scale is `0`, so the drops are created at the entity's height and the Z value of control point 1 is free for the emission rate.

### Initializer: Position modify offset random (preview only)
Lifts the drops 512 units above the grid in the Particle Editor, otherwise they are created on the ground and the collision removes them immediately. **Disabled in the game**: there the entity is already at the top of the area.

| Property | Value |
| :--- | :--- |
| offset min / max | `0 0 512` |
| offset in local space | off |
| **operator enabled in tools or game** | **Only Enabled in Tools** |

It must be **below** *Position within box random* (initializers run from top to bottom).

### Other functions
Kept from the original rain particle: *Velocity random*, *Movement basic*, *Lifespan decay*, *Alpha decay for tracers*, *Collision via traces* (stops the drops on the ground and on roofs) and *Render sprite trail*.

## Using it in Hammer

Add one `info_particle_system` per rain area:

| Property | Value |
| :--- | :--- |
| Name | the area's name, e.g. `Rain.Area.Pit` |
| Particle System Name | `particles/rain_medium.vpcf` |
| Start Active | on |
| Origin | centre of the area horizontally, **top** of the area vertically |
| Data CP | `1` |
| Data CP Value | `width/2  length/2  rate` |

### Emission rate
The density is based on the original particle: **300 drops per second on 1024 × 1024 units**.

```
rate = 300 × width × length / (1024 × 1024)  ≈  width × length / 3495
     = X × Y / 874        (X, Y = the first two Data CP values)
```

To make all areas denser or sparser, change **Multiply By** of the emission rate in the Particle Editor (e.g. `2` or `0.5`) instead of editing every entity.

### Example
An area of 640 × 640 units whose centre is at `-384 -640 320` and which is 640 units high:

- Top of the area: `320 + 640 / 2 = 640`
- **Origin:** `-384 -640 640`
- **Data CP Value:** `320 320 117` (300 × 640 × 640 / 1048576 ≈ 117)

### Live drops and the max particles limit
A system holds about `rate × lifetime` drops at the same time (a drop lives until it reaches the ground, roughly 2–3 seconds from 640 units). Keep this below **max particles** (`1000`); otherwise new drops are not created and the area looks sparser. The largest area of `de_dust2_long` emits 84 drops per second, far below the limit.

### Placement tips
- Areas may touch but should not overlap, otherwise the rain is twice as dense there.
- Leave out covered places (balconies, tunnels, roofed parts); the drops do not need to be created where they can never fall.
- Do not place rain far outside the playable space: every system that is on screen is simulated.

## Troubleshooting

| Symptom | Cause / fix |
| :--- | :--- |
| No rain in the Particle Editor, `[Inactive]` in the viewport | The preview is stopped: press **Play / Restart**. |
| No rain in the Particle Editor, preview running | Control point 1 has no value (check *Set control point positions*), the box uses CP# `0` instead of `1`, or both box scales are the same (min must be `-1 -1 0`). |
| Rain far above the area in the game | *Position modify offset random* is not set to *Only Enabled in Tools*. |
| Every area has the size of the preview area in the game | *Set control point positions* is not set to *Only Enabled in Tools*. |
| Small areas are much denser than large ones | The emission rate is not read from CP 1 `.Z`, or the large areas hit **max particles**. |
| Rain under roofs | *Collision via traces* is missing or disabled, or the area reaches under the roof. |

## Rain areas of `de_dust2_long`

The areas all end at `z = 704`, so every entity is at that height. Rates use the formula above.

| Area | Size (W × L × H) | Origin | Data CP Value |
| :--- | :--- | :--- | :--- |
| Rain.Area.Pit | 304 × 448 × 896 | `1400 544 704` | `152 224 39` |
| Rain.Area.PitPlat | 240 × 752 × 704 | `1672 664 704` | `120 376 52` |
| Rain.Area.SidePit | 352 × 576 × 704 | `1072 480 704` | `176 288 58` |
| Rain.Area.Blue | 472 × 448 × 704 | `724 992 704` | `236 224 60` |
| Rain.Area.LongCorner | 288 × 352 × 704 | `1104 944 704` | `144 176 29` |
| Rain.Area.LongCornerTop | 288 × 96 × 544 | `1104 1168 704` | `144 48 8` |
| Rain.Area.LongCafe | 304 × 496 × 712 | `1400 1016 704` | `152 248 43` |
| Rain.Area.LongSalon | 368 × 272 × 712 | `1432 1400 704` | `184 136 29` |
| Rain.Area.LongDentist | 448 × 304 × 712 | `1504 1688 704` | `224 152 39` |
| Rain.Area.Car | 576 × 464 × 712 | `1536 2072 704` | `288 232 76` |
| Rain.Area.Cross | 224 × 288 × 712 | `1136 2160 704` | `112 144 18` |
| Rain.Area.Boost | 480 × 384 × 832 | `784 2208 704` | `240 192 53` |
| Rain.Area.Ramp | 352 × 464 × 704 | `1456 2536 704` | `176 232 47` |
| Rain.Area.GooseBarrels | 512 × 368 × 608 | `1280 2952 704` | `256 184 54` |
| Rain.Area.ASite | 256 × 464 × 608 | `1152 2536 704` | `128 232 34` |
| Rain.Area.APlat | 768 × 384 × 608 | `640 2592 704` | `384 192 84` |
| Rain.Area.AShort | 296 × 552 × 608 | `396 2124 704` | `148 276 47` |
| Rain.Area.Stairs | 248 × 520 × 704 | `356 1588 704` | `124 260 37` |
| Rain.Area.Cat | 144 × 160 × 704 | `160 1456 704` | `72 80 7` |
| Rain.Area.CatTop | 144 × 48 × 568 | `160 1352 704` | `72 24 2` |
| Rain.Area.CatEnd | 152 × 272 × 704 | `12 1464 704` | `76 136 12` |

The gaps between the areas are intentional: balconies over Long A, bombsite A and the Pit, the Long tunnel and the mostly covered CT spawn.
