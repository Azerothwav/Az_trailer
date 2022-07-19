if Config.UseESX then
    ESX = nil

    TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

    ESX.RegisterServerCallback("az_trail:buyTrailer", function(source, cb, price)
        local xPlayer = ESX.GetPlayerFromId(source)
        if xPlayer and xPlayer ~= nil then
            local playerMoney = xPlayer.getMoney()
            if playerMoney >= price then
                xPlayer.removeMoney(price)
                cb(true)
            else
                cb(false)
            end
        end
    end)
elseif Config.QBCore then
    QBCore = exports['qb-core']:GetCoreObject()
    
    QBCore.Functions.CreateCallback("az_trail:buyTrailer", function(source, cb, price)
        local Player = QBCore.Functions.GetPlayer(source)
        PlayerMoney = Player.PlayerData.money["cash"]
        if PlayerMoney >= price then
            Player.Functions.RemoveMoney("cash", price)
            cb(true)
        else
            cb(false)
        end
    end)
end