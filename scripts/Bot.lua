-- bot.lua
local BotAI = {}

-- Вспомогательная функция знака числа
local function sign(x)
    if x < 0 then return -1 end
    if x > 0 then return 1 end
    return 0
end

local DIRS = {{0,1}, {0,-1}, {1,0}, {-1,0}}

-- ВРЕМЕННЫЙ DEBUG ЛОГ. Удали этот блок и все вызовы DBG(...) после диагностики.
local DEBUG_BOT = true
local function DBG(fmt, ...)
    if not DEBUG_BOT then return end
    local logFile = io.open("bot_debug.log", "a")
    if logFile then
        logFile:write(fmt:format(...) .. "\n")
        logFile:close()
    end
end

-- ============================================================
-- БОМБЫ И ЦЕПНАЯ РЕАКЦИЯ
-- ============================================================

-- Считает множество "опасных" клеток с учётом цепной реакции бомб.
-- bombs: массив {gx, gy, fireRadius}
-- Возвращает таблицу dangerSet[key] = true, где key = "gy_gx"
local function computeDangerSet(bombs, map)
    local dangerSet = {}

    local function markLine(gx, gy, dx, dy, radius)
        local key = gy .. "_" .. gx
        dangerSet[key] = true
        for step = 1, radius do
            local nx, ny = gx + dx * step, gy + dy * step
            if not map[ny] then break end
            local tile = map[ny][nx]
            if tile == nil then break end
            dangerSet[ny .. "_" .. nx] = true
            -- Огонь не проходит сквозь неразрушимые блоки (1).
            -- Разрушаемые ящики (2) останавливают огонь, но клетка сама помечается опасной (уже сделано выше).
            if tile == 1 then break end
            if tile == 2 then break end
        end
    end

    -- На первом проходе помечаем зоны действия каждой бомбы по её собственному радиусу
    for _, b in ipairs(bombs) do
        markLine(b.gx, b.gy, 0, -1, b.fireRadius)
        markLine(b.gx, b.gy, 0, 1, b.fireRadius)
        markLine(b.gx, b.gy, -1, 0, b.fireRadius)
        markLine(b.gx, b.gy, 1, 0, b.fireRadius)
    end

    -- Цепная реакция: если в зоне поражения одной бомбы оказалась другая бомба,
    -- то она тоже взорвётся - помечаем и её зону. Повторяем, пока не стабилизируется.
    local changed = true
    local iterations = 0
    while changed and iterations < 10 do
        changed = false
        iterations = iterations + 1
        for _, b in ipairs(bombs) do
            local key = b.gy .. "_" .. b.gx
            if dangerSet[key] and not b._chainMarked then
                b._chainMarked = true
                markLine(b.gx, b.gy, 0, -1, b.fireRadius)
                markLine(b.gx, b.gy, 0, 1, b.fireRadius)
                markLine(b.gx, b.gy, -1, 0, b.fireRadius)
                markLine(b.gx, b.gy, 1, 0, b.fireRadius)
                changed = true
            end
        end
    end

    -- Сбрасываем временный флаг, чтобы не влиять на следующий вызов
    for _, b in ipairs(bombs) do b._chainMarked = nil end

    return dangerSet
end

-- Проверка опасности конкретной клетки с учётом цепной реакции
local function isTileDangerous(gx, gy, dangerSet)
    return dangerSet[gy .. "_" .. gx] == true
end

-- Проверка: стоит ли на клетке (gx,gy) бомба (любая, кроме клетки, где сейчас стоит сам бот -
-- по правилам игры со своей бомбы можно сойти, но вернуться на неё уже нельзя, поэтому
-- для целей планирования пути бомба ВСЕГДА считается препятствием)
local function isBombAt(gx, gy, bombs)
    for _, b in ipairs(bombs) do
        if b.gx == gx and b.gy == gy then return true end
    end
    return false
end

-- ============================================================
-- ТУПИКИ
-- ============================================================

-- Проверка: является ли клетка (nx,ny) тупиком относительно клетки, из которой пришли (fromX, fromY).
-- Тупик = нет других проходимых (map==0 или ==3) соседей, кроме (fromX,fromY).
local function isDeadEnd(nx, ny, fromX, fromY, map)
    for _, d in ipairs(DIRS) do
        local ax, ay = nx + d[1], ny + d[2]
        if not (ax == fromX and ay == fromY) then
            if map[ay] and (map[ay][ax] == 0 or map[ay][ax] == 3) then
                return false
            end
        end
    end
    return true
end

-- ============================================================
-- ДРУГИЕ БОТЫ / ИГРОКИ (АНТИКОЛЛИЗИЯ)
-- ============================================================

-- Строит множество клеток, "забронированных" другими ботами в этом кадре
-- (их текущая клетка + клетка, куда они направляются), чтобы боты не толкались
-- и не выбирали одну и ту же клетку одновременно.
local function buildReservedSet(botData, allPlayers, TILE_SIZE)
    local reserved = {}
    if not allPlayers then return reserved end

    for _, other in ipairs(allPlayers) do
        if other ~= botData and other.playing then
            local ox = math.floor((other.x + TILE_SIZE / 2) / TILE_SIZE) + 1
            local oy = math.floor((other.y + TILE_SIZE / 2) / TILE_SIZE) + 1
            reserved[oy .. "_" .. ox] = true

            if other.targetGridX and other.targetGridY then
                reserved[other.targetGridY .. "_" .. other.targetGridX] = true
            end
        end
    end

    return reserved
