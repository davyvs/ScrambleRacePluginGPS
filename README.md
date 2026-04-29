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

86 destinations including Grazalema, Olvera, Dam, Coffee Shop, El Gastor, Zahara de la Sierra, race track, pits, and all major road crossings. See the full list in [`ScramblePlugin/lua/scramble_gps.lua`](ScramblePlugin/lua/scramble_gps.lua).

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
