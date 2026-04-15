# Scramble GPS — CSP Online Lua Script

A client-side GPS compass for **Assetto Corsa** servers running [ScrambleRacePlugin](https://assettoserver.org). When an admin starts a scramble race, players can select their destination from an in-game HUD picker and get a compass arrow pointing the way.

> Built for [ChilledDVS](https://chilleddvs.com) Shutoko servers · [Discord](https://discord.gg/A4aYXgNadF)

---

## How It Works

1. Admin types `/scramble` in chat — a countdown starts and the destination is announced
2. Players open the **GPS picker** in the CSP chat extras panel and select the destination
3. A **compass arrow + distance** appear on the HUD pointing toward the destination
4. When a player arrives, their name is announced in chat: `🏁 PlayerName arrived at X!`
5. The GPS clears automatically on arrival

---

## For Players

### Opening the GPS Picker

1. Open the **Chat app** in-game (default: press `C` or click the chat icon)
2. Look for the **extras icons** at the bottom of the chat panel
3. Click the **Scramble GPS** icon
4. A panel opens — click the destination that was announced
5. The compass arrow appears on your HUD (bottom-right corner)

### Manual GPS Command

If the server admin types `!gps <destination>` in player chat, the GPS will activate automatically for all players with the script installed.

Example: `!gps Shibaura PA`

### Clearing the GPS

Open the GPS panel again and click **[ Clear GPS ]**, or simply arrive at the destination.

---

## For Server Admins

### Requirements

- [AssettoServer](https://assettoserver.org) with [ScrambleRacePlugin](https://assettoserver.org/patreon-docs/) enabled
- Players must have **CSP (Custom Shaders Patch) 0.1.77+** installed via [Content Manager](https://assettocorsa.club/content-manager.html)

### Installation

Add the following entry to your server's `cfg/csp_extra_options.ini`:

```ini
[SCRIPT_2] scramble_gps
SCRIPT = 'https://raw.githubusercontent.com/davyvs/ScrambleRacePluginGPS/main/scramble_gps.lua'
```

> Replace `SCRIPT_2` with the next available script number if you already have other scripts.

That's it — no server restart required. Players download the script automatically when they join.

### Destinations (Shutoko Revival Project)

The script includes these pre-configured destinations:

| Destination | Coordinates |
|---|---|
| Bayshore - Kawasaki Port | -83, 7, 10983 |
| C1 Outer - Edobashi JCT | 2512, 12, -9223 |
| Daishi PA | -308, 15, 6143 |
| Heiwajima PA North | -230, 12, 1360 |
| Mirai - Kinko JCT | -10854, 11, 13422 |
| Oi PA | 964, 6, -126 |
| Shibaura PA | 1098, 25, -4642 |
| Shinjuku Station | -4251, 32, -10032 |
| Yokohama - Daikoku | -6147, 29, 13722 |

### Adding Custom Destinations

Edit the `destinations` table in `scramble_gps.lua`:

```lua
local destinations = {
    ["My Location"] = vec3(X, Y, Z),
    -- ...
}
```

Coordinates can be found using the CSP **Track Coordinates Helper** app in-game.

---

## Notes

- The script runs **client-side** — it runs on each player's own PC, not on the server
- Players must rejoin the server after a script update to get the latest version
- Chat hook detection (`ac.onChatMessage`) is limited in CSP and does not intercept server plugin messages — this is why the manual picker exists
- The 🏁 arrival message is sent by the **player's client**, so whoever's message appears first in chat is the winner

---

## License

MIT — free to use, modify, and redistribute.