end

local function isReserved(gx, gy, reserved)
    return reserved[gy .. "_" .. gx] == true
end

-- ============================================================
-- ПОИСК БЕЗОПАСНОЙ КЛЕТКИ
-- ============================================================

-- Поиск безопасной клетки для побега.
-- reserved: опционально, множество клеток занятых другими ботами (избегаем, но не критично)
-- bombs: массив бомб {gx,gy,fireRadius} - клетки с бомбами непроходимы для планирования
local function findSafeTile(sx, sy, map, dangerSet, reserved, bombs)
    reserved = reserved or {}
    bombs = bombs or {}

    local function tileOk(nx, ny)
        if not map[ny] then return false end
        local t = map[ny][nx]
        if not (t == 0 or t == 3) then return false end
        if isBombAt(nx, ny, bombs) then return false end
        return true
    end

    -- Сначала прямые соседи, исключая тупики и опасные клетки.
    -- Приоритет: безопасно + не тупик + не занято другим ботом
    local deadEndCandidate = nil
    local reservedCandidate = nil
    for _, d in ipairs(DIRS) do
        local nx, ny = sx + d[1], sy + d[2]
        if tileOk(nx, ny) and not isTileDangerous(nx, ny, dangerSet) then
            local deadEnd = isDeadEnd(nx, ny, sx, sy, map)
            local taken = isReserved(nx, ny, reserved)
            if not deadEnd and not taken then
                return nx, ny
            elseif not deadEnd and taken and not reservedCandidate then
                reservedCandidate = {x = nx, y = ny}
            elseif deadEnd and not deadEndCandidate then
                deadEndCandidate = {x = nx, y = ny}
            end
        end
    end

    -- BFS fallback: ищем путь до клетки вне danger-зоны, возвращаем ПЕРВЫЙ ШАГ пути,
    -- чтобы цель была ортогональным соседом (бот двигается по одной оси за раз).
    local function bfsSearch(avoidDeadEnds, avoidReserved)
        local queue = {}
        local visited = {[sy.."_"..sx] = true}
        for _, d in ipairs(DIRS) do
            local nx, ny = sx + d[1], sy + d[2]
            local key = ny.."_"..nx
            if tileOk(nx, ny) and not visited[key] then
                visited[key] = true
                local skip = false
                if avoidDeadEnds and isDeadEnd(nx, ny, sx, sy, map) then skip = true end
                if avoidReserved and isReserved(nx, ny, reserved) then skip = true end
                if not skip then
                    table.insert(queue, {x = nx, y = ny, firstX = nx, firstY = ny, dist = 1})
                end
            end
        end

        while #queue > 0 do
            local cur = table.remove(queue, 1)
            if not isTileDangerous(cur.x, cur.y, dangerSet) then
                return cur.firstX, cur.firstY
            end
            if cur.dist < 6 then
                for _, d in ipairs(DIRS) do
                    local nx, ny = cur.x + d[1], cur.y + d[2]
                    local key = ny.."_"..nx
                    if tileOk(nx, ny) and not visited[key] then
                        visited[key] = true
                        table.insert(queue, {x = nx, y = ny, firstX = cur.firstX, firstY = cur.firstY, dist = cur.dist + 1})
                    end
                end
            end
        end
        return nil, nil
    end

    -- Порядок попыток: без тупиков и без занятых клеток -> без тупиков -> без занятых -> любой
    local sx2, sy2 = bfsSearch(true, true)
    if sx2 then return sx2, sy2 end

    sx2, sy2 = bfsSearch(true, false)
    if sx2 then return sx2, sy2 end

    sx2, sy2 = bfsSearch(false, true)
    if sx2 then return sx2, sy2 end

    sx2, sy2 = bfsSearch(false, false)
    if sx2 then return sx2, sy2 end

    -- Совсем ничего: вернуть тупик/занятую клетку, если она хотя бы безопасна сейчас
    if reservedCandidate then return reservedCandidate.x, reservedCandidate.y end
    if deadEndCandidate then return deadEndCandidate.x, deadEndCandidate.y end

    return nil, nil
end

-- ============================================================
-- BFS ОБЩЕГО НАЗНАЧЕНИЯ: ПОИСК БЛИЖАЙШЕЙ КЛЕТКИ ПО ПРЕДИКАТУ
-- ============================================================

-- targetPredicate(gx, gy) -> true, если клетка является целью
-- Возвращает координаты клетки-цели (не первый шаг!), либо nil
local function bfsFindTarget(sx, sy, map, dangerSet, targetPredicate, maxDist, bombs)
    bombs = bombs or {}
    maxDist = maxDist or 30
    local queue = {{x = sx, y = sy, dist = 0}}
    local visited = {[sy.."_"..sx] = true}

    while #queue > 0 do
        local cur = table.remove(queue, 1)

        if cur.dist > 0 and targetPredicate(cur.x, cur.y) and not isTileDangerous(cur.x, cur.y, dangerSet) then
            return cur.x, cur.y, cur.dist
        end

        if cur.dist < maxDist then
            for _, d in ipairs(DIRS) do
                local nx, ny = cur.x + d[1], cur.y + d[2]
                local key = ny.."_"..nx
                if map[ny] and (map[ny][nx] == 0 or map[ny][nx] == 3) and not visited[key] and not isBombAt(nx, ny, bombs) then
                    visited[key] = true
                    table.insert(queue, {x = nx, y = ny, dist = cur.dist + 1})
                end
            end
        end
    end
    return nil, nil, nil
