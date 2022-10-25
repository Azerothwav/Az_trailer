if Config.FrameWork == "ESX" then
    ESX = exports['es_extended']:getSharedObject()

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
elseif Config.FrameWork == "QBCore" then
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

RegisterNetEvent("az_trailer:refound")
AddEventHandler("az_trailer:refound", function()
    if Config.FrameWork == "ESX" then
        local xPlayer = ESX.GetPlayerFromId(source)
        xPlayer.addAccountMoney("money", Config.RefoundPrice)
    elseif Config.FrameWork == "QBCore" then
        local Player = QBCore.Functions.GetPlayer(source)
        Player.Functions.GiveMoney("cash", Config.RefoundPrice)
    end
end)