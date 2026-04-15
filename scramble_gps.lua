-- ============================================================
-- Scramble GPS v2 — ChilledDVS Shutoko Servers
-- Manual picker + compass arrow + optional !gps command
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

-- Sorted list for consistent display
local destNames = {}
for name in pairs(destinations) do destNames[#destNames + 1] = name end
table.sort(destNames)

local ARRIVAL_DIST = 150
local currentDest     = nil
local currentDestName = ""
local fadeAlpha       = 0.0
local fadeTarget      = 0.0
local pickerOpen      = false

local function setDest(name)
    if destinations[name] then
        currentDest     = destinations[name]
        currentDestName = name
        fadeTarget      = 1.0
        pickerOpen      = false
    end
end

local function clearDest()
    currentDest     = nil
    currentDestName = ""
    fadeTarget      = 0.0
    pickerOpen      = false
end

-- ── Optional: auto-detect via chat ───────────────────────
-- Fires for player-typed messages; server plugin messages not supported
local function tryChatDest(message)
    if not message then return end
    local clean = message:gsub("%b[]", ""):gsub("[%z\1-\31\127]", "")
    clean = clean:match("^%s*(.-)%s*$") or ""
    -- Support: admin types  !gps Shibaura PA  in player chat
    local dest = clean:match("!gps%s+(.+)") or clean:match("Race to (.+)!")
    if dest then
        dest = dest:match("^%s*(.-)%s*$")
        if destinations[dest] then setDest(dest) end
    end
end

if type(ac.onChatMessage) == "function" then
    ac.onChatMessage(function(_, message) tryChatDest(message) end)
end
function script.onChatMessage(_, message) tryChatDest(message) end

-- ── Update: arrival check ─────────────────────────────────
function script.update(dt)
    fadeAlpha = fadeAlpha + (fadeTarget - fadeAlpha) * math.min(dt * 4, 1)
    if not currentDest then return end
    local car = ac.getCar(0)
    if not car then return end
    if (car.position - currentDest):length() < ARRIVAL_DIST then
        clearDest()
    end
end

-- ── HUD ───────────────────────────────────────────────────
function script.drawUI()

    -- ── Destination picker window ─────────────────────────
    local ROW_H  = 22
    local PAD    = 6
    local BTN_W  = 170
    local rows   = pickerOpen and (#destNames + 2) or 1
    local winW   = BTN_W + PAD * 2
    local winH   = rows * ROW_H + PAD * 2

    -- Position: bottom-right
    local uiState = ac.getUI and ac.getUI()
    local sx = uiState and uiState.windowSize.x or 1920
    local sy = uiState and uiState.windowSize.y or 1080
    local wx = sx - winW - 10
    local wy = sy - winH - 10

    ui.toolWindow('scrambleGPS', vec2(wx, wy), vec2(winW, winH), function()
        -- Header button (toggle)
        local hdrLabel = currentDestName ~= "" and ("GPS \xe2\x96\xb6 " .. currentDestName) or "GPS \xe2\x96\xbc Pick destination"
        if currentDestName ~= "" then
            hdrLabel = "GPS \xe2\x96\xb6 " .. currentDestName
        end
        if ui.button(pickerOpen and "[ close ]" or hdrLabel, vec2(BTN_W, ROW_H - 2)) then
            pickerOpen = not pickerOpen
        end

        if pickerOpen then
            ui.separator()
            for _, name in ipairs(destNames) do
                local label = (name == currentDestName) and ("* " .. name) or ("  " .. name)
                if ui.button(label, vec2(BTN_W, ROW_H - 2)) then
                    setDest(name)
                end
            end
            if currentDestName ~= "" then
                ui.separator()
                if ui.button("  [ Clear GPS ]", vec2(BTN_W, ROW_H - 2)) then
                    clearDest()
                end
            end
        end
    end)

    -- ── Compass arrow ─────────────────────────────────────
    if fadeAlpha < 0.01 then return end
    local car = ac.getCar(0)
    if not car then return end

    local alpha = fadeAlpha
    local pos   = car.position
    local dist  = (pos - currentDest):length()

    -- Arrow circle: bottom-right above the picker
    local cx = sx - 85
    local cy = sy - winH - 70
    local r  = 38

    local toTarget   = currentDest - pos
    local bearing    = math.atan2(toTarget.x, toTarget.z)
    local carHeading = math.atan2(car.look.x, car.look.z)
    local relAngle   = bearing - carHeading

    local dx =  math.sin(relAngle)
    local dy = -math.cos(relAngle)
    local px =  math.cos(relAngle)
    local py =  math.sin(relAngle)

    ui.drawCircleFilled(vec2(cx, cy), r + 5, rgbm(0, 0, 0, 0.65 * alpha), 40)
    ui.drawCircle(     vec2(cx, cy), r + 5, rgbm(1, 1, 1, 0.25 * alpha), 40, 1.5)
    ui.drawLine(vec2(cx, cy), vec2(cx + dx*(r-8), cy + dy*(r-8)), rgbm(1, 0.2, 0.2, alpha), 2.5)

    local tipX  = cx + dx * r
    local tipY  = cy + dy * r
    local baseX = cx + dx * (r - 12)
    local baseY = cy + dy * (r - 12)
    ui.drawTriangleFilled(
        vec2(tipX, tipY),
        vec2(baseX + px*6, baseY + py*6),
        vec2(baseX - px*6, baseY - py*6),
        rgbm(1, 0.2, 0.2, alpha))

    -- Distance label
    local distStr = dist >= 1000 and string.format("%.1f km", dist/1000)
                                  or  string.format("%d m",   math.floor(dist + 0.5))
    ui.setCursor(vec2(cx - 40, cy + r + 6))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(distStr, vec2(0.5, 0.5), vec2(80, 16))
    ui.popFont()
end