end

-- Возвращает первый шаг (соседнюю клетку) на пути от (sx,sy) к (tx,ty) через BFS.
-- Это позволяет двигаться к цели по одной клетке, не нарушая систему движения по осям X/Y.
local function bfsFirstStepTowards(sx, sy, tx, ty, map, dangerSet, bombs)
    bombs = bombs or {}
    if sx == tx and sy == ty then return nil, nil end

    local queue = {}
    local visited = {[sy.."_"..sx] = true}
    for _, d in ipairs(DIRS) do
        local nx, ny = sx + d[1], sy + d[2]
        local key = ny.."_"..nx
        if map[ny] and (map[ny][nx] == 0 or map[ny][nx] == 3) and not visited[key] and not isBombAt(nx, ny, bombs) then
            visited[key] = true
            table.insert(queue, {x = nx, y = ny, firstX = nx, firstY = ny, dist = 1})
        end
    end

    while #queue > 0 do
        local cur = table.remove(queue, 1)
        if cur.x == tx and cur.y == ty then
            return cur.firstX, cur.firstY
        end
        if cur.dist < 30 then
            for _, d in ipairs(DIRS) do
                local nx, ny = cur.x + d[1], cur.y + d[2]
                local key = ny.."_"..nx
                if map[ny] and (map[ny][nx] == 0 or map[ny][nx] == 3) and not visited[key] and not isBombAt(nx, ny, bombs) then
                    visited[key] = true
                    table.insert(queue, {x = nx, y = ny, firstX = cur.firstX, firstY = cur.firstY, dist = cur.dist + 1})
                end
            end
        end
    end
    return nil, nil
end

-- ============================================================
-- ПОИСК БАФФОВ (С УЧЁТОМ ЧЕРЕПА)
-- ============================================================

-- Возвращает true, если клетка (gx,gy) содержит "плохой" бафф (череп)
local function getBuffAt(gx, gy, buffsList, TILE_SIZE)
    if not buffsList then return nil end
    for _, b in ipairs(buffsList) do
        if not b.isExploded then
            local bgx = math.floor(b.x / TILE_SIZE) + 1
            local bgy = math.floor(b.y / TILE_SIZE) + 1
            if bgx == gx and bgy == gy then
                return b
            end
        end
    end
    return nil
end

local function isSkullBuff(buff)
    return buff and buff.image == buff_skull_image
end

-- Поиск ближайшего ХОРОШЕГО баффа (map клетка == 3, и это не череп)
local function findNearestGoodBuff(sx, sy, map, dangerSet, buffsList, TILE_SIZE, bombs)
    return bfsFindTarget(sx, sy, map, dangerSet, function(gx, gy)
        if map[gy][gx] ~= 3 then return false end
        local b = getBuffAt(gx, gy, buffsList, TILE_SIZE)
        -- Если buffsList недоступен - считаем любой '3' хорошим (старое поведение)
        if not buffsList then return true end
        if not b then return true end
        return not isSkullBuff(b)
    end, 30, bombs)
end

-- Проверка: содержит ли клетка (gx,gy) бафф-череп
local function isSkullTile(gx, gy, map, buffsList, TILE_SIZE)
    if map[gy] and map[gy][gx] == 3 and buffsList then
        local b = getBuffAt(gx, gy, buffsList, TILE_SIZE)
        return isSkullBuff(b)
    end
    return false
end

-- ============================================================
-- ПОИСК ВРАГОВ
-- ============================================================

-- Находит ближайшего живого противника (любого другого игрока/бота)
-- Возвращает его grid-координаты и дистанцию, либо nil
local function findNearestEnemy(botData, sx, sy, allPlayers, TILE_SIZE)
    if not allPlayers then return nil, nil, nil end

    local best, bestDist = nil, math.huge
    for _, other in ipairs(allPlayers) do
        if other ~= botData and other.playing then
            local ogx = math.floor((other.x + TILE_SIZE / 2) / TILE_SIZE) + 1
            local ogy = math.floor((other.y + TILE_SIZE / 2) / TILE_SIZE) + 1
            local dist = math.abs(ogx - sx) + math.abs(ogy - sy)
            if dist < bestDist then
                bestDist = dist
                best = {x = ogx, y = ogy}
            end
        end
    end

    if best then return best.x, best.y, bestDist end
    return nil, nil, nil
end

-- ============================================================
-- ПОИСК ЯЩИКОВ / ВРАГОВ ДЛЯ ВЗРЫВА
-- ============================================================

-- Проверка соседнего ящика для взрыва
local function findAdjacentCrate(sx, sy, map)
    for _, d in ipairs(DIRS) do
        local nx, ny = sx + d[1], sy + d[2]
        if map[ny] and map[ny][nx] == 2 then
            return true
        end
    end
    return false
