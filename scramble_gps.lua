-- ============================================================
-- Scramble GPS v3 — ChilledDVS Shutoko Servers
-- Interactive picker via CSP Extras panel + compass HUD
-- ============================================================

local destinations = {
    ["Bayshore - Kawasaki Port"] = vec3(-83.84,     7.10,  10983.11),
    ["C1 Outer - Edobashi JCT"]  = vec3(2512.15,   12.23,  -9223.27),
    ["Daishi PA"]                = vec3(-308.59,   15.49,   6143.80),
    ["Heiwajima PA North"]       = vec3(-230.06,   12.30,   1360.02),
    ["Mirai - Kinko JCT"]        = vec3(-10854.32, 11.96,  13422.77),
    ["Oi PA"]                    = vec3(964.93,     6.70,   -126.06),
    ["Shibaura PA"]              = vec3(1098.82,   25.28,  -4642.14),
    ["Shinjuku Station"]         = vec3(-4251.66,  32.94, -10032.48),
    ["Yokohama - Daikoku"]       = vec3(-6147.93,  29.65,  13722.33),
}

local destNames = {}
for name in pairs(destinations) do destNames[#destNames + 1] = name end
table.sort(destNames)

local ARRIVAL_DIST = 150
local currentDest     = nil
local currentDestName = ""
local fadeAlpha       = 0.0
local fadeTarget      = 0.0

local function setDest(name)
    if destinations[name] then
        currentDest     = destinations[name]
        currentDestName = name
        fadeTarget      = 1.0
    end
end

local function clearDest()
    currentDest     = nil
    currentDestName = ""
    fadeTarget      = 0.0
end

-- ── Auto-detect !gps <name> from player chat ─────────────
local function tryChatDest(message)
    if not message then return end
    local clean = message:gsub("%b[]", ""):gsub("[%z\1-\31\127]", "")
    clean = (clean:match("^%s*(.-)%s*$")) or ""
    local dest = clean:match("!gps%s+(.+)") or clean:match("Race to (.+)!")
    if dest then
        dest = (dest:match("^%s*(.-)%s*$")) or dest
        if destinations[dest] then setDest(dest) end
    end
end

if type(ac.onChatMessage) == "function" then
    ac.onChatMessage(function(_, message) tryChatDest(message) end)
end
function script.onChatMessage(_, message) tryChatDest(message) end

-- ── Interactive GPS picker in CSP Extras panel ────────────
-- Open chat app → click the GPS icon → pick your destination
local _gpsIcon = (ui.Icons and (ui.Icons.Navigation or ui.Icons.Leaderboard)) or 0
ui.registerOnlineExtra(
    _gpsIcon,
    "Scramble GPS",
    function() return true end,
    function()
        local closePanel = false

        ui.pushFont(ui.Font.Small)
        if currentDestName ~= "" then
            ui.textColored("Active: " .. currentDestName, rgbm(0.3, 1.0, 0.3, 1))
        else
            ui.textColored("No destination set", rgbm(0.7, 0.7, 0.7, 1))
        end
        ui.popFont()

        ui.separator()
        ui.pushFont(ui.Font.Small)
        ui.text("Pick a destination:")
        ui.popFont()

        for _, name in ipairs(destNames) do
            local isActive = (name == currentDestName)
            local label    = isActive and ("  >> " .. name .. " <<") or ("     " .. name)
            if ui.button(label, vec2(-1, 0)) then
                setDest(name)
                closePanel = true
            end
        end

        if currentDestName ~= "" then
            ui.separator()
            if ui.button("  [ Clear GPS ]", vec2(-1, 0)) then
                clearDest()
                closePanel = true
            end
        end

        ui.separator()
        if ui.button("  [ Close ]", vec2(-1, 0)) then
            closePanel = true
        end

        return closePanel
    end
)

-- ── Per-frame: arrival check + fade ──────────────────────
function script.update(dt)
    fadeAlpha = fadeAlpha + (fadeTarget - fadeAlpha) * math.min(dt * 4, 1)
    if not currentDest then return end
    local car = ac.getCar(0)
    if not car then return end
    if (car.position - currentDest):length() < ARRIVAL_DIST then
        -- Announce arrival in chat
        local dest = currentDestName
        local name = (ac.getDriverName and ac.getDriverName(0)) or "Driver"
        if type(ac.sendChatMessage) == "function" then
            ac.sendChatMessage("\xF0\x9F\x8F\x81 " .. name .. " arrived at " .. dest .. "!")
        end
        clearDest()
    end
end

-- ── HUD: compass arrow + status ───────────────────────────
function script.drawUI()
    if fadeAlpha < 0.01 then return end

    local car = ac.getCar(0)
    if not car then return end

    local uiState = ac.getUI and ac.getUI()
    local sx = uiState and uiState.windowSize.x or 1920
    local sy = uiState and uiState.windowSize.y or 1080

    local alpha = fadeAlpha
    local pos   = car.position
    local dist  = (pos - currentDest):length()

    local cx = sx - 85
    local cy = sy - 130
    local r  = 40

    local toTarget   = currentDest - pos
    local bearing    = math.atan2(toTarget.x, toTarget.z)
    local carHeading = math.atan2(car.look.x, car.look.z)
    local relAngle   = bearing - carHeading

    local dx =  math.sin(relAngle)
    local dy = -math.cos(relAngle)
    local px =  math.cos(relAngle)
    local py =  math.sin(relAngle)

    -- Circle background
    ui.drawCircleFilled(vec2(cx, cy), r + 6, rgbm(0, 0, 0, 0.65 * alpha), 40)
    ui.drawCircle(      vec2(cx, cy), r + 6, rgbm(1, 1, 1, 0.25 * alpha), 40, 1.5)

    -- Arrow stem
    ui.drawLine(vec2(cx, cy), vec2(cx + dx*(r-10), cy + dy*(r-10)), rgbm(1, 0.2, 0.2, alpha), 2.5)

    -- Arrow head
    local tipX  = cx + dx * r
    local tipY  = cy + dy * r
    local baseX = cx + dx * (r - 13)
    local baseY = cy + dy * (r - 13)
    ui.drawTriangleFilled(
        vec2(tipX, tipY),
        vec2(baseX + px*7, baseY + py*7),
        vec2(baseX - px*7, baseY - py*7),
        rgbm(1, 0.2, 0.2, alpha))

    -- Destination name
    ui.setCursor(vec2(cx - 90, cy - r - 24))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(currentDestName, vec2(0.5, 0.5), vec2(180, 18))
    ui.popFont()

    -- Distance
    local distStr = dist >= 1000 and string.format("%.1f km", dist/1000)
                                  or  string.format("%d m",   math.floor(dist + 0.5))
    ui.setCursor(vec2(cx - 45, cy + r + 8))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(distStr, vec2(0.5, 0.5), vec2(90, 16))
    ui.popFont()
end
