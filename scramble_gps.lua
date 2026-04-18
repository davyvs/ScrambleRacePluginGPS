-- ============================================================
-- Scramble GPS v5 — ChilledDVS Servers
-- Race Types: Point to Point | Convoy | Lap/Circuit | Cat & Mouse
-- Multi-map: configure MAP = shutoko | sdc in csp_extra_options.ini
-- github.com/davyvs/ScrambleRacePluginGPS
-- ============================================================

-- ── [1] MAP DATA ─────────────────────────────────────────

local MAP_DATA = {}

MAP_DATA.shutoko = {
    destinations = {
        ["Bayshore - Kawasaki Port"] = vec3(-83.84,     7.10,  10983.11),
        ["C1 Outer - Edobashi JCT"]  = vec3(2512.15,   12.23,  -9223.27),
        ["Daishi PA"]                = vec3(-308.59,   15.49,   6143.80),
        ["Heiwajima PA North"]       = vec3(-230.06,   12.30,   1360.02),
        ["Mirai - Kinko JCT"]        = vec3(-10854.32, 11.96,  13422.77),
        ["Oi PA"]                    = vec3(964.93,     6.70,   -126.06),
        ["Shibaura PA"]              = vec3(1098.82,   25.28,  -4642.14),
        ["Shinjuku Station"]         = vec3(-4251.66,  32.94, -10032.48),
        ["Yokohama - Daikoku"]       = vec3(-6147.93,  29.65,  13722.33),
    },
    lapRoutes = {
        ["Bayshore Sprint"] = {
            "Yokohama - Daikoku", "Mirai - Kinko JCT", "Daishi PA",
            "Oi PA", "Heiwajima PA North",
        },
        ["Inner City Loop"] = {
            "Shibaura PA", "Heiwajima PA North", "Oi PA",
            "C1 Outer - Edobashi JCT", "Shinjuku Station",
        },
        ["Full Shutoko"] = {
            "Yokohama - Daikoku", "Mirai - Kinko JCT", "Bayshore - Kawasaki Port",
            "Daishi PA", "Oi PA", "Heiwajima PA North",
            "Shibaura PA", "C1 Outer - Edobashi JCT", "Shinjuku Station",
        },
    },
    lapRouteNames = { "Bayshore Sprint", "Inner City Loop", "Full Shutoko" },
}

