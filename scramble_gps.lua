-- ============================================================
-- Scramble GPS — ChilledDVS Shutoko Servers
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

local ARRIVAL_DIST = 150
local currentDest     = nil
local currentDestName = ""
local fadeAlpha       = 0.0
local fadeTarget      = 0.0
local scriptLoaded    = true  -- used for debug dot

-- ── Try both chat hook approaches ─────────────────────────
local function handleChat(carIndex, message, fromServer)
    local dest = message:match("^Race to (.+)!$")
    if dest and destinations[dest] then
        currentDest     = destinations[dest]
        currentDestName = dest
        fadeTarget      = 1.0
    end
end

-- Method 1: ac.onChatMessage (newer CSP)
if ac.onChatMessage then
    ac.onChatMessage(handleChat)
end

-- Method 2: script.onChatMessage (older CSP)
function script.onChatMessage(carIndex, message, fromServer)
    handleChat(carIndex, message, fromServer)
end

-- ── Per-frame update ───────────────────────────────────────
function script.update(dt)
    fadeAlpha = fadeAlpha + (fadeTarget - fadeAlpha) * math.min(dt * 4, 1)
    if not currentDest then return end
    local car = ac.getCar(0)
    if not car then return end
    if (car.position - currentDest):length() < ARRIVAL_DIST then
        currentDest     = nil
        currentDestName = ""
        fadeTarget      = 0.0
    end
end

-- ── HUD drawing ────────────────────────────────────────────
function script.drawUI()
    -- DEBUG: small green dot top-left confirms script is running
    ui.drawCircleFilled(vec2(30, 200), 6, rgbm(0, 1, 0, 0.8), 12)

    if fadeAlpha < 0.01 then return end

    local car = ac.getCar(0)
    if not car then return end

    local alpha = fadeAlpha
    local pos   = car.position
    local dist  = currentDest and (pos - currentDest):length() or 0

    local cx, cy, r = 1830, 960, 45

    -- Bearing
    local toTarget   = currentDest and (currentDest - pos) or vec3(0, 0, 1)
    local bearing    = math.atan2(toTarget.x, toTarget.z)
    local carHeading = math.atan2(car.look.x, car.look.z)
    local relAngle   = bearing - carHeading

    local dx =  math.sin(relAngle)
    local dy = -math.cos(relAngle)
    local px =  math.cos(relAngle)
    local py =  math.sin(relAngle)

    -- Background
    ui.drawCircleFilled(vec2(cx, cy), r + 6, rgbm(0, 0, 0, 0.6 * alpha), 40)
    ui.drawCircle(vec2(cx, cy), r + 6, rgbm(1, 1, 1, 0.3 * alpha), 40, 1.5)

    -- Arrow shaft
    ui.drawLine(vec2(cx, cy),
        vec2(cx + dx * (r - 10), cy + dy * (r - 10)),
        rgbm(1, 0.2, 0.2, alpha), 3)

    -- Arrowhead
    local tipX  = cx + dx * r
    local tipY  = cy + dy * r
    local baseX = cx + dx * (r - 14)
    local baseY = cy + dy * (r - 14)
    ui.drawTriangleFilled(
        vec2(tipX, tipY),
        vec2(baseX + px * 7, baseY + py * 7),
        vec2(baseX - px * 7, baseY - py * 7),
        rgbm(1, 0.2, 0.2, alpha))

    -- Labels
    local distStr = dist >= 1000
        and string.format("%.1f km", dist / 1000)
        or  string.format("%d m", math.floor(dist + 0.5))

    ui.setCursor(vec2(cx - 80, cy - r - 28))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(currentDestName, vec2(0.5, 0.5), vec2(160, 18))
    ui.popFont()

    ui.setCursor(vec2(cx - 40, cy + r + 10))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(distStr, vec2(0.5, 0.5), vec2(80, 18))
    ui.popFont()
end
