-- это для игры по локальной сети (функции хоста)

--[[

local init = require("scripts/init")
local initOther = require("scripts/init_other")
local sock = require("scripts/sock")
local bitser = require("scripts/bitser")
local Player = require("scripts/player")
local socket = require("socket")
local Server = {}

function Server.new(port, password)
    local self = {}

    local status, server = pcall(function() return sock.newServer("*", port) end)
    if not status or not server then return nil, "ПОРТ " .. port .. " УЖЕ ЗАНЯТ!" end

    self.udp = server
    self.udp:setSerialization(bitser.dumps, bitser.loads)
    self.password = password
    self.playerData = {}
    self.playersCount = 0
    self.stateGame = "ReadyPlayers"

    self.udp:on("auth", function(data, client)

        
        if data.password ~= self.password then
            client:send("auth_failed", {reason = "НЕВЕРНЫЙ ПАРОЛЬ"})
            return
        end

        for _, p in pairs(self.playerData) do
            if p.name == data.name then
                client:send("auth_failed", {reason = "ДАННОЕ ИМЯ УЖЕ ЗАНЯТО"})
                return
            end
        end

        if self.playersCount >= 4 then 
            client:send("auth_failed", {reason = "В ИГРЕ УЖЕ 4 ИГРОКА"})
            return
        end
        if self.stateGame ~= "ReadyPlayers" then 
            client:send("auth_failed", {reason = "ИГРА УЖЕ НАЧАЛАСЬ"})
            return 
        end 

        local id = client:getIndex()
        self.playerData[id] = Player.newPlayer(self.playerData, data.name, id, self.playersCount)
        self.playerData[id].lastSeen = love.timer.getTime()
        self.playersCount = self.playersCount + 1
        client:send("auth_succes", {id = id})
        self.udp:sendToAll("player_joined", {pData = self.playerData[id], pCount = self.playersCount})

        for oid, p in pairs(self.playerData) do
            if oid ~= id then client:send("player_joined", {pData = p, pCount = self.playersCount}) end
        end
    end)

    self.udp:on("disconnect", function(data, client)
        local id = client:getIndex()
        if self.playerData[id] then
            self.playerData[id].lastSeen = love.timer.getTime()
            self.playerData[id] = nil
            self.playersCount = self.playersCount - 1
            self.udp:sendToAll("player_left", {id = id})
        end
    end)

    self.udp:on("ping", function(data, client)
        local id = client:getIndex()
        if self.playerData[id] then 
            self.playerData[id].lastSeen = love.timer.getTime() 
        end
    end)

    self.udp:on("quit", function(data, client)
        local id = client:getIndex()
        if self.playerData[id] then
            self.playerData[id].lastSeen = love.timer.getTime()
            self.playerData[id] = nil
            self.udp:sendToAll("player_left", {id = id})
        end
    end)

    function self:stop()
        if self.udp then
            self.udp:sendToAll("server_shutdown", "Host left.")
            for i = 1, 10 do self.udp:update() end
            if self.udp.host then self.udp.host:flush() end
            self.udp = nil
        end
    end

    function self:update(dt)
        if not self.udp then return end
        self.udp:update()
        local now = love.timer.getTime()

        for id, p in pairs(self.playerData) do
            if now - p.lastSeen > 5.0 then
                self.playerData[id] = nil
                self.udp:sendToAll("player_left", {id = id})
                local peer = self.udp:getClientByIndex(id)
                if peer then peer:disconnect_now() end
            end
        end
    end

    return self
end

return Server

]]