-- ============================================================
-- Scramble GPS v5 — ChilledDVS Servers
-- Race Types: Point to Point | Convoy | Lap/Circuit | Cat & Mouse
-- Multi-map: configure MAP = shutoko | sdc in csp_extra_options.ini
-- github.com/davyvs/ScrambleRacePluginGPS
-- ============================================================

-- ── [1] MAP DATA ─────────────────────────────────────────

local MAP_DATA = {}

MAP_DATA.shutoko = {
    acTrackFolder = "shuto_revival_project_beta",  -- AC content/tracks folder name
    mapViewRange  = 4500,   -- max metres from player to panel edge (zoom cap)
    -- map.ini fallback values (used when io.open is sandboxed)
    mapScale      = 3.31084418296814,
    mapXOffset    = 11141.494140625,
    mapZOffset    = 10476.2548828125,
    mapImgW       = 5534.9033203125,
    mapImgH       = 8177.9033203125,
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
    gpsMaxEdge      = 9000,  -- max straight-line distance (m) for a graph edge
    gpsMaxNeighbors = 4,     -- how many nearest neighbours each node connects to
    startAreas = {
        "Shibaura PA",
        "Daishi PA",
        "Heiwajima PA North",
        "Oi PA",
        "Bayshore - Kawasaki Port",
        "Yokohama - Daikoku",
    },
}

MAP_DATA.sdc = {
    acTrackFolder = "sierra_de_cadiz",  -- AC content/tracks folder name
    mapViewRange  = 3500,   -- max metres from player to panel edge (zoom cap)
    -- map.ini fallback values (used when io.open is sandboxed)
    mapScale      = 5.0,
    mapXOffset    = 16000,
    mapZOffset    = 15000,
    mapImgW       = 165000,
    mapImgH       = 155000,
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
    gpsMaxEdge      = 5000,  -- SDC has many closely-spaced road points
    gpsMaxNeighbors = 5,
    startAreas = {
        "Oval Track Parking",
        "El Gastor Bus Stop",
        "Grazalema",
        "Montecorto Gas Station",
        "Zahara de la Sierra",
    },
}

-- ── [2] MAP SELECTION ────────────────────────────────────

local cfg    = ac.configValues({ MAP = "shutoko", SCRAMBLE_PLUGIN = "0" })
local mapId  = (cfg.MAP or "shutoko"):lower()
local hasScramblePlugin = cfg.SCRAMBLE_PLUGIN == "1"
local mapCfg = MAP_DATA[mapId] or MAP_DATA.shutoko

local destinations  = mapCfg.destinations
local LAP_ROUTES    = mapCfg.lapRoutes
local lapRouteNames = mapCfg.lapRouteNames

