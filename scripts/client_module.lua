-- это для игры по локальной сети (функции для клиента)

--[[

local init = require("scripts/init")
local initOther = require("scripts/init_other")
local sock = require("scripts/sock")
local bitser = require("scripts/bitser")
local Player = require("scripts/player")
local Client = {}

function Client.new(ip, port, name, password)
    local self = {}

    local status, client = pcall(function () return sock.newClient(ip, port) end)
    if not status or not client then
        NetError = "НЕВЕРНЫЙ IP АДРЕС"
        SwitchToMenu()
        return nil
    end

    self.udp = client
    self.udp:setSerialization(bitser.dumps, bitser.loads)
    self.list = {}
    self.playersCount = 0
    self.myID = nil
    self.isAuth = false
    self.connTimer = 0
    self.isConnecting = true
    self.dead = false

    self.udp:on("connect", function() self.udp:send("auth", {name = name, password = password}) end)
    self.udp:connect()

    self.udp:on("auth_succes", function(data)
        if self.isAuth then return end
        self.myID = data.id
        self.isAuth = true
        self.isConnecting = false

        fade.state = "out"
        fade.level = "WaitForReady"
    end)

    self.udp:on("auth_failed", function(data)
        NetError = data.reason
        self.dead = true
        if self.udp.host then self.udp.host:flush() end
        self.udp = nil
        myClient = nil
    end)

    self.udp:on("disconnect", function()
        if NetError == "" then NetError = "СОЕДИНЕНИЕ С СЕРВЕРОМ ПОТЕРЯНО" end
        self.isAuth = false
        SwitchToMenu()
    end)

    self.udp:on("player_joined", function(d)
        self.list[d.pData.id] = d.pData
        self.playersCount = d.pCount
        if d.pData.id == self.myID then d.pData.isMe = true end
    end)

    self.udp:on("player_left", function(d) self.list[d.id] = nil; self.playersCount = self.playersCount - 1 end)

    function self:draw()
        return self.playersCount, self.list
    end

    function self:update(dt)
        if self.dead then return end
        if not self.udp then return end
        pcall(function() self.udp:update() end)

        if self.isConnecting then
            self.connTimer = self.connTimer + dt
            
            if self.connTimer > 5 then
                self.isConnecting = false
                self.udp:disconnect()
                NetError = "СЕРВЕР НЕ НАЙДЕН"
                SwitchToMenu()
            end
        end

        if self.isAuth then
            self.pingTimer = (self.pingTimer or 0) + dt
            if self.pingTimer > 1.5 then
                self.udp:send("ping")
                self.pingTimer = 0
            end
        end
    end

    return self
end

return Client

]]