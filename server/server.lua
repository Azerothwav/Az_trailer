QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('az_trailer:TakeCash')
AddEventHandler('az_trailer:TakeCash', function(money)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.RemoveMoney('cash', money, "Trailer Rental")
end)

RegisterServerEvent('az_trailer:GiveRefund')
AddEventHandler('az_trailer:GiveRefund', function(money)
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    Player.Functions.AddMoney('cash', money, "Trailer Rental")
end)