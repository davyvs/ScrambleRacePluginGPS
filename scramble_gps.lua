-- ============================================================
-- Scramble GPS — ChilledDVS Shutoko Servers
-- Detects "Race to X!" chat messages from ScrambleRacePlugin
-- and shows a compass arrow + distance on the HUD.
-- ============================================================

local destinations = {
    ["Shibaura PA"]              = vec3(1098.82,   25.28,  -4642.14),
    ["Daishi PA"]                = vec3(-308.59,   15.49,   6143.80),
    ["Heiwajima PA North"]       = vec3(-230.06,   12.30,   1360.02),
    ["Oi PA"]                    = vec3(964.93,     6.70,   -126.06),
    ["Mirai - Kinko JCT"]        = vec3(-10854.32, 11.96,  13422.77),
    ["Bayshore - Kawasaki Port"] = vec3(-83.84,     7.10,  10983.11),
    ["C1 Outer - Edobashi JCT"]  = vec3(2512.15,   12.23,  -9223.27),
    ["Shinjuku Station"]         = vec3(-4251.66,  32.94, -10032.48),
    ["Yokohama - Daikoku"]       = vec3(-6147.93,  29.65,  13722.33),
}

local ARRIVAL_DIST = 150  -- meters: clear GPS when player arrives this close

local currentDest     = nil
local currentDestName = ""
local fadeAlpha       = 0.0
local fadeTarget      = 0.0

-- ── Chat hook ──────────────────────────────────────────────
function script.onChatMessage(carIndex, message, fromServer)
    local dest = message:match("^Race to (.+)!$")
    if dest and destinations[dest] then
        currentDest     = destinations[dest]
        currentDestName = dest
        fadeTarget      = 1.0
    end
end

-- ── Per-frame update ───────────────────────────────────────
function script.update(dt)
    -- Smooth fade in/out
    fadeAlpha = fadeAlpha + (fadeTarget - fadeAlpha) * math.min(dt * 4, 1)

    if not currentDest then return end

    local car = ac.getCar(0)
    if not car then return end

    local dist = (car.position - currentDest):length()
    if dist < ARRIVAL_DIST then
        currentDest     = nil
        currentDestName = ""
        fadeTarget      = 0.0
    end
end

-- ── HUD drawing ────────────────────────────────────────────
function script.drawUI()
    if fadeAlpha < 0.01 then return end

    local car = ac.getCar(0)
    if not car then return end

    local alpha  = fadeAlpha
    local pos    = car.position
    local dist   = currentDest and (pos - currentDest):length() or 0

    -- Compass center — bottom right corner
    local sw, sh = ac.windowSize()
    local cx = sw - 90
    local cy = sh - 90
    local r  = 45

    -- ── Bearing calculation ────────────────────────────────
    local toTarget  = currentDest and (currentDest - pos) or vec3(0, 0, 1)
    local bearing   = math.atan2(toTarget.x, toTarget.z)
    local carHeading = math.atan2(car.look.x, car.look.z)
    local relAngle  = bearing - carHeading

    -- Arrow direction unit vector in screen space
    local dx =  math.sin(relAngle)
    local dy = -math.cos(relAngle)
    local px =  math.cos(relAngle)  -- perpendicular
    local py =  math.sin(relAngle)

    -- ── Background circle ──────────────────────────────────
    ui.drawCircleFilled(vec2(cx, cy), r + 6, rgbm(0, 0, 0, 0.55 * alpha), 40)
    ui.drawCircle(vec2(cx, cy), r + 6, rgbm(1, 1, 1, 0.25 * alpha), 40, 1.5)

    -- North tick mark
    ui.drawLine(
        vec2(cx,     cy - r + 6),
        vec2(cx,     cy - r - 2),
        rgbm(1, 1, 1, 0.35 * alpha), 1.5
    )

    -- ── Red GPS arrow ──────────────────────────────────────
    -- Shaft
    ui.drawLine(
        vec2(cx, cy),
        vec2(cx + dx * (r - 10), cy + dy * (r - 10)),
        rgbm(1, 0.25, 0.25, alpha), 2.5
    )

    -- Arrowhead triangle
    local tipX  = cx + dx * r
    local tipY  = cy + dy * r
    local baseX = cx + dx * (r - 14)
    local baseY = cy + dy * (r - 14)
    ui.drawTriangleFilled(
        vec2(tipX, tipY),
        vec2(baseX + px * 7, baseY + py * 7),
        vec2(baseX - px * 7, baseY - py * 7),
        rgbm(1, 0.25, 0.25, alpha)
    )

    -- ── Destination name ───────────────────────────────────
    ui.setCursor(vec2(cx - 80, cy - r - 28))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(currentDestName, vec2(0.5, 0.5), vec2(160, 18))
    ui.popFont()

    -- ── Distance label ─────────────────────────────────────
    local distStr
    if dist >= 1000 then
        distStr = string.format("%.1f km", dist / 1000)
    else
        distStr = string.format("%d m", math.floor(dist + 0.5))
    end

    ui.setCursor(vec2(cx - 40, cy + r + 10))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(distStr, vec2(0.5, 0.5), vec2(80, 18))
    ui.popFont()
end
