# Scramble GPS — CSP Online Lua Script

A client-side GPS compass for **Assetto Corsa** servers running [ScrambleRacePlugin](https://assettoserver.org). When an admin starts a scramble race, players get a compass arrow pointing to the destination and a live distance counter on the HUD.

Supports **Shutoko Revival Project** and **Sierra de Cadiz** maps out of the box — one script, configured per server.

> Built for [ChilledDVS](https://chilleddvs.com) · [Discord](https://discord.gg/A4aYXgNadF)

---

## Race Types

| Mode | Command | Description |
|---|---|---|
| **Point to Point** | `!scramble p2p:Destination` | First to reach the destination wins |
| **Convoy** | `!scramble convoy:Destination` | Everyone drives together to the destination |
| **Lap / Circuit** | `!scramble lap:Route Name` | Multi-waypoint circuit with checkpoint announcements |
| **Cat & Mouse** | `!scramble catmouse:PlayerName` | One player is the mouse; everyone else chases |
| **Clear** | `!scramble clear` | Ends the current race and resets GPS for all |

Arrival is detected **server-side** by `ScrambleArrivalPlugin` and announced in chat as `🏁 PlayerName arrived at X!` from the server — players cannot fake arrivals by editing local coordinates.

---

## How It Works

1. Admin types `/scramble` in chat — a countdown starts and the destination is announced via `!scramble p2p:Destination` (or another race type)
2. Players open the **GPS picker** in the CSP chat extras panel and select the destination
3. A **compass arrow + distance counter** appear on the HUD pointing toward the destination
4. When a player arrives within 150 m of the destination, the server announces it in chat: `🏁 PlayerName arrived at Destination!`
5. The GPS arrow clears automatically

---

## For Players

### Opening the GPS Picker

1. Open the **Chat app** in-game (default: `C` or click the chat icon)
2. Look for the **extras icons** at the bottom of the chat panel
3. Click the **Scramble GPS** icon
4. A panel opens — select the destination that was announced
5. The compass arrow appears on your HUD (bottom-right corner)

### Clearing the GPS

Open the GPS panel again and click **[ Clear GPS ]**, or arrive at the destination.

---

## For Server Admins

### Requirements

- [AssettoServer](https://assettoserver.org) with [ScrambleRacePlugin](https://assettoserver.org/patreon-docs/) enabled
- **ScrambleArrivalPlugin** (see below) — required for server-side arrival detection
- Players must have **CSP 0.1.77+** installed via [Content Manager](https://assettocorsa.club/content-manager.html)

---

### 1 — Install the Lua GPS Script

Add the following to your server's `cfg/csp_extra_options.ini`:

```ini
[SCRIPT_2] scramble_gps
SCRIPT = 'https://raw.githubusercontent.com/davyvs/ScrambleRacePluginGPS/main/scramble_gps.lua'
MAP = shutoko
```

Set `MAP` to match your track:

| Value | Map |
|---|---|
| `shutoko` | Shutoko Revival Project |
| `sdc` | Sierra de Cadiz |

> Replace `SCRIPT_2` with the next available script number if you already have other scripts.

Players download the script automatically on join — no server restart required for script updates.

---

### 2 — Install ScrambleArrivalPlugin

This C# AssettoServer plugin detects arrivals **server-side** so the announced winner is verified and unforgeable.

**Build from source** (requires [.NET 9 SDK](https://dotnet.microsoft.com/download/dotnet/9.0) and the [AssettoServer](https://github.com/compujuckel/AssettoServer) source):

```sh
git clone https://github.com/compujuckel/AssettoServer
# Copy ScrambleArrivalPlugin/ from this repo into the AssettoServer repo root
dotnet sln AssettoServer.slnx add ScrambleArrivalPlugin/ScrambleArrivalPlugin.csproj
dotnet publish ScrambleArrivalPlugin -c Release -r linux-x64
# Output: out-linux-x64/plugins/ScrambleArrivalPlugin/
```

Copy the published output to your server's `plugins/ScrambleArrivalPlugin/` folder.

**Enable in `cfg/extra_cfg.yml`:**

```yaml
EnablePlugins:
  - ScrambleRacePlugin
  - ScrambleArrivalPlugin
```

**Configure destinations** — append to `cfg/extra_cfg.yml`:

```yaml
---
!ScrambleArrivalConfiguration
ArrivalRadiusMeters: 150
Maps:
  shutoko:
    "Bayshore - Kawasaki Port": [-83.84, 7.1, 10983.11]
    "C1 Outer - Edobashi JCT":  [2512.15, 12.23, -9223.27]
    "Daishi PA":                [-308.59, 15.49, 6143.8]
    "Heiwajima PA North":       [-230.06, 12.3, 1360.02]
    "Mirai - Kinko JCT":        [-10854.32, 11.96, 13422.77]
    "Oi PA":                    [964.93, 6.7, -126.06]
    "Shibaura PA":              [1098.82, 25.28, -4642.14]
    "Shinjuku Station":         [-4251.66, 32.94, -10032.48]
    "Yokohama - Daikoku":       [-6147.93, 29.65, 13722.33]
  sdc:
    "Grazalema":                [-448.4, 471.6, 7710.1]
    # ... add all SDC destinations here (see scramble_gps.lua for the full list)
```

Destination names must exactly match the names used in `!scramble` commands and the `MAP_DATA` table in `scramble_gps.lua`.

---

### Destinations

#### Shutoko Revival Project

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

#### Sierra de Cadiz

86 destinations including Grazalema, Olvera, Dam, Coffee Shop, El Gastor, Zahara de la Sierra, race track, pits, and all major road crossings. See the full list in [`scramble_gps.lua`](scramble_gps.lua).

### Adding Custom Destinations

Edit `MAP_DATA` at the top of `scramble_gps.lua` and add a matching entry to `extra_cfg.yml`:

```lua
-- scramble_gps.lua
MAP_DATA.shutoko = {
    destinations = {
        ["My Location"] = vec3(X, Y, Z),
        -- ...
    },
}
```

```yaml
# extra_cfg.yml
!ScrambleArrivalConfiguration
Maps:
  shutoko:
    "My Location": [X, Y, Z]
```

Coordinates can be found using the CSP **Track Coordinates Helper** app in-game.

---

## Notes

- The GPS arrow and compass run **client-side** on each player's PC
- Arrival detection and chat announcements are **server-side** via `ScrambleArrivalPlugin` — winners cannot be faked
- Players must rejoin after a script update to get the latest Lua version (the server plugin updates take effect on restart)
- Lap checkpoints are still announced client-side; only the final destination arrival is verified server-side

---

## Credits

**ScrambleRacePlugin** — the server-side plugin that powers the race system — was created by [srinoob](https://github.com/srinoob).  
→ [github.com/srinoob/ScrambleRacePlugin](https://github.com/srinoob/ScrambleRacePlugin)

This GPS script and `ScrambleArrivalPlugin` are companion tools built on top of their work.

---

## License

MIT — free to use, modify, and redistribute.