local destNames = {}
for name in pairs(destinations) do destNames[#destNames + 1] = name end
table.sort(destNames)

local startAreaNames = mapCfg.startAreas or {}

local ARRIVAL_DIST = 150

-- ── [2b] ROAD GRAPH + A* PATHFINDING ────────────────────────────────────────
-- The destinations table already contains real road positions.
-- We connect each destination to its N nearest neighbours to build a rough
-- road graph, then A* finds a multi-hop path to the target.
-- The GPS arrow then points at the NEXT HOP rather than straight to the end.

local ROAD_GRAPH = nil  -- built once on first update tick

local function buildRoadGraph()
    local maxEdge = mapCfg.gpsMaxEdge      or 5000
    local maxK    = mapCfg.gpsMaxNeighbors or 5
    local graph   = {}
    local nodes   = {}
    for name, pos in pairs(destinations) do
        nodes[#nodes + 1] = { name = name, pos = pos }
        graph[name] = {}
    end
    for _, a in ipairs(nodes) do
        local cands = {}
        for _, b in ipairs(nodes) do
            if a.name ~= b.name then
                -- Use XZ-plane distance so elevation doesn't distort edges
                local dx = a.pos.x - b.pos.x
                local dz = a.pos.z - b.pos.z
                local d  = math.sqrt(dx*dx + dz*dz)
                if d <= maxEdge then
                    cands[#cands + 1] = { name = b.name, cost = d }
                end
            end
        end
        table.sort(cands, function(x, y) return x.cost < y.cost end)
        for i = 1, math.min(maxK, #cands) do
            graph[a.name][#graph[a.name] + 1] = cands[i]
        end
    end
    return graph
end

-- A* over the road graph. Returns ordered list of destination names, or nil.
local function findRoute(startName, endName)
    if startName == endName then return { endName } end
    if not ROAD_GRAPH then return nil end

    local ep   = destinations[endName]
    if not ep then return nil end

    local open   = { startName }
    local closed = {}
    local from   = {}
    local g      = { [startName] = 0 }
    local f      = {}

    local function h(name)
        local p = destinations[name]
        if not p then return math.huge end
        local dx, dz = p.x - ep.x, p.z - ep.z
        return math.sqrt(dx*dx + dz*dz)
    end
    f[startName] = h(startName)

    local MAX_ITER = 300
    for _ = 1, MAX_ITER do
        if #open == 0 then break end

        -- Pop node with lowest f
        local bestIdx, bestF = 1, f[open[1]] or math.huge
        for i = 2, #open do
            local fi = f[open[i]] or math.huge
            if fi < bestF then bestIdx, bestF = i, fi end
        end
        local cur = table.remove(open, bestIdx)

        if cur == endName then
            local path = { cur }
            while from[cur] do
                cur = from[cur]
                table.insert(path, 1, cur)
            end
            return path
        end

        closed[cur] = true
        for _, nb in ipairs(ROAD_GRAPH[cur] or {}) do
            if not closed[nb.name] then
                local ng = (g[cur] or math.huge) + nb.cost
                if ng < (g[nb.name] or math.huge) then
                    from[nb.name] = cur
                    g[nb.name]    = ng
                    f[nb.name]    = ng + h(nb.name)
                    local found = false
                    for _, n in ipairs(open) do
                        if n == nb.name then found = true; break end
                    end
                    if not found then open[#open + 1] = nb.name end
                end
            end
        end
    end
    return nil  -- no path found (disconnected graph)
end

-- Find the destination name closest to world position pos (XZ plane).
local function nearestDest(pos)
    local best, bestD = nil, math.huge
    for name, dpos in pairs(destinations) do
        local dx, dz = pos.x - dpos.x, pos.z - dpos.z
        local d = math.sqrt(dx*dx + dz*dz)
        if d < bestD then bestD = d; best = name end
    end
    return best, bestD
end

-- Compute a road-following route to destName and store it in RACE.
-- Called whenever a new GPS destination is set.
local function computeRoute(destName)
    RACE.gpsRoute    = {}
    RACE.gpsRouteIdx = 1
    if not destinations[destName] then return end
    if not ROAD_GRAPH then return end
    local car = ac.getCar(0)
    if not car then return end

    local startName, startDist = nearestDest(car.position)
    if not startName then return end

    -- Already at destination – no routing needed
    local ep = destinations[destName]
    local dx, dz = car.position.x - ep.x, car.position.z - ep.z
    if math.sqrt(dx*dx + dz*dz) < 300 then return end

    local path = findRoute(startName, destName)
    if not path or #path <= 1 then return end

    RACE.gpsRoute    = path
    RACE.gpsRouteIdx = (startDist < 250 and #path >= 2) and 2 or 1
end

local function _roadGraphInit()
    if ROAD_GRAPH then return end
    ROAD_GRAPH = buildRoadGraph()
end

-- ── [2c] TRACK MAP INFO (for minimap panel) ──────────────────────────────────

local MAP_INFO = {
    loaded    = false,
    iniParsed = false,  -- true when map.ini was successfully read (scale/offsets are valid)
    path      = nil,    -- string = PNG path; false = no tracks dir found at all
    scale     = 1.0,    -- SCALE_FACTOR from map.ini (map pixels per metre)
    xOff      = 0.0,    -- X_OFFSET  (world X + xOff) * scale = map pixel X
    zOff      = 0.0,    -- Z_OFFSET
    imgW      = 1024,   -- WIDTH  (pixels)
    imgH      = 1024,   -- HEIGHT (pixels)
}

local function _loadMapInfo()
    if MAP_INFO.loaded then return end
    MAP_INFO.loaded = true

    -- ── Content/tracks directory ───────────────────────────────────────────────
    local tracksDir = ""
    if ac.getFolder then
        local ok, v = pcall(function() return ac.getFolder(ac.FolderID.ContentTracks) end)
        if ok and v and v ~= "" then
            tracksDir = v
        else
            local ok2, root = pcall(function() return ac.getFolder(ac.FolderID.Root) end)
            if ok2 and root and root ~= "" then tracksDir = root .. "/content/tracks" end
        end
    end
    if tracksDir == "" then MAP_INFO.path = false; return end

    -- ── Build search directory list ────────────────────────────────────────────
    local searchDirs = {}

    -- 1. Dynamic: use CSP track ID functions
    local trackID = ""
    if ac.getTrackFullID then
        local ok, v = pcall(function() return ac.getTrackFullID("/") end)
        if ok and v and v ~= "" then trackID = v end
    end
    if trackID == "" then
        local ok1, tid = pcall(function() return ac.getTrackID and ac.getTrackID() end)
        if ok1 and tid and tid ~= "" then
            trackID = tid
            local ok2, lid = pcall(function() return ac.getTrackConfigID and ac.getTrackConfigID() end)
            if ok2 and lid and lid ~= "" then trackID = trackID .. "/" .. lid end
        end
    end
    if trackID ~= "" then
        local baseDir = tracksDir .. "/" .. trackID
        searchDirs[#searchDirs + 1] = baseDir
        searchDirs[#searchDirs + 1] = baseDir .. "/data"
        -- Also try parent dir (for layout tracks where map lives at root)
        local parent = baseDir:match("^(.*)/[^/]+$")
        if parent and parent ~= tracksDir then searchDirs[#searchDirs + 1] = parent end
        -- Also try stripping any "csp/…/" prefix — server paths use csp/XXXX/../E/../trackname
        local baseName = trackID:match("[^/]+$")
        if baseName and baseName ~= trackID then
            searchDirs[#searchDirs + 1] = tracksDir .. "/" .. baseName
            searchDirs[#searchDirs + 1] = tracksDir .. "/" .. baseName .. "/data"
        end
    end

    -- 2. Hardcoded fallback from MAP_DATA (known track folder names)
    local hardcoded = mapCfg.acTrackFolder or ""
    if hardcoded ~= "" then
        searchDirs[#searchDirs + 1] = tracksDir .. "/" .. hardcoded
        searchDirs[#searchDirs + 1] = tracksDir .. "/" .. hardcoded .. "/data"
    end

    -- ── Find map PNG ───────────────────────────────────────────────────────────
    local function tryOpen(p)
        local ok, f = pcall(io.open, p, "rb")
        if ok and f then pcall(function() f:close() end); return true end
        return false
    end

    for _, dir in ipairs(searchDirs) do
        for _, name in ipairs({"map_mini.png", "map.png"}) do
            local p = dir .. "/" .. name
            if tryOpen(p) then MAP_INFO.path = p; break end
        end
        if MAP_INFO.path then break end
    end

    -- If io.open unavailable (CSP sandbox), guess via hardcoded folder — ui.drawImage
    -- silently draws nothing if wrong, so this is safe.
    if not MAP_INFO.path then
        local fallbackDir = hardcoded ~= "" and (tracksDir .. "/" .. hardcoded)
                            or (#searchDirs > 0 and searchDirs[1])
                            or nil
        if fallbackDir then MAP_INFO.path = fallbackDir .. "/map_mini.png" end
    end

    if not MAP_INFO.path then MAP_INFO.path = false; return end

    -- ── Parse map.ini (try file first, then hardcoded MAP_DATA fallback) ───────
    local function parseIni(dir)
        local ok, f = pcall(io.open, dir .. "/map.ini", "r")
        if not ok or not f then return false end
        local parsed = false
        pcall(function()
            for line in f:lines() do
                local k, v = line:match("^%s*([%w_]+)%s*=%s*([%d%.%-]+)")
                if k and v then
                    local uk = k:upper()
                    if uk == "SCALE_FACTOR" or uk == "SCALE" then
                        MAP_INFO.scale = tonumber(v) or 1; parsed = true end
                    if uk == "X_OFFSET"    then MAP_INFO.xOff = tonumber(v) or 0; parsed = true end
                    if uk == "Z_OFFSET"    then MAP_INFO.zOff = tonumber(v) or 0; parsed = true end
                    if uk == "WIDTH"       then MAP_INFO.imgW = math.max(1, tonumber(v) or 1024) end
                    if uk == "HEIGHT"      then MAP_INFO.imgH = math.max(1, tonumber(v) or 1024) end
                end
            end
        end)
        pcall(function() f:close() end)
        if parsed then MAP_INFO.iniParsed = true end
        return parsed
    end

    for _, dir in ipairs(searchDirs) do
        if parseIni(dir) then break end
    end

    -- Hardcoded fallback: use MAP_DATA values when io.open is sandboxed or file missing
    if not MAP_INFO.iniParsed then
        local s = mapCfg.mapScale
        if s and s > 0 then
            MAP_INFO.scale     = s
            MAP_INFO.xOff      = mapCfg.mapXOffset  or 0
            MAP_INFO.zOff      = mapCfg.mapZOffset  or 0
            MAP_INFO.imgW      = math.max(1, mapCfg.mapImgW or 1024)
            MAP_INFO.imgH      = math.max(1, mapCfg.mapImgH or 1024)
            MAP_INFO.iniParsed = true
        end
    end
end

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
    -- ScramblePlugin server-controlled state
    serverControlled = false,  -- true when state comes from OnlineEvent
    destRadius       = 150,    -- arrival radius from server (metres)
    raceStartsAt     = 0,      -- Unix ms when countdown ends; 0 = not in countdown
    -- Road-following GPS route (A* result)
    gpsRoute         = {},     -- ordered list of destination names
    gpsRouteIdx      = 1,      -- current waypoint index into gpsRoute
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
    RACE.mode        = "idle"
    RACE.role        = "none"
    RACE.dest        = nil
    RACE.destName    = ""
    RACE.mouseSlot   = -1
    RACE.mouseName   = ""
    RACE.routeName   = ""
    RACE.waypoints   = {}
    RACE.wpNames     = {}
    RACE.wpIndex     = 1
    RACE.gpsRoute    = {}
    RACE.gpsRouteIdx = 1
    RACE.fadeTarget  = 0.0
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
    -- When ScramblePlugin is managing the race, ignore legacy chat commands
    if RACE.serverControlled then return end
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
            computeRoute(dest)
        end

    elseif t == "convoy" then
        local dest = cmd.params[2] or ""
        if destinations[dest] then
            clearRace()
            RACE.mode = "convoy"; RACE.role = "navigator"
            RACE.dest = destinations[dest]; RACE.destName = dest
            RACE.fadeTarget = 1.0
            computeRoute(dest)
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
    -- When ScramblePlugin is managing the race, ignore legacy chat commands
    if RACE.serverControlled then return end
    local cmd = parseCmd(message)
    if cmd then applyCmd(cmd) else tryLegacy(message) end
end

if type(ac.onChatMessage) == "function" then
    ac.onChatMessage(function(_, message) onMsg(message) end)
end
function script.onChatMessage(_, message) onMsg(message) end

-- ── [6b] SCRAMBLE PLUGIN ONLINE EVENTS ───────────────────
-- Only active when ScramblePlugin is running server-side (hasScramblePlugin == true).
-- These events carry race state from the server to this client.

local RACE_STATE_IDLE      = 0
local RACE_STATE_COUNTDOWN = 1
local RACE_STATE_RACING    = 2

-- Player-to-player GPS broadcast signal (set in section [6b], used in section [7])
local scrambleGpsSignal = nil

if hasScramblePlugin then
    ac.OnlineEvent({
        ac.StructItem.key("scrambleRaceState"),
        raceState    = ac.StructItem.byte(),
        destName     = ac.StructItem.string(64),
        destX        = ac.StructItem.float(),
        destY        = ac.StructItem.float(),
        destZ        = ac.StructItem.float(),
        destRadius   = ac.StructItem.float(),
        raceStartsAt = ac.StructItem.int64(),
    }, function(sender, msg)
        if sender ~= nil then return end  -- only accept from server

        if msg.raceState == RACE_STATE_IDLE then
            clearRace()
            RACE.serverControlled = false

        elseif msg.raceState == RACE_STATE_COUNTDOWN then
            clearRace()
            RACE.serverControlled = true
            RACE.mode         = "p2p"
            RACE.role         = "navigator"
            RACE.destName     = msg.destName
            RACE.dest         = vec3(msg.destX, msg.destY, msg.destZ)
            RACE.destRadius   = msg.destRadius
            RACE.raceStartsAt = msg.raceStartsAt
            RACE.fadeTarget   = 1.0

        elseif msg.raceState == RACE_STATE_RACING then
            RACE.serverControlled = true
            RACE.mode         = "p2p"
            RACE.role         = "navigator"
            RACE.destName     = msg.destName
            RACE.dest         = vec3(msg.destX, msg.destY, msg.destZ)
            RACE.destRadius   = msg.destRadius
            RACE.raceStartsAt = 0
            RACE.fadeTarget   = 1.0
            computeRoute(msg.destName)
        end
    end)

    ac.OnlineEvent({
        ac.StructItem.key("scrambleResult"),
        status    = ac.StructItem.byte(),
        position  = ac.StructItem.byte(),
        dqReason  = ac.StructItem.byte(),
    }, function(sender, msg)
        if sender ~= nil then return end  -- only accept from server
        -- Race ended (finished or DQ) — clear HUD and reset server control
        clearRace()
        RACE.serverControlled = false
    end)

    -- ── GPS broadcast signal: player-to-player ─────────────
    -- When an admin uses the panel to start/stop GPS, this event is sent
    -- to all other connected players so they see the same GPS immediately.
    -- raceMode: 0=clear, 1=p2p, 2=convoy, 3=catmouse, 4=lap
    scrambleGpsSignal = ac.OnlineEvent({
        ac.StructItem.key("scrambleGpsSignal"),
        destX      = ac.StructItem.float(),
        destY      = ac.StructItem.float(),
        destZ      = ac.StructItem.float(),
        destRadius = ac.StructItem.float(),
        destName   = ac.StructItem.string(64),
        raceMode   = ac.StructItem.byte(),
    }, function(sender, msg)
        -- Ignore if the server is currently managing the race
        if RACE.serverControlled then return end
        if msg.raceMode == 0 then
            clearRace()
        elseif msg.raceMode == 1 or msg.raceMode == 2 then
            -- p2p or convoy
            clearRace()
            RACE.serverControlled = false
            RACE.mode       = (msg.raceMode == 2) and "convoy" or "p2p"
            RACE.role       = "navigator"
            RACE.destName   = msg.destName
            RACE.dest       = vec3(msg.destX, msg.destY, msg.destZ)
            RACE.destRadius = msg.destRadius
            RACE.fadeTarget = 1.0
            if destinations[msg.destName] then computeRoute(msg.destName) end
        elseif msg.raceMode == 3 then
            -- catmouse: destName carries the mouse player's name
            clearRace()
            local myName = localName()
            RACE.serverControlled = false
            RACE.mode      = "catmouse"
            RACE.mouseName = msg.destName
            RACE.mouseSlot = findSlot(msg.destName)
            RACE.role      = (myName == msg.destName) and "mouse" or "cat"
            RACE.fadeTarget = 1.0
        elseif msg.raceMode == 4 then
            -- lap: destName carries the route name
            local route = msg.destName
            if LAP_ROUTES[route] then
                clearRace()
                RACE.serverControlled = false
                RACE.mode      = "lap"
                RACE.role      = "navigator"
                RACE.routeName = route
                RACE.wpNames   = LAP_ROUTES[route]
                RACE.waypoints = {}
                for _, n in ipairs(RACE.wpNames) do
                    RACE.waypoints[#RACE.waypoints + 1] = destinations[n]
                end
                RACE.wpIndex   = 1
                RACE.fadeTarget = 1.0
            end
        end
    end)
end

-- ── [7] PANEL HELPERS ────────────────────────────────────

local function broadcast(cmdStr, cmd)
    if type(ac.sendChatMessage) == "function" then
        ac.sendChatMessage(cmdStr)
    end
    applyCmd(cmd)
    -- Broadcast GPS state to all other connected players via CSP online event
    if scrambleGpsSignal then
        local t = cmd.type
        if (t == "p2p" or t == "convoy") and cmd.params[2] then
            local dest = destinations[cmd.params[2]]
            if dest then
                scrambleGpsSignal({
                    destX      = dest.x,
                    destY      = dest.y,
                    destZ      = dest.z,
                    destRadius = ARRIVAL_DIST,
                    destName   = cmd.params[2],
                    raceMode   = (t == "convoy") and 2 or 1,
                })
            end
        elseif t == "catmouse" and cmd.params[2] then
            -- destName carries the mouse player's name
            scrambleGpsSignal({ destX=0, destY=0, destZ=0, destRadius=0,
                destName=cmd.params[2], raceMode=3 })
        elseif t == "lap" and cmd.params[2] then
            -- destName carries the route name
            scrambleGpsSignal({ destX=0, destY=0, destZ=0, destRadius=0,
                destName=cmd.params[2], raceMode=4 })
        elseif t == "clear" then
            scrambleGpsSignal({ destX=0, destY=0, destZ=0, destRadius=0, destName="", raceMode=0 })
        end
    end
end

local function showMain()
    local close = false
    local mode = RACE.mode

    -- Status line
    ui.pushFont(ui.Font.Small)
    if     mode == "idle"     then ui.textColored("No race active",                              rgbm(.6,.6,.6,1))
    elseif mode == "p2p"      then ui.textColored("\xF0\x9F\x8F\x81 Racing to: " .. RACE.destName,  rgbm(1,.4,.4,1))
    elseif mode == "convoy"   then ui.textColored("\xF0\x9F\x9A\x97 Convoy: " .. RACE.destName,     rgbm(.2,.9,.55,1))
    elseif mode == "lap"      then ui.textColored("\xF0\x9F\x94\xB5 Lap: " .. RACE.routeName ..
                                                  " (" .. RACE.wpIndex .. "/" .. #RACE.waypoints .. ")", rgbm(.4,.6,1,1))
    elseif mode == "catmouse" then
        if RACE.role == "mouse" then ui.textColored("\xF0\x9F\x90\xAD You are the MOUSE!", rgbm(1,.3,.3,1))
        else ui.textColored("\xF0\x9F\x90\xB1 Chasing: " .. RACE.mouseName, rgbm(1,.6,.1,1)) end
    end
    ui.popFont()

    -- Lap next-waypoint hint
    if mode == "lap" then
        ui.pushFont(ui.Font.Tiny)
        ui.text("Next: " .. (RACE.wpNames[RACE.wpIndex] or "?"))
        ui.popFont()
    end

    ui.separator()

    -- Idle hint
    if mode == "idle" then
        ui.pushFont(ui.Font.Tiny)
        ui.text("Drive to a \xF0\x9F\x85\xBF PA and use")
        ui.text("Start Race \xe2\x96\xba Point to Point")
        ui.text("or type /scramble in chat.")
        ui.popFont()
        ui.dummy(vec2(0, 2))
    end

    if ui.button("  \xe2\x96\xba Start Race...", vec2(-1, 0)) then
        PANEL.view = "type_select"; PANEL.selDest = ""; PANEL.selRoute = ""; PANEL.selMouseName = ""
    end
    if mode ~= "idle" then
        if ui.button("  \xe2\x96\xa0 Stop / Clear GPS", vec2(-1, 0)) then
            broadcast("!scramble clear", { type="clear", params={"clear"} })
            close = true
        end
    end

    -- Map zoom controls (buttons work here since this is a proper ImGui panel)
    ui.separator()
    ui.pushFont(ui.Font.Tiny)
    ui.textColored("Map zoom  (or use  [  ]  keys)", rgbm(.7,.7,.7,1))
    ui.popFont()
    ui.dummy(vec2(0, 2))
    if ui.button("  -  Zoom out", vec2(-1, 0)) then
        GPS_ZOOM = clamp(GPS_ZOOM - 0.2, 0.4, 3.0); saveGpsPlacement()
    end
    if ui.button("  +  Zoom in",  vec2(-1, 0)) then
        GPS_ZOOM = clamp(GPS_ZOOM + 0.2, 0.4, 3.0); saveGpsPlacement()
    end
    ui.pushFont(ui.Font.Tiny)
    ui.textColored(string.format("Current: %.1fx", GPS_ZOOM), rgbm(.7,.7,.7,1))
    ui.popFont()

    ui.separator()
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

local function showTypeSelect()
    local close = false
    ui.pushFont(ui.Font.Small); ui.text("Select Race Type:"); ui.popFont()
    ui.separator()
    if ui.button("  \xF0\x9F\x8F\x81  Point to Point",  vec2(-1, 0)) then
        PANEL.view = "start_race"
    end
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

local function showStartRace()
    local close = false
    ui.pushFont(ui.Font.Small)
    ui.textColored("\xF0\x9F\x8F\x81 Point to Point Race", rgbm(1, 0.4, 0.4, 1))
    ui.popFont()
    ui.separator()

    if #startAreaNames > 0 then
        ui.pushFont(ui.Font.Tiny)
        ui.text("Drive to one of these parking areas,")
        ui.text("then click Start when you're parked.")
        ui.popFont()
        ui.dummy(vec2(0, 4))
        for _, name in ipairs(startAreaNames) do
            ui.pushFont(ui.Font.Small)
            ui.textColored("\xF0\x9F\x85\xBF  " .. name, rgbm(0.95, 0.85, 0.3, 1))
            ui.popFont()
        end
        ui.separator()
        if ui.button("  \xe2\x9c\x85  I'm parked \xe2\x80\x94 Start Race!", vec2(-1, 0)) then
            if type(ac.sendChatMessage) == "function" then
                ac.sendChatMessage("/scramble")
            end
            PANEL.view = "main"
            return true
        end
    else
        ui.pushFont(ui.Font.Tiny)
        ui.text("No starting areas are configured for this map.")
        ui.popFont()
    end

    ui.separator()
    if ui.button("  Back",  vec2(-1, 0)) then PANEL.view = "type_select" end
    if ui.button("  Close", vec2(-1, 0)) then close = true end
    return close
end

-- ── [8] registerOnlineExtra DISPATCHER ───────────────────

local _icon = (ui.Icons and (ui.Icons.Navigation or ui.Icons.Leaderboard)) or 0
ui.registerOnlineExtra(_icon, "Scramble GPS", function() return true end, function()
    local v = PANEL.view
    if     v == "main"          then return showMain()
    elseif v == "type_select"   then return showTypeSelect()
    elseif v == "start_race"    then return showStartRace()
    elseif v == "config_convoy" then return showConfigDest("convoy", "\xF0\x9F\x9A\x97 Convoy / Cruise", .2, .9, .55)
    elseif v == "config_lap"    then return showConfigLap()
    elseif v == "config_cm"     then return showConfigCM()
    else return showMain() end
end)

-- ── [9] HUD HELPERS ──────────────────────────────────────

local function screenSize()
    local u = ac.getUI and ac.getUI()
    return (u and u.windowSize.x or 1920), (u and u.windowSize.y or 1080)
end

local function clamp(v, lo, hi)
    return math.max(lo, math.min(hi, v))
end

local function fmtDist(d)
    return d >= 1000 and string.format("%.1f km", d/1000) or string.format("%d m", math.floor(d+.5))
end

local function nowMs()
    if RACE.raceStartsAt and RACE.raceStartsAt > 1000000000000 then
        return os.time() * 1000
    end
    return os.clock() * 1000
end

-- ── GPS compass position ─────────────────────────────────────

local GPS_R        = 54   -- compass circle radius
local GPS_POS      = nil  -- vec2; nil until first update tick
local GPS_ZOOM     = 1.0
local _zoomKeyTimer = 0   -- debounce for [ / ] zoom keys

local function _gpsDefault()
    local sx, sy = screenSize()
    return vec2(sx - 165, sy - 180)  -- centre of the larger panel, near bottom-right
end

local function _gpsInit()
    if GPS_POS then return end
    local x = ac.storage.scrambleGpsX
    local y = ac.storage.scrambleGpsY
    local z = ac.storage.scrambleGpsZoom
    if type(x) == "number" and x > 0 then
        GPS_POS = vec2(x, y)
    else
        GPS_POS = _gpsDefault()
    end
    if type(z) == "number" and z > 0 then
        GPS_ZOOM = clamp(z, 0.65, 2.2)
    end
end

local MAP_SIZE     = 260   -- side length of the minimap panel in pixels
local _mapViewRng  = 3000  -- current (smoothed) metres from player to panel edge

local function saveGpsPlacement()
    ac.storage.scrambleGpsX = GPS_POS.x
    ac.storage.scrambleGpsY = GPS_POS.y
    ac.storage.scrambleGpsZoom = GPS_ZOOM
end

local function nudgeGps(dx, dy)
    local sx, sy = screenSize()
    local half = MAP_SIZE * 0.5
    GPS_POS = vec2(
        clamp(GPS_POS.x + dx, half + 4, sx - half - 4),
        clamp(GPS_POS.y + dy, half + 4, sy - half - 4))
    saveGpsPlacement()
end

local function drawGpsControls(tl, br, alpha)
    if type(ui.button) ~= "function" then return end

    local bw, bh = 24, 22

    -- Nudge arrows (visual only — clicks handled via IO in drawMinimap)
    local mx = tl.x + 8
    local my = br.y - 94
    ui.setCursor(vec2(mx + 26, my))      ui.button("^##scrambleGpsUp",    vec2(bw, bh))
    ui.setCursor(vec2(mx,      my + 24)) ui.button("<##scrambleGpsLeft",  vec2(bw, bh))
    ui.setCursor(vec2(mx + 52, my + 24)) ui.button(">##scrambleGpsRight", vec2(bw, bh))
    ui.setCursor(vec2(mx + 26, my + 48)) ui.button("v##scrambleGpsDown",  vec2(bw, bh))

    -- Zoom level display (top-right corner)
    ui.setCursor(vec2(br.x - 44, tl.y + 6))
    ui.pushFont(ui.Font.Tiny)
    ui.textColored(string.format("%.1fx", GPS_ZOOM), rgbm(1, 1, 1, 0.55 * alpha))
    ui.popFont()
end

local function routeDistanceFrom(car)
    if not RACE.dest then return 0 end
    if #RACE.gpsRoute <= 0 then return (car.position - RACE.dest):length() end

    local total = 0
    local last = car.position
    for i = RACE.gpsRouteIdx, #RACE.gpsRoute do
        local wp = destinations[RACE.gpsRoute[i]]
        if wp then
            total = total + (last - wp):length()
            last = wp
        end
    end
    if RACE.gpsRoute[#RACE.gpsRoute] ~= RACE.destName then
        total = total + (last - RACE.dest):length()
    end
    return total
end

local function activeTarget()
    if #RACE.gpsRoute > 0 then
        local name = RACE.gpsRoute[RACE.gpsRouteIdx]
        local pos = name and destinations[name]
        if pos then return pos, name, RACE.gpsRouteIdx >= #RACE.gpsRoute end
    end
    return RACE.dest, RACE.destName, true
end

local function drawPlayerMarker(cx, cy, look, alpha)
    local len = math.sqrt(look.x * look.x + look.z * look.z)
    if len < 0.001 then len = 1 end
    local sx, sy = look.x / len, look.z / len
    local px, py = -sy, sx
    local center = vec2(cx, cy)
    local nose = vec2(cx + sx * 19, cy + sy * 19)
    local leftWing = vec2(cx - sx * 11 + px * 11, cy - sy * 11 + py * 11)
    local rightWing = vec2(cx - sx * 11 - px * 11, cy - sy * 11 - py * 11)
    local tail = vec2(cx - sx * 4, cy - sy * 4)

    ui.drawCircleFilled(center, 20, rgbm(0, 0, 0, 0.52 * alpha), 24)
    ui.drawTriangleFilled(
        vec2(nose.x + sx * 2, nose.y + sy * 2),
        vec2(leftWing.x - sx * 2 + px * 2, leftWing.y - sy * 2 + py * 2),
        vec2(rightWing.x - sx * 2 - px * 2, rightWing.y - sy * 2 - py * 2),
        rgbm(0, 0, 0, 0.85 * alpha))
    ui.drawTriangleFilled(nose, leftWing, rightWing, rgbm(0.14, 0.95, 0.38, 0.98 * alpha))
    ui.drawTriangleFilled(
        vec2(cx + sx * 7, cy + sy * 7),
        vec2(tail.x + px * 6, tail.y + py * 6),
        vec2(tail.x - px * 6, tail.y - py * 6),
        rgbm(0.9, 1, 0.95, 0.95 * alpha))
    ui.drawCircleFilled(center, 3, rgbm(0, 0, 0, 0.55 * alpha), 8)
end

-- GPS minimap: player always centred, map scrolls underneath, dynamic zoom.
-- Returns false ONLY when tracksDir couldn't be found (falls back to compass).
local function drawMinimap(car, mode, alpha)
    if MAP_INFO.path == false          then return false end
    if type(MAP_INFO.path) ~= "string" then return false end

    -- ── Dynamic zoom: smoothly track distance to next waypoint ────────────────
    local maxRng = mapCfg.mapViewRange or 8000
    local nextPos, nextWp, isFinalTarget = activeTarget()
    local targetRng
    if nextPos then
        local d = math.sqrt((car.position.x - nextPos.x)^2 +
                             (car.position.z - nextPos.z)^2)
        targetRng = clamp(d * 0.85, 220, maxRng)
    elseif RACE.dest then
        local d = math.sqrt((car.position.x - RACE.dest.x)^2 +
                             (car.position.z - RACE.dest.z)^2)
        targetRng = clamp(d * 0.85, 220, maxRng)
    else
        targetRng = maxRng
    end
    _mapViewRng = _mapViewRng + (targetRng - _mapViewRng) * 0.03  -- smooth lerp

    local cx, cy = GPS_POS.x, GPS_POS.y
    local half   = MAP_SIZE * 0.5
    local tl     = vec2(cx - half, cy - half)
    local br     = vec2(cx + half, cy + half)
    -- GPS_ZOOM applied directly to ppm for instant visual effect (not through the lerp)
    local ppm    = (half / _mapViewRng) * GPS_ZOOM

    -- World pos → screen pos (player always at cx, cy)
    local px, pz = car.position.x, car.position.z
    local function w2s(wpos)
        return vec2(cx + (wpos.x - px) * ppm, cy + (wpos.z - pz) * ppm)
    end

    -- Edge-indicator arrow for a point that may be off-screen
    local function edgeArrow(sp, r, g, b, a2)
        local dx, dz = sp.x - cx, sp.y - cy
        if math.abs(dx) < half - 8 and math.abs(dz) < half - 8 then return end
        local t  = (half - 8) / math.max(math.abs(dx), math.abs(dz))
        local ex, ey = cx + dx * t, cy + dz * t
        local ang = math.atan2(dz, dx)
        local s, c = math.sin(ang), math.cos(ang)
        ui.drawTriangleFilled(
            vec2(ex + c * 9,          ey + s * 9),
            vec2(ex - c * 5 - s * 7, ey - s * 5 + c * 7),
            vec2(ex - c * 5 + s * 7, ey - s * 5 - c * 7),
            rgbm(r, g, b, a2 * alpha))
    end

    -- ── Background ────────────────────────────────────────────────────────────
    ui.drawRectFilled(tl, br, rgbm(0.025, 0.035, 0.045, 0.94 * alpha))
    ui.drawRectFilled(tl, vec2(br.x, tl.y + 46), rgbm(0, 0, 0, 0.62 * alpha))

    local hasClip = type(ui.pushClipRect) == "function"
    if hasClip then ui.pushClipRect(tl, br) end

    -- ── Map texture (needs iniParsed so we know where to place it) ────────────
    if MAP_INFO.iniParsed then
        local mapWorldW  = MAP_INFO.imgW * MAP_INFO.scale
        local mapWorldH  = MAP_INFO.imgH * MAP_INFO.scale
        local imgTL = vec2(cx + (-MAP_INFO.xOff - px) * ppm,
                           cy + (-MAP_INFO.zOff - pz) * ppm)
        local imgBR = vec2(imgTL.x + mapWorldW * ppm, imgTL.y + mapWorldH * ppm)
        ui.drawImage(MAP_INFO.path, imgTL, imgBR, rgbm(1, 1, 1, 0.72 * alpha))
    end

    ui.drawLine(vec2(cx - 18, cy), vec2(cx - 8, cy), rgbm(1, 1, 1, 0.2 * alpha), 1)
    ui.drawLine(vec2(cx + 8, cy), vec2(cx + 18, cy), rgbm(1, 1, 1, 0.2 * alpha), 1)
    ui.drawLine(vec2(cx, cy - 18), vec2(cx, cy - 8), rgbm(1, 1, 1, 0.2 * alpha), 1)
    ui.drawLine(vec2(cx, cy + 8), vec2(cx, cy + 18), rgbm(1, 1, 1, 0.2 * alpha), 1)

    -- ── Route line ────────────────────────────────────────────────────────────
    if #RACE.gpsRoute > 1 then
        for i = 1, #RACE.gpsRoute - 1 do
            local a = destinations[RACE.gpsRoute[i]]
            local b = destinations[RACE.gpsRoute[i + 1]]
            if a and b then
                ui.drawLine(w2s(a), w2s(b), rgbm(0, 0, 0, 0.65 * alpha), 8)
                ui.drawLine(w2s(a), w2s(b), rgbm(1, 0.82, 0.12, 0.95 * alpha), 4)
            end
        end
        -- Waypoint dots (intermediate only)
        for i = 1, #RACE.gpsRoute - 1 do
            local wp = destinations[RACE.gpsRoute[i]]
            if wp then
                ui.drawCircleFilled(w2s(wp), 7, rgbm(0, 0, 0, 0.65 * alpha), 12)
                ui.drawCircleFilled(w2s(wp), 4, rgbm(1, 0.85, 0.1, 0.95 * alpha), 10)
            end
        end
    end

    -- ── Destination marker + off-screen edge arrow ────────────────────────────
    if RACE.dest then
        local pulse = 0.65 + 0.35 * math.abs(math.sin(os.clock() * 2.5))
        local dp    = w2s(RACE.dest)
        ui.drawCircleFilled(dp, 9, rgbm(1, 0.1, 0.1, pulse * alpha), 14)
        ui.drawCircle(dp,       9, rgbm(1, 1,   1,   0.9 * alpha),   14, 2)
        ui.drawCircleFilled(dp, 4, rgbm(1, 1,   1,   alpha),         8)
        edgeArrow(dp, 1, 0.2, 0.2, pulse)
    end

    -- ── Next-waypoint edge arrow (gold, only when off-screen) ─────────────────
    if nextPos then
        edgeArrow(w2s(nextPos), 1, 0.85, 0, 0.9)
    end

    if hasClip then ui.popClipRect() end

    -- ── Player: white dot + green heading arrow (never clipped) ──────────────
    drawPlayerMarker(cx, cy, car.look, alpha)

    -- ── Compass N ────────────────────────────────────────────────────────────
    ui.setCursor(vec2(cx - 5, tl.y + 6))
    ui.pushFont(ui.Font.Tiny)
    ui.textColored("N", rgbm(0.8, 0.8, 0.8, 0.55 * alpha))
    ui.popFont()

    -- ── Panel border ──────────────────────────────────────────────────────────
    ui.drawRect(tl, br, rgbm(0.55, 0.62, 0.7, 0.7 * alpha), 2)
    drawGpsControls(tl, br, alpha)

    -- ── Next-waypoint banner above panel ──────────────────────────────────────
    if nextPos then
        local ndist  = fmtDist(math.sqrt((px - nextPos.x)^2 + (pz - nextPos.z)^2))
        local banner = (isFinalTarget and "FINISH" or "FOLLOW ROUTE") .. "  |  " .. ndist
        ui.setCursor(vec2(tl.x + 8, tl.y + 8))
        ui.pushFont(ui.Font.Small)
        ui.textColored(banner, rgbm(1, 0.9, 0.25, 0.98 * alpha))
        ui.popFont()
        if nextWp and nextWp ~= "" then
            ui.setCursor(vec2(tl.x + 8, tl.y + 28))
            ui.pushFont(ui.Font.Tiny)
            ui.textColored((isFinalTarget and "FINISH: " or "NEXT: ") .. nextWp, rgbm(1, 1, 1, 0.8 * alpha))
            ui.popFont()
        end
    end

    -- ── Destination name + total distance below panel ─────────────────────────
    local icon  = (mode == "convoy") and "\xF0\x9F\x9A\x97 " or "\xF0\x9F\x8F\x81 "
    local label = icon .. RACE.destName
    local dist  = RACE.dest and fmtDist(routeDistanceFrom(car)) or ""
    ui.drawRectFilled(vec2(tl.x, br.y - 42), br, rgbm(0, 0, 0, 0.62 * alpha))
    ui.setCursor(vec2(tl.x + 8, br.y - 38))
    ui.pushFont(ui.Font.Small)
    ui.textAligned(label, vec2(0, 0), vec2(MAP_SIZE - 16, 18))
    ui.popFont()
    ui.setCursor(vec2(tl.x + 8, br.y - 20))
    ui.pushFont(ui.Font.Small)
    ui.textColored(dist .. " remaining", rgbm(1, 0.9, 0.25, 0.95 * alpha))
    ui.popFont()

    return true
end

local function drawArrow(car, target, cr, cg, cb, alpha)
    local cx, cy, r = GPS_POS.x, GPS_POS.y, GPS_R

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
    local car = ac.getCar(0)
    if not car then return end

    local alpha = RACE.fadeAlpha
    if alpha < 0.01 then return end

    -- During accept window / countdown: show timer at compass position instead of GPS arrow
    if RACE.serverControlled and RACE.raceStartsAt > 0 then
        local remain = math.max(0, (RACE.raceStartsAt - nowMs()) / 1000)
        if remain > 0 then
            local cx, cy, r = GPS_POS.x, GPS_POS.y, GPS_R
            local secs = math.ceil(remain)
            ui.drawCircleFilled(vec2(cx, cy), r + 6, rgbm(0, 0, 0, 0.65 * alpha), 40)
            ui.drawCircle(vec2(cx, cy), r + 6, rgbm(1, 0.8, 0, 0.9 * alpha), 40, 2)
            ui.setCursor(vec2(cx - r - 6, cy - r - 6))
            ui.pushFont(ui.Font.Title)
            ui.textAligned(tostring(secs), vec2(0.5, 0.5), vec2((r + 6) * 2, (r + 6) * 2))
            ui.popFont()
            drawLabels(cx, cy, r, RACE.destName, "WAITING...", alpha)
            return
        end
    end

    local mode = RACE.mode

    if mode == "p2p" then
        if not drawMinimap(car, "p2p", alpha) then
            -- Fallback: compass arrow when map PNG not available
            local target, label
            if #RACE.gpsRoute > 0 then
                local wpName = RACE.gpsRoute[RACE.gpsRouteIdx]
                local wpPos  = destinations[wpName]
                local isLast = (RACE.gpsRouteIdx >= #RACE.gpsRoute)
                if wpPos then target = wpPos; label = isLast and RACE.destName or wpName end
            end
            if not target then target = RACE.dest; label = RACE.destName end
            if target then
                local cx, cy, r = drawArrow(car, target, 1, .2, .2, alpha)
                drawLabels(cx, cy, r, label, fmtDist((car.position - target):length()), alpha)
            end
        end

    elseif mode == "convoy" then
        if not drawMinimap(car, "convoy", alpha) then
            -- Fallback: compass arrow when map PNG not available
            local target, label
            if #RACE.gpsRoute > 0 then
                local wpName = RACE.gpsRoute[RACE.gpsRouteIdx]
                local wpPos  = destinations[wpName]
                local isLast = (RACE.gpsRouteIdx >= #RACE.gpsRoute)
                if wpPos then target = wpPos; label = "\xF0\x9F\x9A\x97 " .. (isLast and RACE.destName or wpName) end
            end
            if not target then target = RACE.dest; label = "\xF0\x9F\x9A\x97 " .. RACE.destName end
            if target then
                local cx, cy, r = drawArrow(car, target, .2, .9, .55, alpha)
                drawLabels(cx, cy, r, label, fmtDist((car.position - target):length()), alpha)
            end
        end

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

    local finalDist = RACE.serverControlled and RACE.destRadius or ARRIVAL_DIST

    -- ── Route waypoint advancement ────────────────────────────────────────────
    if #RACE.gpsRoute > 0 then
        local wpName = RACE.gpsRoute[RACE.gpsRouteIdx]
        local wpPos  = destinations[wpName]
        if wpPos then
            local isLast  = (RACE.gpsRouteIdx >= #RACE.gpsRoute)
            local thresh  = isLast and finalDist or math.max(200, finalDist * 0.6)
            local d       = (car.position - wpPos):length()
            if d < thresh then
                if isLast then
                    -- Final waypoint reached
                    if RACE.serverControlled then return end
                    if type(ac.sendChatMessage) == "function" and RACE.destName ~= "" then
                        ac.sendChatMessage("\xF0\x9F\x8F\x81 " .. localName() ..
                            " arrived at " .. RACE.destName .. "!")
                    end
                    clearRace()
                else
                    RACE.gpsRouteIdx = RACE.gpsRouteIdx + 1
                end
            end
        else
            -- Waypoint missing from local destinations — skip ahead
            if RACE.gpsRouteIdx < #RACE.gpsRoute then
                RACE.gpsRouteIdx = RACE.gpsRouteIdx + 1
            end
        end
        return
    end

    -- ── Fallback: no route — straight-line arrival check ─────────────────────
    if (car.position - RACE.dest):length() < finalDist then
        if RACE.serverControlled then return end
        if type(ac.sendChatMessage) == "function" and RACE.destName ~= "" then
            ac.sendChatMessage("\xF0\x9F\x8F\x81 " .. localName() ..
                " arrived at " .. RACE.destName .. "!")
        end
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

    _gpsInit()
    _roadGraphInit()
    _loadMapInfo()

    -- ── Keyboard zoom: [ = zoom out, ] = zoom in ──────────────────────────────
    _zoomKeyTimer = math.max(0, _zoomKeyTimer - dt)
    if _zoomKeyTimer <= 0 and GPS_POS then
        local zi, zo = false, false
        pcall(function()
            if type(ac.isKeyDown) == "function" then
                zi = ac.isKeyDown(221)  -- ] key (VK_OEM_6)
                zo = ac.isKeyDown(219)  -- [ key (VK_OEM_4)
            end
        end)
        if zi then
            GPS_ZOOM = clamp(GPS_ZOOM + 0.15, 0.4, 3.0); saveGpsPlacement(); _zoomKeyTimer = 0.2
        elseif zo then
            GPS_ZOOM = clamp(GPS_ZOOM - 0.15, 0.4, 3.0); saveGpsPlacement(); _zoomKeyTimer = 0.2
        end
    end

    local mode = RACE.mode
    if mode == "idle" then return end
    local car = ac.getCar(0)
    if not car then return end
    if mode == "p2p" or mode == "convoy" then updateP2P(car)
    elseif mode == "lap"                 then updateLap(car)
    end
    -- catmouse: no arrival check, ends via !scramble clear from admin
end
