# Lightning and thunder

A random lightning strike for the night variant: the map lights up with a short double flash, lightning flickers in the clouds, and the thunder follows a moment later.

- Used by: the night environment prefab (`maps/prefabs/env_night.vmap`). The day variant has none of these entities.
- Entities: one dynamic light, one or two particles, one sound, a timer and a relay.

## How it works

```
logic_timer (random interval)
   └─ OnTimer → logic_relay "Thunder.Relay" → Trigger
         ├─ light on / off / on / off   (double flash)
         ├─ lightning particles start / stop
         └─ thunder sound, 1.5 s later
```

Baked lights cannot be switched while the game runs, so the flash is a **dynamic** light that is switched by the relay. It is compiled switched off, so it is off at map start and after every round restart.

## Entities

| Name | Class | Purpose |
| :--- | :--- | :--- |
| `Thunder.Lightning` | `light_omni2` | the flash |
| `Thunder.Particle`, `Thunder.Particle2` | `info_particle_system` | lightning in the sky (e.g. Valve's `particles/rain_fx/storm_lightning_*` / `storm_cloud_lightning`) |
| `Thunder.Sound` | `point_soundevent` | the thunder |
| `Thunder.Timer` | `logic_timer` | fires the strike at random intervals |
| `Thunder.Relay` | `logic_relay` | runs one strike |

### `Thunder.Lightning` (light_omni2)
| Property | Value | Why |
| :--- | :--- | :--- |
| **Misc → Client-side entity** | **off** | Lights are client-side by default; a client-side entity only exists on the players' machines and never receives inputs from the server, so Enable/Disable would do nothing. |
| Direct Light → Enabled | **off** | The light starts switched off; the relay's *Enable* input turns it on. A round restart resets it to off. |
| Direct Lighting Type | Dynamic | nothing of it is baked, so it can be switched |
| Cast Shadows | None | a half-baked (*Baked & Dynamic*) light cannot be switched properly; dynamic shadows of such a large light are also expensive |
| Indirect Light | off | bounce light is always baked |
| Color | cold blue-white, e.g. `200 215 255` | |
| Brightness | EV ~10 (tested in the playground) | tune it so the flash is clearly visible but does not blind |
| Range | large enough to cover the map, e.g. 3000–4000 on `de_dust2_long` (1000 in the playground) | |
| Position | high above the middle of the map | |

Keep **Client-side entity** on for every other light; client-side lights are cheaper.

### `Thunder.Timer` (logic_timer)
| Property | Value |
| :--- | :--- |
| Start Disabled | off |
| Use Random Time | on |
| Lower / Upper Random Bound | e.g. `25` / `70` (seconds) |
| Output | `OnTimer` → `Thunder.Relay` → `Trigger` |

The timer restarts by itself when a round restarts.

### `Thunder.Relay` (logic_relay)
| My Output | Target Entity | Target Input | Delay |
| :--- | :--- | :--- | ---: |
| OnTrigger | `Thunder.Lightning` | Enable | 0.00 |
| OnTrigger | `Thunder.Particle` | Start | 0.00 |
| OnTrigger | `Thunder.Particle2` | Start | 0.00 |
| OnTrigger | `Thunder.Lightning` | Disable | 0.08 |
| OnTrigger | `Thunder.Lightning` | Enable | 0.18 |
| OnTrigger | `Thunder.Lightning` | Disable | 0.25 |
| OnTrigger | `Thunder.Particle` | Stop | 0.50 |
| OnTrigger | `Thunder.Particle2` | Stop | 0.50 |
| OnTrigger | `Thunder.Sound` | StartSound | 1.50 |

The thunder comes 1.5 s after the flash, like a strike some distance away. For more variety, make two or three relays with different delays and let the timer pick one (or chain them).

### Particles and sound
- `Thunder.Particle` / `Thunder.Particle2`: **Start Active off**; the relay starts and stops them.
- `Thunder.Sound`: a thunder sound event, **Start On Spawn off**. Map-specific Valve sound events (e.g. `train.Outside.Thunder`) are not loaded on other maps; define your own event in `soundevents/soundevents_addon.vsndevts` that plays the thunder `.vsnd` files instead.
- The thunder is deliberately **not** part of a soundscape: a soundscape change (e.g. walking into a tunnel) would cut it off. A `point_soundevent` keeps playing.

## Testing
In the game console:
```
sv_cheats 1
ent_fire Thunder.Relay Trigger
```
Or switch the light by hand: `ent_fire Thunder.Lightning Enable` / `Disable`.

While testing, a 0.08 s flash is easy to miss: set the first *Disable* to `1` second, then set it back.

## Gameplay notes
- Keep the flash short and moderate: on a dark map a long or very bright flash blinds players, which is unfair.
- Check the frame rate during a flash (`cl_showfps 1`), especially if shadows are enabled.

## Troubleshooting

| Symptom | Cause / fix |
| :--- | :--- |
| The light never switches (Enable / Disable do nothing) | **Client-side entity** is on. Turn it off. |
| The light is always on | **Direct Light → Enabled** is on. Turn it off and rebuild; the light has to be compiled switched off. |
| The light switches only partly or not at all, although it is a server entity | It is (partly) baked: set Cast Shadows to *None* and turn off Indirect Light. |
| No flash visible in the test | The flash is too short to notice, or you are outside the light's Range. |
| No thunder in the game, but it plays in Hammer | The sound event is map-specific (another map's sound file). Use your own sound event. |