end

-- Проверка: стоит ли враг на расстоянии fireRadius от (sx,sy) по прямой линии
-- (т.е. бомба, поставленная здесь, его заденет), без учёта блоков на пути (упрощение)
local function enemyInBlastLine(sx, sy, ex, ey, fireRadius, map)
    if sx == ex and sy == ey then return false end
    if sx ~= ex and sy ~= ey then return false end -- не на одной линии

    local dx, dy = 0, 0
    local dist = 0
    if sx == ex then
        dy = sign(ey - sy)
        dist = math.abs(ey - sy)
    else
        dx = sign(ex - sx)
        dist = math.abs(ex - sx)
    end

    if dist > fireRadius then return false end

    -- Проверяем, что между sx,sy и ex,ey нет блоков, останавливающих огонь
    for step = 1, dist do
        local cx, cy = sx + dx * step, sy + dy * step
        local tile = map[cy] and map[cy][cx]
        if tile == 1 then return false end
        if tile == 2 and (cx ~= ex or cy ~= ey) then return false end
        -- ящик на самой клетке врага - тоже блокирует, но это редкий случай (враг внутри ящика невозможен)
    end

    return true
end

-- ============================================================
-- ГЛАВНАЯ ФУНКЦИЯ ИИ
-- ============================================================

-- context (опционально): {
--   allPlayers = Players,       -- массив всех игроков/ботов для поиска врагов и антиколлизии
--   buffs = buffs,               -- массив баффов с .x,.y,.image,.isExploded для различения черепа
-- }
function BotAI.think(botData, dt, map, bombs, spawnBombCallback, context)
    if botData.death then return end

    context = context or {}
    local allPlayers = context.allPlayers
    local buffsList = context.buffs

    -- Используем размер клетки long из глобальной области видимости
    local TILE_SIZE = long or 80

    -- Вычисляем текущую клетку строго по пиксельному центру
    local currentGridX = math.floor((botData.x + TILE_SIZE / 2) / TILE_SIZE) + 1
    local currentGridY = math.floor((botData.y + TILE_SIZE / 2) / TILE_SIZE) + 1

    local botId = botData.id or botData.name or tostring(botData):sub(-6)
    DBG("bot=%s START x=%.1f y=%.1f gx=%d gy=%d", botId, botData.x, botData.y, currentGridX, currentGridY)

    local mapHeight = #map
    local mapWidth = map[1] and #map[1] or 15

    if currentGridX < 1 then currentGridX = 1 elseif currentGridX > mapWidth then currentGridX = mapWidth end
    if currentGridY < 1 then currentGridY = 1 elseif currentGridY > mapHeight then currentGridY = mapHeight end

    -- Инициализация целей бота
    if not botData.targetGridX then
        botData.targetGridX = currentGridX
        botData.targetGridY = currentGridY
        botData.aiTimer = 0
    end

    -- Цель в пикселях
    local targetPixelX = (botData.targetGridX - 1) * TILE_SIZE
    local targetPixelY = (botData.targetGridY - 1) * TILE_SIZE

    -- Шаг перемещения бота
    local moveStep = botData.speed * 60 * dt

    local arrivedX = false
    local arrivedY = false

    -- Движение по оси X
    if botData.x ~= targetPixelX then
        local dirX = sign(targetPixelX - botData.x)
        botData.direction = dirX > 0 and "right" or "left"

        if math.abs(botData.x - targetPixelX) <= moveStep then
            botData.x = targetPixelX
            arrivedX = true
        else
            botData.x = botData.x + dirX * moveStep
        end
    else
        arrivedX = true
    end

    -- Движение по оси Y (строго после выравнивания по X, исключает хождение по диагонали)
    if arrivedX then
        if botData.y ~= targetPixelY then
            local dirY = sign(targetPixelY - botData.y)
            botData.direction = dirY > 0 and "down" or "up"

            if math.abs(botData.y - targetPixelY) <= moveStep then
                botData.y = targetPixelY
                arrivedY = true
            else
                botData.y = botData.y + dirY * moveStep
            end
        else
            arrivedY = true
        end
    end

    DBG("bot=%s MOVE targetGX=%s targetGY=%s targetPX=%.1f targetPY=%.1f arrivedX=%s arrivedY=%s",
    botId, tostring(botData.targetGridX), tostring(botData.targetGridY),
    targetPixelX, targetPixelY, tostring(arrivedX), tostring(arrivedY))

    -- Если бот четко встал в пиксельный центр клетки
    if arrivedX and arrivedY then
        botData.aiTimer = botData.aiTimer + dt
        if botData.aiTimer > 0.01 then
            botData.aiTimer = 0

            local cx, cy = botData.targetGridX, botData.targetGridY
            local botId = botData.id or botData.name or tostring(botData):sub(-6)

            -- Предрасчёт: множество опасных клеток с учётом цепной реакции бомб
            local dangerSet = computeDangerSet(bombs, map)

            -- Множество клеток, занятых/выбранных другими ботами (для координации между ботами)
            local reserved = buildReservedSet(botData, allPlayers, TILE_SIZE)

            -- ============================================================
            -- 1. СПАСЕНИЕ ОТ ВЗРЫВОВ (включая цепную реакцию)
            -- ============================================================
            if isTileDangerous(cx, cy, dangerSet) then
                local sx, sy = findSafeTile(cx, cy, map, dangerSet, reserved, bombs)
                if sx then
                    botData.targetGridX = sx
                    botData.targetGridY = sy
                    DBG("bot=%s step=1a cx=%d cy=%d -> %d,%d", botId, cx, cy, sx, sy)
                    return
                else
                    -- Аварийный выход: идём на любую проходимую клетку, пусть и опасную, но без бомбы
                    for _, d in ipairs(DIRS) do
                        local nx, ny = cx + d[1], cy + d[2]
                        if map[ny] and (map[ny][nx] == 0 or map[ny][nx] == 3) and not isBombAt(nx, ny, bombs) then
                            botData.targetGridX = nx
                            botData.targetGridY = ny
                            DBG("bot=%s step=1b cx=%d cy=%d -> %d,%d (emergency)", botId, cx, cy, nx, ny)
                            return
                        end
                    end
                    DBG("bot=%s step=1c cx=%d cy=%d STUCK no exit", botId, cx, cy)
                end
            end

            -- ============================================================
            -- 2. АТАКА: если рядом враг - стараемся встать на линию выстрела
            --    и поставить бомбу, чтобы его задеть
            -- ============================================================
            local attackedOrAligning = false
            do
                local ex, ey, edist = findNearestEnemy(botData, cx, cy, allPlayers, TILE_SIZE)
                local fireRadius = botData.FIRE or 1

                -- Шаг 2 (выравнивание/атака) срабатывает только если путь к врагу не заблокирован ящиками
                local pathToEnemyExists = ex and (bfsFirstStepTowards(cx, cy, ex, ey, map, dangerSet, bombs) ~= nil)

                if ex and edist and edist <= fireRadius + 2 and pathToEnemyExists then
                    -- Враг в зоне досягаемости (с запасом в пару клеток)

                    if botData.BOMBS and botData.BOMBS > 0 and edist <= fireRadius
                       and enemyInBlastLine(cx, cy, ex, ey, fireRadius, map) then
                        -- Враг на линии огня и в радиусе - бомбим, если есть путь отступления
                        local alreadyHasBomb = false
                        for _, b in ipairs(bombs) do
                            if b.gx == cx and b.gy == cy then alreadyHasBomb = true end
                        end

                        if not alreadyHasBomb then
                            local simulatedBombs = {}
                            for _, b in ipairs(bombs) do table.insert(simulatedBombs, b) end
                            table.insert(simulatedBombs, {gx = cx, gy = cy, fireRadius = fireRadius})
                            local simDanger = computeDangerSet(simulatedBombs, map)

                            local sx, sy = findSafeTile(cx, cy, map, simDanger, reserved, simulatedBombs)
                            if sx then
                                botData.x = (cx - 1) * TILE_SIZE
                                botData.y = (cy - 1) * TILE_SIZE
                                spawnBombCallback(cx, cy)
                                botData.targetGridX = sx
                                botData.targetGridY = sy
                                DBG("bot=%s step=2bomb cx=%d cy=%d enemy=%d,%d -> %d,%d", botId, cx, cy, ex, ey, sx, sy)
                                return
                            end
                        end
                    end

                    -- Враг рядом, но не на линии огня (или бомба уже есть/нет бомб) -
                    -- пытаемся сдвинуться так, чтобы оказаться на одной линии с врагом
                    -- (по X либо по Y), не выходя из радиуса fireRadius+1.
                    if not attackedOrAligning then
                        local bestStep = nil
                        local bestScore = -math.huge
                        for _, d in ipairs(DIRS) do
                            local nx, ny = cx + d[1], cy + d[2]
                            if map[ny] and map[ny][nx] == 0
                               and not isTileDangerous(nx, ny, dangerSet)
                               and not isBombAt(nx, ny, bombs)
                               and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE)
                               and not isReserved(nx, ny, reserved) then

                                local newDist = math.abs(nx - ex) + math.abs(ny - ey)
                                local aligned = (nx == ex or ny == ey)
                                local score = 0
                                if aligned and newDist <= fireRadius then score = score + 100 end
                                if aligned then score = score + 10 end
                                if isDeadEnd(nx, ny, cx, cy, map) then score = score - 50 end
                                score = score - newDist -- предпочитаем приближаться

                                if score > bestScore then
                                    bestScore = score
                                    bestStep = {x = nx, y = ny}
                                end
                            end
                        end

                        -- Двигаемся в сторону выравнивания только если это не отдаляет от врага
                        -- слишком сильно (score учитывает дистанцию) и есть хоть какой-то вариант
                        if bestStep and bestScore > -math.huge then
                            local curDist = math.abs(cx - ex) + math.abs(cy - ey)
                            local newDist = math.abs(bestStep.x - ex) + math.abs(bestStep.y - ey)
                            -- Идём на сближение/выравнивание, если это не увеличивает дистанцию
                            -- более чем на 1 (чтобы не убегать от врага под видом "выравнивания")
                            if newDist <= curDist + 1 then
                                botData.targetGridX = bestStep.x
                                botData.targetGridY = bestStep.y
                                attackedOrAligning = true
                                DBG("bot=%s step=2align cx=%d cy=%d enemy=%d,%d -> %d,%d edist=%d", botId, cx, cy, ex, ey, bestStep.x, bestStep.y, edist)
                                return
                            end
                        end
                    end
                end
            end

            -- ============================================================
            -- 3. ПОИСК БАФФОВ (избегаем черепов, идём к хорошим баффам)
            -- ============================================================

            -- Если на текущей клетке стоит череп - не подбираем его (избегаем),
            -- стараемся уйти на соседнюю безопасную клетку, не являющуюся черепом
            if isSkullTile(cx, cy, map, buffsList, TILE_SIZE) then
                for _, d in ipairs(DIRS) do
                    local nx, ny = cx + d[1], cy + d[2]
                    if map[ny] and (map[ny][nx] == 0 or map[ny][nx] == 3)
                       and not isTileDangerous(nx, ny, dangerSet)
                       and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE)
                       and not isReserved(nx, ny, reserved) then
                        botData.targetGridX = nx
                        botData.targetGridY = ny
                        DBG("bot=%s step=3skull cx=%d cy=%d -> %d,%d", botId, cx, cy, nx, ny)
                        return
                    end
                end
            end

            local bx, by = findNearestGoodBuff(cx, cy, map, dangerSet, buffsList, TILE_SIZE, bombs)
            if bx and by then
                -- Двигаемся к найденному баффу шаг за шагом через BFS,
                -- избегая клеток с черепами и зарезервированных другими ботами клеток
                local nx, ny = bfsFirstStepTowards(cx, cy, bx, by, map, dangerSet, bombs)
                if nx and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE) and not isReserved(nx, ny, reserved) then
                    botData.targetGridX = nx
                    botData.targetGridY = ny
                    DBG("bot=%s step=3buff cx=%d cy=%d buff=%d,%d -> %d,%d", botId, cx, cy, bx, by, nx, ny)
                    return
                elseif nx then
                    -- занято другим ботом, но это единственный путь - всё равно идём,
                    -- reserved служит лишь подсказкой, не жёстким запретом
                    botData.targetGridX = nx
                    botData.targetGridY = ny
                    DBG("bot=%s step=3buff2 cx=%d cy=%d buff=%d,%d -> %d,%d", botId, cx, cy, bx, by, nx, ny)
                    return
                end
            end

            -- ============================================================
            -- 4. ОХОТА ЗА ИГРОКОМ (приоритет выше взрывания ящиков)
            -- ============================================================
            do
                local ex, ey, edist = findNearestEnemy(botData, cx, cy, allPlayers, TILE_SIZE)
                if ex and ey then
                    local fireRadius = botData.FIRE or 1

                    -- Если враг в радиусе взрыва и на линии огня - ставим бомбу
                    if botData.BOMBS and botData.BOMBS > 0
                       and edist and edist <= fireRadius
                       and enemyInBlastLine(cx, cy, ex, ey, fireRadius, map) then
                        local alreadyHasBomb = false
                        for _, b in ipairs(bombs) do
                            if b.gx == cx and b.gy == cy then alreadyHasBomb = true end
                        end
                        if not alreadyHasBomb then
                            local simulatedBombs = {}
                            for _, b in ipairs(bombs) do table.insert(simulatedBombs, b) end
                            table.insert(simulatedBombs, {gx = cx, gy = cy, fireRadius = fireRadius})
                            local simDanger = computeDangerSet(simulatedBombs, map)
                            local sx, sy = findSafeTile(cx, cy, map, simDanger, reserved, simulatedBombs)
                            if sx then
                                botData.x = (cx - 1) * TILE_SIZE
                                botData.y = (cy - 1) * TILE_SIZE
                                spawnBombCallback(cx, cy)
                                botData.targetGridX = sx
                                botData.targetGridY = sy
                                DBG("bot=%s step=4hunt_bomb cx=%d cy=%d enemy=%d,%d -> %d,%d", botId, cx, cy, ex, ey, sx, sy)
                                return
                            end
                        end
                    end

                    -- Иначе - идём к врагу через BFS
                    local nx, ny = bfsFirstStepTowards(cx, cy, ex, ey, map, dangerSet, bombs)
                    if nx and not isTileDangerous(nx, ny, dangerSet)
                       and not isBombAt(nx, ny, bombs)
                       and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE)
                       and not isReserved(nx, ny, reserved) then
                        botData.targetGridX = nx
                        botData.targetGridY = ny
                        DBG("bot=%s step=4chase cx=%d cy=%d enemy=%d,%d -> %d,%d", botId, cx, cy, ex, ey, nx, ny)
                        return
                    else
                        DBG("bot=%s step=4chase_fail cx=%d cy=%d enemy=%d,%d step=%s,%s BOMBS=%s virus=%s",
    botId, cx, cy, ex, ey, tostring(nx), tostring(ny),
    tostring(botData.BOMBS), tostring(botData.virus))

                        -- Путь к врагу заблокирован ящиками — ищем ящик в направлении врага и взрываем
                        if botData.BOMBS and botData.BOMBS > 0 then
                            -- BFS который ходит и сквозь ящики, чтобы найти ближайший ящик на пути к врагу
                            DBG("bot=%s step=4clear_search BOMBS=%s", botId, tostring(botData.BOMBS))
                            local function bfsFindCrateTowardsEnemy()
                                local queue = {{x = cx, y = cy, dist = 0}}
                                local visited = {[cy.."_"..cx] = true}
                                local bestCrateAdjacentX, bestCrateAdjacentY = nil, nil
                                local bestDist = math.huge

                                while #queue > 0 do
                                    local cur = table.remove(queue, 1)
                                    if cur.dist >= 15 then break end

                                    for _, d in ipairs(DIRS) do
                                        local nx2, ny2 = cur.x + d[1], cur.y + d[2]
                                        local key = ny2.."_"..nx2
                                        if map[ny2] and not visited[key] then
                                            local tile = map[ny2][nx2]
                                            visited[key] = true
                                            if tile == 2 then
                                                -- Нашли ящик: встать рядом с ним (cur.x, cur.y) и взорвать
                                                -- Предпочитаем ящики в сторону врага
                                                local crateDistToEnemy = math.abs(nx2 - ex) + math.abs(ny2 - ey)
                                                if crateDistToEnemy < bestDist
                                                   and not isTileDangerous(cur.x, cur.y, dangerSet)
                                                   and not isBombAt(cur.x, cur.y, bombs) then
                                                    bestDist = crateDistToEnemy
                                                    bestCrateAdjacentX = cur.x
                                                    bestCrateAdjacentY = cur.y
                                                end
                                            elseif tile == 0 or tile == 3 then
                                                table.insert(queue, {x = nx2, y = ny2, dist = cur.dist + 1})
                                            end
                                            -- tile == 1 (неразрушимый) — пропускаем
                                        end
                                    end
                                end
                                return bestCrateAdjacentX, bestCrateAdjacentY
                            end

                            local tx, ty = bfsFindCrateTowardsEnemy()
                            if tx and ty then
                                if tx == cx and ty == cy then
                                    -- Уже стоим у нужного ящика — взрываем
                                    local alreadyHasBomb = false
                                    for _, b in ipairs(bombs) do
                                        if b.gx == cx and b.gy == cy then alreadyHasBomb = true end
                                    end
                                    if not alreadyHasBomb then
                                        local simulatedBombs = {}
                                        for _, b in ipairs(bombs) do table.insert(simulatedBombs, b) end
                                        table.insert(simulatedBombs, {gx = cx, gy = cy, fireRadius = fireRadius})
                                        local simDanger = computeDangerSet(simulatedBombs, map)
                                        local sx, sy = findSafeTile(cx, cy, map, simDanger, reserved, simulatedBombs)
                                        if sx then
                                            botData.x = (cx - 1) * TILE_SIZE
                                            botData.y = (cy - 1) * TILE_SIZE
                                            spawnBombCallback(cx, cy)
                                            botData.targetGridX = sx
                                            botData.targetGridY = sy
                                            DBG("bot=%s step=4clear_bomb cx=%d cy=%d -> %d,%d", botId, cx, cy, sx, sy)
                                            return
                                        end
                                    end
                                else
                                    -- Идём к нужному ящику
                                    local nx2, ny2 = bfsFirstStepTowards(cx, cy, tx, ty, map, dangerSet, bombs)
                                    if nx2 and not isTileDangerous(nx2, ny2, dangerSet)
                                       and not isBombAt(nx2, ny2, bombs) then
                                        botData.targetGridX = nx2
                                        botData.targetGridY = ny2
                                        DBG("bot=%s step=4clear_path cx=%d cy=%d -> %d,%d (crate adj at %d,%d)", botId, cx, cy, nx2, ny2, tx, ty)
                                        return
                                    end
                                end
                            end
                        end
                    end
                end
            end

            -- ============================================================
            -- 5. УСТАНОВКА БОМБЫ ВОЗЛЕ ЯЩИКА (если нет врага рядом)
            -- ============================================================
            do
                -- Сначала пробуем взорвать ящик прямо рядом
                local canBomb = botData.BOMBS and botData.BOMBS > 0
                if canBomb and findAdjacentCrate(cx, cy, map) then
                    local alreadyHasBomb = false
                    for _, b in ipairs(bombs) do
                        if b.gx == cx and b.gy == cy then alreadyHasBomb = true end
                    end

                    if not alreadyHasBomb then
                        local simulatedBombs = {}
                        for _, b in ipairs(bombs) do table.insert(simulatedBombs, b) end
                        table.insert(simulatedBombs, {gx = cx, gy = cy, fireRadius = botData.FIRE or 1})
                        local simDanger = computeDangerSet(simulatedBombs, map)
                        local sx, sy = findSafeTile(cx, cy, map, simDanger, reserved, simulatedBombs)

                        if sx then
                            botData.x = (cx - 1) * TILE_SIZE
                            botData.y = (cy - 1) * TILE_SIZE
                            spawnBombCallback(cx, cy)
                            botData.targetGridX = sx
                            botData.targetGridY = sy
                            DBG("bot=%s step=5crate_bomb cx=%d cy=%d -> %d,%d", botId, cx, cy, sx, sy)
                            return
                        end
                    end
                end

                -- Если рядом нет ящика — BFS ищем ближайший и идём к нему
                if canBomb then
                    local tx, ty = bfsFindTarget(cx, cy, map, dangerSet, function(gx, gy)
                        return findAdjacentCrate(gx, gy, map)
                    end, 20, bombs)
                    if tx and ty then
                        local nx, ny = bfsFirstStepTowards(cx, cy, tx, ty, map, dangerSet, bombs)
                        if nx and not isTileDangerous(nx, ny, dangerSet)
                           and not isBombAt(nx, ny, bombs)
                           and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE)
                           and not isReserved(nx, ny, reserved) then
                            botData.targetGridX = nx
                            botData.targetGridY = ny
                            DBG("bot=%s step=5seek_crate cx=%d cy=%d -> %d,%d (crate at %d,%d)", botId, cx, cy, nx, ny, tx, ty)
                            return
                        end
                    end
                end
            end

            -- ============================================================
            -- 6. СВОБОДНОЕ ПЕРЕДВИЖЕНИЕ ПО ТРАВЕ
            -- ============================================================
            local dirs = {{0,1}, {0,-1}, {1,0}, {-1,0}}
            for i = #dirs, 2, -1 do
                local j = love.math.random(i)
                dirs[i], dirs[j] = dirs[j], dirs[i]
            end

            local moved = false
            -- Сначала пробуем безопасные, не-черепные, не-зарезервированные, не-заминированные клетки
            for _, d in ipairs(dirs) do
                local nx, ny = cx + d[1], cy + d[2]
                if map[ny] and map[ny][nx] == 0
                   and not isTileDangerous(nx, ny, dangerSet)
                   and not isBombAt(nx, ny, bombs)
                   and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE)
                   and not isReserved(nx, ny, reserved) then
                    botData.targetGridX = nx
                    botData.targetGridY = ny
                    moved = true
                    DBG("bot=%s step=6freeA cx=%d cy=%d -> %d,%d", botId, cx, cy, nx, ny)
                    break
                end
            end

            -- Если не нашли - пробуем те же условия, но без проверки reserved
            -- (чтобы не застывать намертво из-за антиколлизии)
            if not moved then
                for _, d in ipairs(dirs) do
                    local nx, ny = cx + d[1], cy + d[2]
                    if map[ny] and map[ny][nx] == 0
                       and not isTileDangerous(nx, ny, dangerSet)
                       and not isBombAt(nx, ny, bombs)
                       and not isSkullTile(nx, ny, map, buffsList, TILE_SIZE) then
                        botData.targetGridX = nx
                        botData.targetGridY = ny
                        moved = true
                        DBG("bot=%s step=6freeB cx=%d cy=%d -> %d,%d", botId, cx, cy, nx, ny)
                        break
                    end
                end
            end

            -- Если совсем нет безопасных/не-черепных вариантов:
            -- если текущая клетка сама не опасна - лучше остаться на месте и подождать,
            -- чем лезть в огонь или на череп.
            -- Если же текущая клетка опасна - тогда уже вынужденно идём в проходимую клетку.
            if not moved then
                if isTileDangerous(cx, cy, dangerSet) then
                    for _, d in ipairs(dirs) do
                        local nx, ny = cx + d[1], cy + d[2]
                        if map[ny] and map[ny][nx] == 0 and not isBombAt(nx, ny, bombs) then
                            botData.targetGridX = nx
                            botData.targetGridY = ny
                            DBG("bot=%s step=6danger_forced cx=%d cy=%d -> %d,%d", botId, cx, cy, nx, ny)
                            break
                        end
                    end
                else
                    DBG("bot=%s step=6stay cx=%d cy=%d (waiting)", botId, cx, cy)
                end
                -- иначе: остаёмся на месте (targetGridX/Y не меняются), ждём пока опасность исчезнет
            end
        end
    end
end

-- ФУНКЦИЯ ОРИЕНТИРОВАНИЯ (Дебаг-отрисовка целей бота на экране)
function BotAI.draw(botData)
    local TILE_SIZE = long or 80
    if botData and botData.targetGridX and botData.targetGridY then
        -- Рисуем полупрозрачный красный квадрат на клетке, куда ИИ ДУМАЕТ, что идет
        love.graphics.setColor(1, 0, 0, 0.4)
        love.graphics.rectangle("fill", (botData.targetGridX - 1) * TILE_SIZE, (botData.targetGridY - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

        -- Рисуем зелёную рамку вокруг текущей расчетной клетки бота
        local cx = math.floor((botData.x + TILE_SIZE / 2) / TILE_SIZE) + 1
        local cy = math.floor((botData.y + TILE_SIZE / 2) / TILE_SIZE) + 1
        love.graphics.setColor(0, 1, 0, 0.6)
        love.graphics.rectangle("line", (cx - 1) * TILE_SIZE, (cy - 1) * TILE_SIZE, TILE_SIZE, TILE_SIZE)

        -- Сбрасываем цвет обратно в белый, чтобы не покрасить остальные спрайты игры
        love.graphics.setColor(1, 1, 1, 1)
    end
end

return BotAI