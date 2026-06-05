# ScramblePlugin — GPS Race System for AssettoServer

A unified **AssettoServer plugin** that adds GPS-guided races to Assetto Corsa multiplayer servers. When an admin starts a race, every connected player automatically receives a compass arrow pointing to the destination and a live distance counter on their HUD.

Supports **Shutoko Revival Project** and **Sierra de Cadiz** out of the box.

> Built for [ChilledDVS](https://chilleddvs.com) · [Discord](https://discord.gg/A4aYXgNadF)

---

## Features

- **Auto-enroll** — when a race starts, every connected player joins automatically
- **GPS HUD** — compass arrow + distance counter for each player
- **4 race modes** — Point to Point, Convoy, Lap/Circuit, Cat & Mouse
- **Server-side arrival detection** — winners are verified server-side, cannot be faked
- **Finish announcements** — `🏁 PlayerName arrived at X!` broadcast to all
- **DQ system** — disqualifies players who teleport, move at race start, or collide too many times
- **Lua script auto-served** — the GPS script is embedded in the plugin and pushed to every connecting client automatically; no manual install needed for players

---

## Race Modes

| Mode | How to start | Description |
|---|---|---|
| **Point to Point** | Panel → P2P → destination | Race to a single destination; first to arrive wins |
| **Convoy** | Panel → Convoy → destination | Group drive; everyone navigates together |
| **Lap / Circuit** | Panel → Lap → route | Multi-waypoint circuit with checkpoint announcements |
| **Cat & Mouse** | Panel → Cat & Mouse → player | One player is the mouse; everyone else chases |
| **Clear GPS** | Panel → Stop / Clear GPS | Clears GPS for all connected players |

Races can also be started via the `/scramble` chat command when [StartAreas](#optional-startareas) are configured.

---

## How It Works

1. An admin opens the **Scramble GPS** panel in-game and selects a race mode + destination
2. **All connected players** instantly receive the GPS compass on their HUD — no action needed from them
3. Players race to the destination; the server detects arrival and announces positions in chat
4. The GPS clears automatically when a player arrives or is disqualified

---

## For Players

### Opening the GPS Panel

1. Open the **Chat app** in-game (default: `C`)
2. Click the extras icons at the bottom of the chat panel
3. Click the **Scramble GPS** icon (navigation arrow)
4. The panel shows current race status and quick destination buttons

### Clearing Your GPS

Click **Stop / Clear GPS** in the panel, or simply arrive at the destination.

> Players need **CSP 0.1.77+** (via [Content Manager](https://assettocorsa.club/content-manager.html)) for the GPS HUD to appear.

---

## For Server Admins

### Version Guide

ScramblePlugin is shipped as two different compiled Linux x64 builds. Pick the build that matches your AssettoServer version:

| AssettoServer version | Runtime | Prebuilt plugin folder |
|---|---|---|
| **AssettoServer 0.54** | .NET 8 | `out-linux-x64/plugins/ScramblePlugin/` |
| **AssettoServer 0.55** | .NET 9 | `out-linux-x64-055/plugins/ScramblePlugin/` |

Do not mix these builds. The 0.54 DLL targets `net8.0`; the 0.55 DLL targets `net9.0` and uses a different service registration path for AssettoServer 0.55.

### Prebuilt Install: AssettoServer 0.54

Use this when your server is running AssettoServer 0.54.

1. Copy the full plugin folder from:
   ```
   out-linux-x64/plugins/ScramblePlugin/
   ```

2. Paste it into your server's `plugins` folder:
   ```
   plugins/
   └── ScramblePlugin/
       ├── ScramblePlugin.dll
       ├── ScramblePlugin.deps.json
       └── ScramblePlugin.runtimeconfig.json
   ```

3. Enable the plugin in `cfg/extra_cfg.yml`:
   ```yaml
   EnablePlugins:
     - ScramblePlugin
   ```

4. Enable CSP client messages. This is required because the GPS HUD is served to clients as an embedded CSP Lua script:
   ```yaml
   EnableClientMessages: true
   ```

5. Add the `!ScrambleConfiguration` section shown below, then restart the server.

That's it — the GPS Lua script is embedded in the plugin and auto-served to all connecting clients. No separate script hosting needed.

---

### Prebuilt Install: AssettoServer 0.55

Use this when your server is running AssettoServer 0.55.

1. Copy the full plugin folder from:
   ```
   out-linux-x64-055/plugins/ScramblePlugin/
   ```

2. Paste it into your server's `plugins` folder:
   ```
   plugins/
   └── ScramblePlugin/
       ├── ScramblePlugin.dll
       ├── ScramblePlugin.deps.json
       └── ScramblePlugin.runtimeconfig.json
   ```

3. Enable the plugin in `cfg/extra_cfg.yml`:
   ```yaml
   EnablePlugins:
     - ScramblePlugin
   ```

4. Enable CSP client messages:
   ```yaml
   EnableClientMessages: true
   ```

5. Add the `!ScrambleConfiguration` section shown below, then restart the server.

The GPS Lua script is embedded in both plugin builds and is automatically pushed to connecting clients. Players do not need to manually install a Lua app.

---

### Configuration

Add a `ScramblePlugin` section to `cfg/extra_cfg.yml`:

```yaml
---
!ScrambleConfiguration

# Map identifier injected into the GPS Lua script
# Options: shutoko | sdc
MapId: shutoko

# Countdown duration (seconds) after /scramble is initiated
TimeToAcceptSeconds: 30

# Number of collisions before a participant is disqualified (0 = disabled)
CollisionDQLimit: 3

# Position delta (metres) in a single frame that counts as a teleport → DQ
TeleportThresholdMeters: 100

# Maximum speed (m/s) allowed at race start; faster players are disqualified
MaxStartSpeedMs: 2.0
```

---

### Ready-Made Full Configs (SRP & SDC)

Complete, copy-paste `!ScrambleConfiguration` documents with **every** destination and start area already filled in. Drop one into your `cfg/extra_cfg.yml`, make sure `EnablePlugins` lists `ScramblePlugin` and `EnableClientMessages: true`, then restart.

Download the file directly, or expand the block below:

- **Shutoko Revival Project** — [`examples/extra_cfg.shutoko.yml`](examples/extra_cfg.shutoko.yml) · 9 destinations, 6 start areas
- **Sierra de Cadiz** — [`examples/extra_cfg.sdc.yml`](examples/extra_cfg.sdc.yml) · 85 destinations, 5 start areas

<details>
<summary><b>Shutoko Revival Project — full config</b></summary>

```yaml
# ── ScramblePlugin full config — Shutoko Revival Project (SRP) ──
# Paste this document into cfg/extra_cfg.yml (keep the leading ---).
# Requires:  EnablePlugins: [ScramblePlugin]   and   EnableClientMessages: true
---
!ScrambleConfiguration

MapId: shutoko
TimeToAcceptSeconds: 30
MinParticipants: 1
CollisionDQLimit: 0
TeleportThresholdMeters: 500
MaxStartSpeedMs: 2.0
ArrivalRadiusMeters: 150

# 9 destinations
Destinations:
  - Name: "Bayshore - Kawasaki Port"
    Coordinates: [-83.84, 7.1, 10983.11]
    Radius: 150
  - Name: "C1 Outer - Edobashi JCT"
    Coordinates: [2512.15, 12.23, -9223.27]
    Radius: 150
  - Name: "Daishi PA"
    Coordinates: [-308.59, 15.49, 6143.8]
    Radius: 150
  - Name: "Heiwajima PA North"
    Coordinates: [-230.06, 12.3, 1360.02]
    Radius: 150
  - Name: "Mirai - Kinko JCT"
    Coordinates: [-10854.32, 11.96, 13422.77]
    Radius: 150
  - Name: "Oi PA"
    Coordinates: [964.93, 6.7, -126.06]
    Radius: 150
  - Name: "Shibaura PA"
    Coordinates: [1098.82, 25.28, -4642.14]
    Radius: 150
  - Name: "Shinjuku Station"
    Coordinates: [-4251.66, 32.94, -10032.48]
    Radius: 150
  - Name: "Yokohama - Daikoku"
    Coordinates: [-6147.93, 29.65, 13722.33]
    Radius: 150

# Start areas (type /scramble while parked inside one to launch a race).
# Each is an ~160 m square centred on the named destination.
StartAreas:
  - Name: "Shibaura PA"
    Vertices:
      - [1018.8, 0.0, -4722.1]
      - [1178.8, 0.0, -4722.1]
      - [1178.8, 0.0, -4562.1]
      - [1018.8, 0.0, -4562.1]
  - Name: "Daishi PA"
    Vertices:
      - [-388.6, 0.0, 6063.8]
      - [-228.6, 0.0, 6063.8]
      - [-228.6, 0.0, 6223.8]
      - [-388.6, 0.0, 6223.8]
  - Name: "Heiwajima PA North"
    Vertices:
      - [-310.1, 0.0, 1280.0]
      - [-150.1, 0.0, 1280.0]
      - [-150.1, 0.0, 1440.0]
      - [-310.1, 0.0, 1440.0]
  - Name: "Oi PA"
    Vertices:
      - [884.9, 0.0, -206.1]
      - [1044.9, 0.0, -206.1]
      - [1044.9, 0.0, -46.1]
      - [884.9, 0.0, -46.1]
  - Name: "Bayshore - Kawasaki Port"
    Vertices:
      - [-163.8, 0.0, 10903.1]
      - [-3.8, 0.0, 10903.1]
      - [-3.8, 0.0, 11063.1]
      - [-163.8, 0.0, 11063.1]
  - Name: "Yokohama - Daikoku"
    Vertices:
      - [-6227.9, 0.0, 13642.3]
      - [-6067.9, 0.0, 13642.3]
      - [-6067.9, 0.0, 13802.3]
      - [-6227.9, 0.0, 13802.3]
```

</details>

<details>
<summary><b>Sierra de Cadiz — full config (85 destinations)</b></summary>

```yaml
# ── ScramblePlugin full config — Sierra de Cadiz (SDC) ──
# Paste this document into cfg/extra_cfg.yml (keep the leading ---).
# Requires:  EnablePlugins: [ScramblePlugin]   and   EnableClientMessages: true
---
!ScrambleConfiguration

MapId: sdc
TimeToAcceptSeconds: 30
MinParticipants: 1
CollisionDQLimit: 0
TeleportThresholdMeters: 500
MaxStartSpeedMs: 2.0
ArrivalRadiusMeters: 150

# 85 destinations
Destinations:
  - Name: "A-2300"
    Coordinates: [2021.2, 25.4, 1634.8]
    Radius: 150
  - Name: "A-2300 2"
    Coordinates: [235.1, 26.4, 1074.7]
    Radius: 150
  - Name: "A-2300 3"
    Coordinates: [-1081.3, 6.9, 1471.4]
    Radius: 150
  - Name: "A-2300 A-372 Crossing"
    Coordinates: [7902.2, 399.9, 4631.3]
    Radius: 150
  - Name: "A-2300 CA-9123 crossing"
    Coordinates: [3326.3, 19.7, 2706.7]
    Radius: 150
  - Name: "A-2300 MA-8404 Crossing"
    Coordinates: [5065.8, 212.7, 3046.6]
    Radius: 150
  - Name: "A-2300 Pit crossing"
    Coordinates: [-4169.3, -63.9, -4345.0]
    Radius: 150
  - Name: "A-2300 to Fuente La Calera"
    Coordinates: [-1293.4, 38.3, 14.5]
    Radius: 150
  - Name: "A-372"
    Coordinates: [3125.7, 440.3, 7508.2]
    Radius: 150
  - Name: "A-372 1"
    Coordinates: [-3440.4, 701.0, 8262.1]
    Radius: 150
  - Name: "A-372 2"
    Coordinates: [5540.4, 463.4, 6749.0]
    Radius: 150
  - Name: "A-374 A-384 crossing"
    Coordinates: [-1581.3, 112.7, -6116.1]
    Radius: 150
  - Name: "A-374 A-384 Detour"
    Coordinates: [9045.0, 350.4, 4942.6]
    Radius: 150
  - Name: "A-374 detour 1"
    Coordinates: [119.3, 122.1, -4971.7]
    Radius: 150
  - Name: "A-374 MA-7402 crossing"
    Coordinates: [14760.1, 154.1, 7392.2]
    Radius: 150
  - Name: "A-374 to the void"
    Coordinates: [15404.4, 150.2, 7405.9]
    Radius: 150
  - Name: "A-384 A-8126 crossing"
    Coordinates: [-6066.6, -31.9, -5618.4]
    Radius: 150
  - Name: "A-384 CA-9101 crossing"
    Coordinates: [5106.6, 71.3, -12510.2]
    Radius: 150
  - Name: "A-384 N-342 detour"
    Coordinates: [9727.8, 178.8, -10561.4]
    Radius: 150
  - Name: "A-384 Sierra de Lijar"
    Coordinates: [215.3, 12.1, -10432.5]
    Radius: 150
  - Name: "A-384 - Torre Alhaquime"
    Coordinates: [13141.7, 247.0, -11733.7]
    Radius: 150
  - Name: "A-384 to Monasterejo Crossing"
    Coordinates: [12242.2, 91.2, -6248.0]
    Radius: 150
  - Name: "A-8126"
    Coordinates: [-5534.1, 125.7, -8115.0]
    Radius: 150
  - Name: "Alfonso's stream"
    Coordinates: [6760.7, 118.5, -4451.7]
    Radius: 150
  - Name: "Alfonso's stream to N-342"
    Coordinates: [5922.1, 54.4, -6933.7]
    Radius: 150
  - Name: "Algodonales Electric Substation"
    Coordinates: [-4766.5, -27.5, -4761.3]
    Radius: 150
  - Name: "Almazan path 2"
    Coordinates: [-9771.2, 82.3, 7141.0]
    Radius: 150
  - Name: "Arroyo de Romalia"
    Coordinates: [11651.9, 94.0, -9574.0]
    Radius: 150
  - Name: "Autovia A-384"
    Coordinates: [-4142.4, -38.3, -4569.2]
    Radius: 150
  - Name: "CA-4223"
    Coordinates: [6349.8, 79.8, -5691.3]
    Radius: 150
  - Name: "CA-4223 (El Gastor)"
    Coordinates: [3863.6, 317.3, -2130.9]
    Radius: 150
  - Name: "CA-8102"
    Coordinates: [-11583.4, -41.3, -193.5]
    Radius: 150
  - Name: "CA-8102 2"
    Coordinates: [-14632.0, -48.8, 3137.1]
    Radius: 150
  - Name: "CA-9104 1"
    Coordinates: [-2319.0, 222.2, 400.4]
    Radius: 150
  - Name: "CA-9104 2"
    Coordinates: [-2517.9, 359.5, 2551.3]
    Radius: 150
  - Name: "CA-9104 3"
    Coordinates: [-1445.4, 623.6, 3978.5]
    Radius: 150
  - Name: "CA-9104 4"
    Coordinates: [-1442.6, 723.5, 4652.2]
    Radius: 150
  - Name: "CA-9104 5 to Mirador"
    Coordinates: [-1137.9, 833.4, 4853.5]
    Radius: 150
  - Name: "CA-9104 6"
    Coordinates: [-1165.4, 789.6, 5600.9]
    Radius: 150
  - Name: "CA-9104 A-372 crossing"
    Coordinates: [-1638.7, 627.8, 7748.6]
    Radius: 150
  - Name: "CA-9123"
    Coordinates: [2107.5, 91.6, 4294.3]
    Radius: 150
  - Name: "Canada Real de Sevilla"
    Coordinates: [2855.5, -9.9, -13631.3]
    Radius: 150
  - Name: "Carretera a El Jaral"
    Coordinates: [3122.3, 290.5, -2729.6]
    Radius: 150
  - Name: "Casa La Vina"
    Coordinates: [5425.8, 382.8, -3334.1]
    Radius: 150
  - Name: "Chorreadero to Almazan path"
    Coordinates: [-13309.0, -91.7, 8241.5]
    Radius: 150
  - Name: "Coffee Shop"
    Coordinates: [-2372.8, 455.9, 3360.1]
    Radius: 150
  - Name: "Cortijo Salinas detour"
    Coordinates: [3534.1, 74.2, 1964.3]
    Radius: 150
  - Name: "Cruce de El Bosque"
    Coordinates: [-98.78, 1308.17, -38.64]
    Radius: 150
  - Name: "Cuesta La Vina"
    Coordinates: [5813.1, 474.7, -1789.6]
    Radius: 150
  - Name: "Cuesta La Vina 2"
    Coordinates: [5446.4, 271.3, 3725.4]
    Radius: 150
  - Name: "Dam"
    Coordinates: [-2032.0, 5.6, -2936.7]
    Radius: 150
  - Name: "Desvio a Era de la Vina"
    Coordinates: [5607.8, 189.3, -5389.0]
    Radius: 150
  - Name: "El Gastor"
    Coordinates: [3795.0, 255.0, -2535.2]
    Radius: 150
  - Name: "El Gastor Bus Stop"
    Coordinates: [1526.6, 113.9, -610.0]
    Radius: 150
  - Name: "Fox crossing"
    Coordinates: [4820.0, 278.7, -722.6]
    Radius: 150
  - Name: "Grazalema"
    Coordinates: [-448.4, 471.6, 7710.1]
    Radius: 150
  - Name: "Grazalema industrial estate"
    Coordinates: [347.2, 432.3, 7534.8]
    Radius: 150
  - Name: "La Bodega"
    Coordinates: [108.3, 320.5, 5808.8]
    Radius: 150
  - Name: "La Muela detour"
    Coordinates: [11825.1, 122.9, -10430.8]
    Radius: 150
  - Name: "Las Casas"
    Coordinates: [-7550.7, 22.6, -1822.8]
    Radius: 150
  - Name: "Los Alamillos"
    Coordinates: [1254.8, 475.0, 8724.2]
    Radius: 150
  - Name: "MA-7402 1"
    Coordinates: [14386.5, 354.3, 5268.0]
    Radius: 150
  - Name: "MA-7402 2"
    Coordinates: [11291.1, 491.8, 2386.0]
    Radius: 150
  - Name: "MA-7402 3"
    Coordinates: [12950.7, 424.3, -1564.0]
    Radius: 150
  - Name: "MA-7402 CA-4223 crossing"
    Coordinates: [13779.8, 369.4, -2975.8]
    Radius: 150
  - Name: "MA-7402 MA-487 crossing"
    Coordinates: [11687.9, 457.5, 1298.0]
    Radius: 150
  - Name: "Montecorto Creek"
    Coordinates: [4545.6, 46.4, 1565.2]
    Radius: 150
  - Name: "Montecorto Detour"
    Coordinates: [6022.8, 96.9, 2172.5]
    Radius: 150
  - Name: "Montecorto Gas Station"
    Coordinates: [5534.8, 81.3, 2102.8]
    Radius: 150
  - Name: "Montecorto Mountain Road"
    Coordinates: [5242.1, 242.6, 798.9]
    Radius: 150
  - Name: "N-342 CA-4224 crossing"
    Coordinates: [4928.9, 149.0, -6002.9]
    Radius: 150
  - Name: "Olvera"
    Coordinates: [12159.7, 76.9, -8229.1]
    Radius: 150
  - Name: "Oval Track detour"
    Coordinates: [-503.1, 55.5, -7092.7]
    Radius: 150
  - Name: "Oval Track drag racing"
    Coordinates: [354.1, 37.0, -7356.4]
    Radius: 150
  - Name: "Oval Track Parking"
    Coordinates: [-319.7, 37.0, -6480.8]
    Radius: 150
  - Name: "Pit 1"
    Coordinates: [-11941.4, -73.0, -4494.6]
    Radius: 150
  - Name: "Pit 2"
    Coordinates: [-11950.6, -74.4, -4497.4]
    Radius: 150
  - Name: "Pit 3"
    Coordinates: [-11893.9, -75.2, -4539.4]
    Radius: 150
  - Name: "Puerto Chico"
    Coordinates: [683.5, 464.4, 7000.3]
    Radius: 150
  - Name: "Puerto del Boyar"
    Coordinates: [-2777.0, 752.7, 8378.9]
    Radius: 150
  - Name: "Rabbits crossing"
    Coordinates: [4712.2, 312.0, -957.6]
    Radius: 150
  - Name: "Race Track"
    Coordinates: [-2229.3, 667.4, -8104.8]
    Radius: 150
  - Name: "Sendero del tesorillo"
    Coordinates: [-8110.5, 286.5, 8407.9]
    Radius: 150
  - Name: "Zahara de la Sierra"
    Coordinates: [-2575.6, 88.6, -1225.7]
    Radius: 150
  - Name: "Zahara de la Sierra detour"
    Coordinates: [-2976.6, 20.5, -1744.0]
    Radius: 150

# Start areas (type /scramble while parked inside one to launch a race).
# Each is an ~160 m square centred on the named destination.
StartAreas:
  - Name: "Oval Track Parking"
    Vertices:
      - [-399.7, 0.0, -6560.8]
      - [-239.7, 0.0, -6560.8]
      - [-239.7, 0.0, -6400.8]
      - [-399.7, 0.0, -6400.8]
  - Name: "El Gastor Bus Stop"
    Vertices:
      - [1446.6, 0.0, -690.0]
      - [1606.6, 0.0, -690.0]
      - [1606.6, 0.0, -530.0]
      - [1446.6, 0.0, -530.0]
  - Name: "Grazalema"
    Vertices:
      - [-528.4, 0.0, 7630.1]
      - [-368.4, 0.0, 7630.1]
      - [-368.4, 0.0, 7790.1]
      - [-528.4, 0.0, 7790.1]
  - Name: "Montecorto Gas Station"
    Vertices:
      - [5454.8, 0.0, 2022.8]
      - [5614.8, 0.0, 2022.8]
      - [5614.8, 0.0, 2182.8]
      - [5454.8, 0.0, 2182.8]
  - Name: "Zahara de la Sierra"
    Vertices:
      - [-2655.6, 0.0, -1305.7]
      - [-2495.6, 0.0, -1305.7]
      - [-2495.6, 0.0, -1145.7]
      - [-2655.6, 0.0, -1145.7]
```

</details>

> Start areas are ~160 m squares centred on key destinations. Park inside one and type `/scramble` to launch a race. Adjust `Radius` (arrival tolerance) or polygon `Vertices` to taste.

---

### Optional: Destinations

Define named destinations with server-side coordinates for verified arrival detection and the `/scramble` command:

```yaml
Destinations:
  - Name: "Oi PA"
    Coordinates: [964.93, 6.70, -126.06]
    Radius: 150

  - Name: "Daishi PA"
    Coordinates: [-308.59, 15.49, 6143.80]
    Radius: 150

  - Name: "Yokohama - Daikoku"
    Coordinates: [-6147.93, 29.65, 13722.33]
    Radius: 150
```

If no `Destinations` are configured the plugin falls back to the coordinates embedded in the Lua script (arrival is then detected client-side only).

---

### Optional: StartAreas

Define polygon areas on the map from which players can start a `/scramble` race:

```yaml
StartAreas:
  - Name: "Shibaura PA"
    Vertices:
      - [1050.0, 0.0, -4700.0]
      - [1150.0, 0.0, -4700.0]
      - [1150.0, 0.0, -4580.0]
      - [1050.0, 0.0, -4580.0]
```

When StartAreas are configured, typing `/scramble` inside an area:
- Immediately enrolls all connected players
- Starts a countdown (`TimeToAcceptSeconds`)
- Launches the race with full server-side DQ detection

---

## Destinations Reference

### Shutoko Revival Project

| Destination | Coordinates |
|---|---|
| Bayshore - Kawasaki Port | -84, 7, 10983 |
| C1 Outer - Edobashi JCT | 2512, 12, -9223 |
| Daishi PA | -309, 15, 6144 |
| Heiwajima PA North | -230, 12, 1360 |
| Mirai - Kinko JCT | -10854, 12, 13423 |
| Oi PA | 965, 7, -126 |
| Shibaura PA | 1099, 25, -4642 |
| Shinjuku Station | -4252, 33, -10032 |
| Yokohama - Daikoku | -6148, 30, 13722 |

### Sierra de Cadiz

85 destinations including Grazalema, Olvera, Dam, Coffee Shop, El Gastor, Zahara de la Sierra, race track, pits, and all major road crossings. See the full list in [`ScramblePlugin/lua/scramble_gps.lua`](ScramblePlugin/lua/scramble_gps.lua), or the ready-made [`examples/extra_cfg.sdc.yml`](examples/extra_cfg.sdc.yml).

---

## Adding Custom Destinations

Edit `MAP_DATA` in `ScramblePlugin/lua/scramble_gps.lua`:

```lua
MAP_DATA.shutoko = {
    destinations = {
        ["My Location"] = vec3(X, Y, Z),
        -- ...
    },
}
```

Then add a matching entry to `cfg/extra_cfg.yml` for server-side arrival detection:

```yaml
Destinations:
  - Name: "My Location"
    Coordinates: [X, Y, Z]
    Radius: 150
```

In-game coordinates can be found using the CSP **Track Coordinates Helper** app.

---

## Building from Source

The 0.54 build requires the [.NET 8 SDK](https://dotnet.microsoft.com/download/dotnet/8.0) and an AssettoServer 0.54 source checkout at `AssettoServer/`.

The 0.55 build requires the [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) and an AssettoServer 0.55 source checkout at `AssettoServer-055/`.

Expected local source layout:

```text
ScrambleRacePluginGPS/
├── ScramblePlugin/
├── AssettoServer/       # AssettoServer 0.54 source, used by the default build
└── AssettoServer-055/   # AssettoServer 0.55 source, used with -p:AsServer=055
```

### Build for AssettoServer 0.54

```sh
git clone https://github.com/davyvs/ScrambleRacePluginGPS
cd ScrambleRacePluginGPS

dotnet publish ScramblePlugin/ScramblePlugin.csproj -c Release -r linux-x64 --no-self-contained
```

Output:

```text
out-linux-x64/plugins/ScramblePlugin/
├── ScramblePlugin.dll
├── ScramblePlugin.deps.json
└── ScramblePlugin.runtimeconfig.json
```

Copy that `ScramblePlugin/` folder into an AssettoServer 0.54 server's `plugins/` folder.

### Build for AssettoServer 0.55

```sh
git clone https://github.com/davyvs/ScrambleRacePluginGPS
cd ScrambleRacePluginGPS

dotnet publish ScramblePlugin/ScramblePlugin.csproj -c Release -r linux-x64 --no-self-contained -p:AsServer=055
```

Output:

```text
out-linux-x64-055/plugins/ScramblePlugin/
├── ScramblePlugin.dll
├── ScramblePlugin.deps.json
└── ScramblePlugin.runtimeconfig.json
```

Copy that `ScramblePlugin/` folder into an AssettoServer 0.55 server's `plugins/` folder.

---

## License

MIT — free to use, modify, and redistribute.