MAP_DATA.sdc = {
    destinations = {
        ["A-2300"]                          = vec3( 2021.2,   25.4,   1634.8),
        ["A-2300 2"]                        = vec3(  235.1,   26.4,   1074.7),
        ["A-2300 3"]                        = vec3(-1081.3,    6.9,   1471.4),
        ["A-2300 A-372 Crossing"]           = vec3( 7902.2,  399.9,   4631.3),
        ["A-2300 CA-9123 crossing"]         = vec3( 3326.3,   19.7,   2706.7),
        ["A-2300 MA-8404 Crossing"]         = vec3( 5065.8,  212.7,   3046.6),
        ["A-2300 Pit crossing"]             = vec3(-4169.3,  -63.9,  -4345.0),
        ["A-2300 to Fuente La Calera"]      = vec3(-1293.4,   38.3,     14.5),
        ["A-372"]                           = vec3( 3125.7,  440.3,   7508.2),
        ["A-372 1"]                         = vec3(-3440.4,  701.0,   8262.1),
        ["A-372 2"]                         = vec3( 5540.4,  463.4,   6749.0),
        ["A-374 A-384 crossing"]            = vec3(-1581.3,  112.7,  -6116.1),
        ["A-374 A-384 Detour"]              = vec3( 9045.0,  350.4,   4942.6),
        ["A-374 detour 1"]                  = vec3(  119.3,  122.1,  -4971.7),
        ["A-374 MA-7402 crossing"]          = vec3(14760.1,  154.1,   7392.2),
        ["A-374 to the void"]               = vec3(15404.4,  150.2,   7405.9),
        ["A-384 A-8126 crossing"]           = vec3(-6066.6,  -31.9,  -5618.4),
        ["A-384 CA-9101 crossing"]          = vec3( 5106.6,   71.3, -12510.2),
        ["A-384 N-342 detour"]              = vec3( 9727.8,  178.8, -10561.4),
        ["A-384 Sierra de Lijar"]           = vec3(  215.3,   12.1, -10432.5),
        ["A-384 - Torre Alhaquime"]         = vec3(13141.7,  247.0, -11733.7),
        ["A-384 to Monasterejo Crossing"]   = vec3(12242.2,   91.2,  -6248.0),
        ["A-8126"]                          = vec3(-5534.1,  125.7,  -8115.0),
        ["Alfonso's stream"]                = vec3( 6760.7,  118.5,  -4451.7),
        ["Alfonso's stream to N-342"]       = vec3( 5922.1,   54.4,  -6933.7),
        ["Algodonales Electric Substation"] = vec3(-4766.5,  -27.5,  -4761.3),
        ["Almazan path 2"]                  = vec3(-9771.2,   82.3,   7141.0),
        ["Arroyo de Romalia"]               = vec3(11651.9,   94.0,  -9574.0),
        ["Autovia A-384"]                   = vec3(-4142.4,  -38.3,  -4569.2),
        ["CA-4223"]                         = vec3( 6349.8,   79.8,  -5691.3),
        ["CA-4223 (El Gastor)"]             = vec3( 3863.6,  317.3,  -2130.9),
        ["CA-8102"]                         = vec3(-11583.4, -41.3,   -193.5),
        ["CA-8102 2"]                       = vec3(-14632.0, -48.8,   3137.1),
        ["CA-9104 1"]                       = vec3(-2319.0,  222.2,    400.4),
        ["CA-9104 2"]                       = vec3(-2517.9,  359.5,   2551.3),
        ["CA-9104 3"]                       = vec3(-1445.4,  623.6,   3978.5),
        ["CA-9104 4"]                       = vec3(-1442.6,  723.5,   4652.2),
        ["CA-9104 5 to Mirador"]            = vec3(-1137.9,  833.4,   4853.5),
        ["CA-9104 6"]                       = vec3(-1165.4,  789.6,   5600.9),
        ["CA-9104 A-372 crossing"]          = vec3(-1638.7,  627.8,   7748.6),
        ["CA-9123"]                         = vec3( 2107.5,   91.6,   4294.3),
        ["Canada Real de Sevilla"]          = vec3( 2855.5,   -9.9, -13631.3),
        ["Carretera a El Jaral"]            = vec3( 3122.3,  290.5,  -2729.6),
        ["Casa La Vina"]                    = vec3( 5425.8,  382.8,  -3334.1),
        ["Chorreadero to Almazan path"]     = vec3(-13309.0, -91.7,   8241.5),
        ["Coffee Shop"]                     = vec3(-2372.8,  455.9,   3360.1),
        ["Cortijo Salinas detour"]          = vec3( 3534.1,   74.2,   1964.3),
        ["Cruce de El Bosque"]              = vec3(  -98.78,1308.17,   -38.64),
        ["Cuesta La Vina"]                  = vec3( 5813.1,  474.7,  -1789.6),
        ["Cuesta La Vina 2"]                = vec3( 5446.4,  271.3,   3725.4),
        ["Dam"]                             = vec3(-2032.0,    5.6,  -2936.7),
        ["Desvio a Era de la Vina"]         = vec3( 5607.8,  189.3,  -5389.0),
        ["El Gastor"]                       = vec3( 3795.0,  255.0,  -2535.2),
        ["El Gastor Bus Stop"]              = vec3( 1526.6,  113.9,   -610.0),
        ["Fox crossing"]                    = vec3( 4820.0,  278.7,   -722.6),
        ["Grazalema"]                       = vec3( -448.4,  471.6,   7710.1),
        ["Grazalema industrial estate"]     = vec3(  347.2,  432.3,   7534.8),
        ["La Bodega"]                       = vec3(  108.3,  320.5,   5808.8),
        ["La Muela detour"]                 = vec3(11825.1,  122.9, -10430.8),
        ["Las Casas"]                       = vec3(-7550.7,   22.6,  -1822.8),
        ["Los Alamillos"]                   = vec3( 1254.8,  475.0,   8724.2),
        ["MA-7402 1"]                       = vec3(14386.5,  354.3,   5268.0),
        ["MA-7402 2"]                       = vec3(11291.1,  491.8,   2386.0),
        ["MA-7402 3"]                       = vec3(12950.7,  424.3,  -1564.0),
        ["MA-7402 CA-4223 crossing"]        = vec3(13779.8,  369.4,  -2975.8),
        ["MA-7402 MA-487 crossing"]         = vec3(11687.9,  457.5,   1298.0),
        ["Montecorto Creek"]                = vec3( 4545.6,   46.4,   1565.2),
        ["Montecorto Detour"]               = vec3( 6022.8,   96.9,   2172.5),
        ["Montecorto Gas Station"]          = vec3( 5534.8,   81.3,   2102.8),
        ["Montecorto Mountain Road"]        = vec3( 5242.1,  242.6,    798.9),
        ["N-342 CA-4224 crossing"]          = vec3( 4928.9,  149.0,  -6002.9),
        ["Olvera"]                          = vec3(12159.7,   76.9,  -8229.1),
        ["Oval Track detour"]               = vec3( -503.1,   55.5,  -7092.7),
        ["Oval Track drag racing"]          = vec3(  354.1,   37.0,  -7356.4),
        ["Oval Track Parking"]              = vec3( -319.7,   37.0,  -6480.8),
        ["Pit 1"]                           = vec3(-11941.4, -73.0,  -4494.6),
        ["Pit 2"]                           = vec3(-11950.6, -74.4,  -4497.4),
        ["Pit 3"]                           = vec3(-11893.9, -75.2,  -4539.4),
        ["Puerto Chico"]                    = vec3(  683.5,  464.4,   7000.3),
        ["Puerto del Boyar"]                = vec3(-2777.0,  752.7,   8378.9),
        ["Rabbits crossing"]                = vec3( 4712.2,  312.0,   -957.6),
        ["Race Track"]                      = vec3(-2229.3,  667.4,  -8104.8),
        ["Sendero del tesorillo"]           = vec3(-8110.5,  286.5,   8407.9),
        ["Zahara de la Sierra"]             = vec3(-2575.6,   88.6,  -1225.7),
        ["Zahara de la Sierra detour"]      = vec3(-2976.6,   20.5,  -1744.0),
    },
    lapRoutes = {
        ["Grazalema Loop"] = {
            "Coffee Shop", "CA-9104 5 to Mirador", "Grazalema",
            "Puerto Chico", "La Bodega",
        },
        ["Mountain Pass"] = {
            "Dam", "Zahara de la Sierra", "CA-9104 1",
            "CA-9104 5 to Mirador", "Puerto del Boyar", "Grazalema",
        },
        ["Cadiz Road Tour"] = {
            "Montecorto Gas Station", "Cuesta La Vina", "El Gastor",
            "Zahara de la Sierra", "Grazalema", "Puerto del Boyar",
            "Los Alamillos", "Olvera",
        },
    },
    lapRouteNames = { "Grazalema Loop", "Mountain Pass", "Cadiz Road Tour" },
}

-- ── [2] MAP SELECTION ────────────────────────────────────

local cfg    = ac.configValues and ac.configValues() or {}
local mapId  = type(cfg.MAP) == "string" and cfg.MAP:lower() or "shutoko"
local mapCfg = MAP_DATA[mapId] or MAP_DATA.shutoko

local destinations  = mapCfg.destinations
local LAP_ROUTES    = mapCfg.lapRoutes
local lapRouteNames = mapCfg.lapRouteNames

local destNames = {}
for name in pairs(destinations) do destNames[#destNames + 1] = name end
table.sort(destNames)

local ARRIVAL_DIST = 150

-- ── [3] STATE ─────────────────────────────────────────────

local RACE = {
    mode       = "idle",   -- "idle"|"p2p"|"convoy"|"lap"|"catmouse"
    role       = "none",   -- "navigator"|"cat"|"mouse"|"none"
    isAdmin    = false,
    -- P2P / Convoy
    dest       = nil,
    destName   = "",
    -- Cat & Mouse
    mouseSlot  = -1,
    mouseName  = "",
    -- Lap
    routeName  = "",
    waypoints  = {},
    wpNames    = {},
    wpIndex    = 1,
    -- Fade
    fadeAlpha  = 0.0,
    fadeTarget = 0.0,
}

local PANEL = {
    view         = "main",
    selDest      = "",
    selRoute     = "",
    selMouseName = "",
}

-- ── [4] COMMAND ENCODING / PARSING ───────────────────────

local function enc(s) return (s or ""):gsub(" ", "_") end
local function dec(s) return (s or ""):gsub("_", " ") end

local function parseCmd(msg)
    if not msg then return nil end
    local clean = msg:gsub("%b[]", ""):gsub("[%z\1-\31\127]", "")
    clean = (clean:match("^%s*(.-)%s*$")) or ""
    local body = clean:match("^!scramble%s+(.+)$")
    if not body then return nil end
    local parts = {}
    for p in body:gmatch("[^:]+") do
        parts[#parts + 1] = dec((p:match("^%s*(.-)%s*$")) or p)
    end
    if #parts == 0 then return nil end
    return { type = parts[1], params = parts }
end

-- ── [5] STATE APPLIER ────────────────────────────────────

local function clearRace()
    RACE.mode      = "idle"
    RACE.role      = "none"
    RACE.dest      = nil
    RACE.destName  = ""
    RACE.mouseSlot = -1
    RACE.mouseName = ""
    RACE.routeName = ""
    RACE.waypoints = {}
    RACE.wpNames   = {}
    RACE.wpIndex   = 1
    RACE.fadeTarget = 0.0
end

local function localName()
    return (ac.getDriverName and ac.getDriverName(0)) or "Driver"
end

local function findSlot(name)
    local n = (ac.getSim and ac.getSim().carsCount) or 0
    for i = 0, n - 1 do
        local c = ac.getCar(i)
        if c and c.isConnected and ac.getDriverName(i) == name then return i end
    end
    return -1
end

local function applyCmd(cmd)
    if not cmd then return end
    local t = cmd.type

    if t == "clear" then
        clearRace()

    elseif t == "p2p" then
        local dest = cmd.params[2] or ""
        if destinations[dest] then
            clearRace()
            RACE.mode = "p2p"; RACE.role = "navigator"
            RACE.dest = destinations[dest]; RACE.destName = dest
            RACE.fadeTarget = 1.0
        end

    elseif t == "convoy" then
        local dest = cmd.params[2] or ""
        if destinations[dest] then
            clearRace()
            RACE.mode = "convoy"; RACE.role = "navigator"
            RACE.dest = destinations[dest]; RACE.destName = dest
            RACE.fadeTarget = 1.0
        end

    elseif t == "lap" then
        local route = cmd.params[2] or ""
        if LAP_ROUTES[route] then
            clearRace()
            RACE.mode = "lap"; RACE.role = "navigator"
            RACE.routeName = route
            RACE.wpNames   = LAP_ROUTES[route]
            RACE.waypoints = {}
            for _, n in ipairs(RACE.wpNames) do
                RACE.waypoints[#RACE.waypoints + 1] = destinations[n]
            end
            RACE.wpIndex    = 1
            RACE.fadeTarget = 1.0
        end

    elseif t == "catmouse" then
        local mname = cmd.params[2] or ""
        clearRace()
        RACE.mode      = "catmouse"
        RACE.mouseName = mname
        RACE.mouseSlot = findSlot(mname)
        RACE.role      = (localName() == mname) and "mouse" or "cat"
        RACE.fadeTarget = 1.0
    end
end

-- Backward compat for bare !gps / Race to X!
local function tryLegacy(msg)
    if not msg then return end
    local clean = msg:gsub("%b[]",""):gsub("[%z\1-\31\127]","")
    clean = (clean:match("^%s*(.-)%s*$")) or ""
    local dest = clean:match("!gps%s+(.+)") or clean:match("Race to (.+)!")
    if dest then
        dest = (dest:match("^%s*(.-)%s*$")) or dest
        if destinations[dest] then
            applyCmd({ type="p2p", params={"p2p", dest} })
        end
    end
end

-- ── [6] CHAT LISTENERS ───────────────────────────────────

local function onMsg(message)
    local cmd = parseCmd(message)
    if cmd then applyCmd(cmd) else tryLegacy(message) end
end

if type(ac.onChatMessage) == "function" then
    ac.onChatMessage(function(_, message) onMsg(message) end)
end
function script.onChatMessage(_, message) onMsg(message) end

-- ── [7] PANEL HELPERS ────────────────────────────────────

local function broadcast(cmdStr, cmd)
    if type(ac.sendChatMessage) == "function" then
        ac.sendChatMessage(cmdStr)
    end
    applyCmd(cmd)
end

local function showMain()
    local close = false
    ui.pushFont(ui.Font.Small)
    local mode = RACE.mode
    if     mode == "idle"     then ui.textColored("No race active",                              rgbm(.6,.6,.6,1))
    elseif mode == "p2p"      then ui.textColored("\xF0\x9F\x8F\x81 P2P: " .. RACE.destName,    rgbm(1,.4,.4,1))
    elseif mode == "convoy"   then ui.textColored("\xF0\x9F\x9A\x97 Convoy: " .. RACE.destName,  rgbm(.2,.9,.55,1))
    elseif mode == "lap"      then ui.textColored("\xF0\x9F\x94\xB5 Lap " .. RACE.routeName ..
                                                  " (" .. RACE.wpIndex .. "/" .. #RACE.waypoints .. ")", rgbm(.4,.6,1,1))
    elseif mode == "catmouse" then
        if RACE.role == "mouse" then ui.textColored("\xF0\x9F\x90\xAD You are the MOUSE!", rgbm(1,.3,.3,1))
        else ui.textColored("\xF0\x9F\x90\xB1 Chasing: " .. RACE.mouseName, rgbm(1,.6,.1,1)) end
    end
    ui.popFont()
    ui.separator()

    if not RACE.isAdmin then
        if ui.button("  Enter Admin Mode", vec2(-1, 0)) then RACE.isAdmin = true end
    else
        if ui.button("  \xe2\x96\xba Start Race...", vec2(-1, 0)) then
            PANEL.view = "type_select"; PANEL.selDest = ""; PANEL.selRoute = ""; PANEL.selMouseName = ""
        end
        if RACE.mode ~= "idle" then
            if ui.button("  \xe2\x96\xa0 Stop / Clear GPS", vec2(-1, 0)) then
                broadcast("!scramble clear", { type="clear", params={"clear"} })
                close = true
            end
        end
    end

    if RACE.mode == "p2p" or RACE.mode == "convoy" or RACE.mode == "idle" then
        ui.separator()
        ui.pushFont(ui.Font.Tiny); ui.text("Quick destination:"); ui.popFont()
        for _, name in ipairs(destNames) do
            local active = (name == RACE.destName and RACE.mode ~= "idle")
            if ui.button((active and "* " or "  ") .. name, vec2(-1, 0)) then
                broadcast("!scramble p2p:" .. enc(name), { type="p2p", params={"p2p", name} })
                close = true
            end
        end
    elseif RACE.mode == "lap" then
        ui.separator()
        ui.pushFont(ui.Font.Tiny)
        ui.text("Next: " .. (RACE.wpNames[RACE.wpIndex] or "?"))
        ui.popFont()
    end

    ui.separator()
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

local function showTypeSelect()
    local close = false
    ui.pushFont(ui.Font.Small); ui.text("Select Race Type:"); ui.popFont()
    ui.separator()
    if ui.button("  \xF0\x9F\x8F\x81  Point to Point",  vec2(-1, 0)) then PANEL.view = "config_p2p"    end
    if ui.button("  \xF0\x9F\x9A\x97  Convoy / Cruise", vec2(-1, 0)) then PANEL.view = "config_convoy"  end
    if ui.button("  \xF0\x9F\x94\xB5  Lap / Circuit",   vec2(-1, 0)) then PANEL.view = "config_lap"     end
    if ui.button("  \xF0\x9F\x90\xB1  Cat & Mouse",     vec2(-1, 0)) then PANEL.view = "config_cm"      end
    ui.separator()
    if ui.button("  Back",  vec2(-1, 0)) then PANEL.view = "main" end
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

local function showConfigDest(typeKey, title, cr, cg, cb)
    local close = false
    ui.pushFont(ui.Font.Small); ui.textColored(title, rgbm(cr, cg, cb, 1)); ui.popFont()
    ui.separator()
    for _, name in ipairs(destNames) do
        if ui.button((name == PANEL.selDest and "* " or "  ") .. name, vec2(-1, 0)) then
            PANEL.selDest = name
        end
    end
    ui.separator()
    if PANEL.selDest ~= "" then
        if ui.button("  Start " .. title .. "  \xe2\x96\xba", vec2(-1, 0)) then
            broadcast("!scramble " .. typeKey .. ":" .. enc(PANEL.selDest),
                      { type = typeKey, params = { typeKey, PANEL.selDest } })
            PANEL.view = "main"; close = true
        end
    end
    if ui.button("  Back",  vec2(-1, 0)) then PANEL.view = "type_select" end
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

local function showConfigLap()
    local close = false
    ui.pushFont(ui.Font.Small); ui.textColored("Lap / Circuit", rgbm(.4,.6,1,1)); ui.popFont()
    ui.separator()
    for _, rname in ipairs(lapRouteNames) do
        local wps = LAP_ROUTES[rname]
        local lbl = (rname == PANEL.selRoute and "* " or "  ") .. rname .. " (" .. #wps .. " wp)"
        if ui.button(lbl, vec2(-1, 0)) then PANEL.selRoute = rname end
    end
    ui.separator()
    if PANEL.selRoute ~= "" then
        if ui.button("  Start Lap  \xe2\x96\xba", vec2(-1, 0)) then
            broadcast("!scramble lap:" .. enc(PANEL.selRoute),
                      { type = "lap", params = { "lap", PANEL.selRoute } })
            PANEL.view = "main"; close = true
        end
    end
    if ui.button("  Back",  vec2(-1, 0)) then PANEL.view = "type_select" end
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

local function showConfigCM()
    local close = false
    ui.pushFont(ui.Font.Small); ui.textColored("Cat & Mouse", rgbm(1,.55,.1,1)); ui.popFont()
    ui.separator()
    ui.pushFont(ui.Font.Tiny); ui.text("Select the MOUSE player:"); ui.popFont()
    local n = (ac.getSim and ac.getSim().carsCount) or 0
    for i = 0, n - 1 do
        local c = ac.getCar(i)
        if c and c.isConnected then
            local dname = ac.getDriverName(i)
            local lbl   = (dname == PANEL.selMouseName and "* \xF0\x9F\x90\xAD " or "  ") .. dname
            if ui.button(lbl, vec2(-1, 0)) then PANEL.selMouseName = dname end
        end
    end
    ui.separator()
    if PANEL.selMouseName ~= "" then
        if ui.button("  Start Cat & Mouse  \xe2\x96\xba", vec2(-1, 0)) then
            broadcast("!scramble catmouse:" .. enc(PANEL.selMouseName),
                      { type = "catmouse", params = { "catmouse", PANEL.selMouseName } })
            PANEL.view = "main"; close = true
        end
    end
    if ui.button("  Back",  vec2(-1, 0)) then PANEL.view = "type_select" end
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

-- ── [8] registerOnlineExtra DISPATCHER ───────────────────

local _icon = ui.Icons and (
    ui.Icons.Navigation or ui.Icons.Explore or ui.Icons.Map or
    ui.Icons.LocationOn or ui.Icons.MyLocation or ui.Icons.NearMe or
    ui.Icons.Flag or ui.Icons.SportsScore or ui.Icons.Leaderboard or
    ui.Icons.Settings
) or nil
ui.registerOnlineExtra(_icon, "Scramble GPS", function() return true end, function()
    local v = PANEL.view
    if     v == "main"          then return showMain()
    elseif v == "type_select"   then return showTypeSelect()
    elseif v == "config_p2p"    then return showConfigDest("p2p",    "\xF0\x9F\x8F\x81 Point to Point",  1, .4, .4)
    elseif v == "config_convoy" then return showConfigDest("convoy",  "\xF0\x9F\x9A\x97 Convoy / Cruise", .2, .9, .55)
    elseif v == "config_lap"    then return showConfigLap()
    elseif v == "config_cm"     then return showConfigCM()
    else return showMain() end
end)

-- ── [9] HUD HELPERS ──────────────────────────────────────

local function screenSize()
    local u = ac.getUI and ac.getUI()
    return (u and u.windowSize.x or 1920), (u and u.windowSize.y or 1080)
end

local function drawArrow(car, target, cr, cg, cb, alpha)
    local sx, sy = screenSize()
    local cx, cy, r = sx - 85, sy - 130, 40

    local toT   = target - car.position
    local bear  = math.atan2(toT.x, toT.z)
    local head  = math.atan2(car.look.x, car.look.z)
    local angle = bear - head

    local dx, dy =  math.sin(angle), -math.cos(angle)
    local px, py =  math.cos(angle),  math.sin(angle)

    ui.drawCircleFilled(vec2(cx,cy), r+6, rgbm(0,0,0,.65*alpha), 40)
    ui.drawCircle(      vec2(cx,cy), r+6, rgbm(1,1,1,.25*alpha), 40, 1.5)
    ui.drawLine(vec2(cx,cy), vec2(cx+dx*(r-10), cy+dy*(r-10)), rgbm(cr,cg,cb,alpha), 2.5)
    ui.drawTriangleFilled(
        vec2(cx+dx*r,           cy+dy*r),
        vec2(cx+dx*(r-13)+px*7, cy+dy*(r-13)+py*7),
        vec2(cx+dx*(r-13)-px*7, cy+dy*(r-13)-py*7),
        rgbm(cr, cg, cb, alpha))
    return cx, cy, r
end

local function drawLabels(cx, cy, r, topLine, botLine, alpha)
    if topLine and topLine ~= "" then
        ui.setCursor(vec2(cx-90, cy-r-24))
        ui.pushFont(ui.Font.Small)
        ui.textAligned(topLine, vec2(.5,.5), vec2(180,18))
        ui.popFont()
    end
    if botLine and botLine ~= "" then
        ui.setCursor(vec2(cx-45, cy+r+8))
        ui.pushFont(ui.Font.Small)
        ui.textAligned(botLine, vec2(.5,.5), vec2(90,16))
        ui.popFont()
    end
end

local function fmtDist(d)
    return d >= 1000 and string.format("%.1f km", d/1000) or string.format("%d m", math.floor(d+.5))
end

local function drawMouseBadge(alpha)
    local sx, _ = screenSize()
    local pulse = math.abs(math.sin(os.clock() * 2.5))
    local a = alpha * (.5 + .5 * pulse)
    local bw, bh = 340, 56
    local bx = sx/2 - bw/2
    ui.drawRectFilled(vec2(bx,30),      vec2(bx+bw, 30+bh), rgbm(.6,0,0,.75*a))
    ui.drawRect(      vec2(bx,30),      vec2(bx+bw, 30+bh), rgbm(1,.2,.2,a), 2)
    ui.setCursor(vec2(bx, 36))
    ui.pushFont(ui.Font.Title)
    ui.textAligned("\xF0\x9F\x90\xAD  YOU ARE THE MOUSE", vec2(.5,.5), vec2(bw, bh-12))
    ui.popFont()
end

-- ── [10] script.drawUI DISPATCHER ────────────────────────

function script.drawUI()
    local alpha = RACE.fadeAlpha
    if alpha < 0.01 then return end
    local car = ac.getCar(0)
    if not car then return end

    local mode = RACE.mode

    if mode == "p2p" then
        local cx, cy, r = drawArrow(car, RACE.dest, 1, .2, .2, alpha)
        drawLabels(cx, cy, r, RACE.destName,
            fmtDist((car.position - RACE.dest):length()), alpha)

    elseif mode == "convoy" then
        local cx, cy, r = drawArrow(car, RACE.dest, .2, .9, .55, alpha)
        drawLabels(cx, cy, r, "\xF0\x9F\x9A\x97 " .. RACE.destName,
            fmtDist((car.position - RACE.dest):length()), alpha)

    elseif mode == "lap" then
        local wp = RACE.waypoints[RACE.wpIndex]
        if not wp then return end
        local cx, cy, r = drawArrow(car, wp, .3, .55, 1, alpha)
        local badge = "WP " .. RACE.wpIndex .. "/" .. #RACE.waypoints ..
                      ": " .. (RACE.wpNames[RACE.wpIndex] or "?")
        drawLabels(cx, cy, r, badge, fmtDist((car.position - wp):length()), alpha)

    elseif mode == "catmouse" then
        if RACE.role == "mouse" then
            drawMouseBadge(alpha)
        elseif RACE.role == "cat" then
            if RACE.mouseSlot < 0 then
                RACE.mouseSlot = findSlot(RACE.mouseName)
            end
            if RACE.mouseSlot >= 0 then
                local mc = ac.getCar(RACE.mouseSlot)
                if mc and mc.isConnected then
                    local cx, cy, r = drawArrow(car, mc.position, 1, .55, .1, alpha)
                    drawLabels(cx, cy, r, "\xF0\x9F\x90\xB1 " .. RACE.mouseName,
                        fmtDist((car.position - mc.position):length()), alpha)
                end
            end
        end
    end
end

-- ── [11] UPDATE HELPERS & script.update ──────────────────

local function updateP2P(car)
    if not RACE.dest then return end
    if (car.position - RACE.dest):length() < ARRIVAL_DIST then
        -- Arrival announcement is sent by the server (ScrambleArrivalPlugin)
        -- so we only clear the local UI state here.
        clearRace()
    end
end

local function updateLap(car)
    local wp = RACE.waypoints[RACE.wpIndex]
    if not wp then return end
    if (car.position - wp):length() < ARRIVAL_DIST then
        local name = localName()
        if RACE.wpIndex < #RACE.waypoints then
            if type(ac.sendChatMessage) == "function" then
                ac.sendChatMessage("\xe2\x9c\x85 " .. name ..
                    ": checkpoint " .. RACE.wpIndex .. "/" .. #RACE.waypoints ..
                    " \xe2\x80\x94 " .. (RACE.wpNames[RACE.wpIndex] or ""))
            end
            RACE.wpIndex = RACE.wpIndex + 1
        else
            if type(ac.sendChatMessage) == "function" then
                ac.sendChatMessage("\xF0\x9F\x8F\x81 " .. name ..
                    " completed the " .. RACE.routeName .. " lap!")
            end
            clearRace()
        end
    end
end

function script.update(dt)
    RACE.fadeAlpha = RACE.fadeAlpha + (RACE.fadeTarget - RACE.fadeAlpha) * math.min(dt * 4, 1)
    local mode = RACE.mode
    if mode == "idle" then return end
    local car = ac.getCar(0)
    if not car then return end
    if mode == "p2p" or mode == "convoy" then updateP2P(car)
    elseif mode == "lap"                 then updateLap(car)
    end
    -- catmouse: no arrival check, ends via !scramble clear from admin
end
