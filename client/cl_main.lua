local QBCore = exports['qb-core']:GetCoreObject()

local TrailerBuy = {}
local notfindtrailer = true

local globalSearch = function()
    return GetVehicleInDirection(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0))
end

    -------------
    -- THREADS --
    -------------

CreateThread(function()
    SpawnNPC()
end)

SpawnNPC = function()
    CreateThread(function()
        RequestModel(GetHashKey(Config.PedModel))
        while not HasModelLoaded(GetHashKey(Config.PedModel)) do
            Wait(1)
        end
        CreateNPC()
    end)
end

CreateThread(function()
    blip = AddBlipForCoord(Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z)
    SetBlipSprite (blip, Config.BlipSprite)
    SetBlipDisplay(blip, 2)
    SetBlipScale  (blip, Config.BlipScale)
    SetBlipColour (blip, Config.BlipColour)
    SetBlipAsShortRange(blip, true)
    BeginTextCommandSetBlipName("STRING")
    AddTextComponentString(Config.BlipName)
    EndTextCommandSetBlipName(blip)
end)

    ---------------
    -- FUNCTIONS --
    ---------------

CreateNPC = function()
    created_ped = CreatePed(5, GetHashKey(Config.PedModel) , Config.PedLocation.x, Config.PedLocation.y, Config.PedLocation.z, Config.PedLocation.w, false, true)
    FreezeEntityPosition(created_ped, true)
    SetEntityInvincible(created_ped, true)
    SetBlockingOfNonTemporaryEvents(created_ped, true)
    TaskStartScenarioInPlace(created_ped, Config.PedScenario, 0, true)
end

function DespawnTrailer()
    TrailerFound = {}
    for k, v in pairs(GetGamePool("CVehicle")) do
        for x, w in pairs(TrailerBuy) do
            if w == v then
                local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(v), true)
                if distanceToVehicle < 20 then
                    table.insert(TrailerFound, v)
                    table.remove(TrailerBuy, x)
                end
            end
        end
    end
    for k, v in pairs(TrailerFound) do
        DeleteEntity(v)
    end
end

function GetVehicleInDirection(cFrom, cTo)
    trailerfind = nil
    notfindtrailer = true
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, PlayerPedId(), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    if vehicle == 0 then
        notfindtrailer = true
    else
        notfindtrailer = false
        trailerfind = vehicle
    end
    return trailerfind
end

    ------------
    -- EVENTS --
    ------------

RegisterNetEvent('az-trailer:openMenu', function()
    exports['qb-menu']:openMenu({
        {
            header = "Rental Trailers",
            isMenuHeader = true,
        },
        {
            id = 1,
            header = "Return Trailer",
            txt = "Return your rented trailer",
            params = {
                event = "az-trailer:return",
                args = {
                    refundmoney = Config.RefundPrice
                }
            }
        },
        {
            id = 2,
            header = "Rent Car Trailer",
            txt = "$250.00 deposit",
            params = {
                event = "az-trailer:spawncar",
                args = {
                    model = 'trailersmall',
                    money = Config.TrailersmallPrice,
                }
            }
        },
        {
            id = 3,
            header = "Rent Boat Trailer",
            txt = "$250.00 deposit",
            params = {
                event = "az-trailer:spawncar",
                args = {
                    model = 'boattrailer',
                    money = Config.BoattrailerPrice,
                }
            }
        },
--[[         {
            id = 4,
            header = "Rent Track Trailer",
            txt = "$7500.00 deposit",
            params = {
                event = "az-trailer:spawncar",
                args = {
                    model = 'tr2',
                    money = Config.TracktrailerPrice,
                }
            }
        }, ]]
    })
end)

RegisterNetEvent('az-trailer:spawncar')
AddEventHandler('az-trailer:spawncar', function(data)
    local money = data.money
    local model = data.model
    local spawnLocation
    local spawnHeading
    if model == 'trailersmall' then
        spawnLocation = Config.TrailersmallSpawnLocation
        spawnHeading = Config.TrailersmallSpawnLocation.w
    elseif model == 'boattrailer' then
        spawnLocation = Config.BoattrailerSpawnLocation
        spawnHeading = Config.BoattrailerSpawnLocation.w
    --[[ elseif model == 'tr2' then
        spawnLocation = Config.TracktrailerSpawnLocation
        spawnHeading = Config.TracktrailerSpawnLocation.w ]]
    else
        spawnLocation = vector4(-49.96, -1692.76, 29.49, 287.79) -- Default location
        spawnHeading = 287.79
    end
    local playerMoney = QBCore.Functions.GetPlayerData().money["cash"] or 0
    if playerMoney >= money then
        QBCore.Functions.SpawnVehicle(model, function(vehicle)
            SetEntityHeading(vehicle, spawnHeading)
            table.insert(TrailerBuy, vehicle)
            SetVehicleOnGroundProperly(vehicle)
            TriggerServerEvent('az_trailer:TakeCash', money)
        end, spawnLocation, true)
        if model == 'trailersmall' then
            TriggerEvent('QBCore:Notify', 'You rented a car trailer', 'success')
        elseif model == 'boattrailer' then
            TriggerEvent('QBCore:Notify', 'You rented a boat trailer', 'success')
        else TriggerEvent('QBCore:Notify', 'You rented a trailer', 'success')
        end
        else
            if model == 'trailersmall' then
                TriggerEvent('QBCore:Notify', 'You need $' .. Config.TrailersmallPrice .. ' in cash to rent this trailer', 'error')
            elseif model == 'boattrailer' then
                TriggerEvent('QBCore:Notify', 'You need $' .. Config.BoattrailerPrice .. ' in cash to rent this trailer', 'error')
            --[[ elseif model == 'tr2' then
                TriggerEvent('QBCore:Notify', 'You need $' .. Config.Tr2Price .. ' in cash to rent this trailer', 'error') ]]
            else
                TriggerEvent('QBCore:Notify', 'You need more cash to rent this trailer', 'error')
            end
    end
end)

RegisterNetEvent('az-trailer:return')
AddEventHandler('az-trailer:return', function(data)
    local model = data.model
    if next(TrailerBuy) then
        DespawnTrailer()
        QBCore.Functions.Notify('You returned the trailer', 'primary')
        if model == 'trailersmall' then
            TriggerServerEvent('az_trailer:GiveRefund', Config.TrailersmallPrice)
        elseif model == 'boattrailer' then
            TriggerServerEvent('az_trailer:GiveRefund', Config.BoattrailerPrice)
        --[[ elseif model == 'tr2' then
            TriggerServerEvent('az_trailer:GiveRefund', Config.TracktrailerPrice) ]]
        else
            TriggerServerEvent('az_trailer:GiveRefund', Config.RefundPrice)
        end
    else
        QBCore.Functions.Notify("No trailer to return", "error")
    end
end)

    --------------
    -- COMMANDS --
    --------------

spawnramp = false
RegisterCommand('setramp', function()
    if not spawnramp then
        spawnramp = true
        local ped = PlayerPedId()
        local coordA = GetEntityCoords(PlayerPedId(), 1)
        local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
        local trailerfind = GetVehicleInDirection(coordA, coordB)
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            local playercoords = GetEntityCoords(PlayerPedId())
            ramp = CreateObject(GetHashKey('prop_water_ramp_02'), playercoords.x, playercoords.y, playercoords.z - 1.4, false, false, false)
            SetEntityHeading(ramp, GetEntityHeading(PlayerPedId()))
            trailerfind = nil
            notfindtrailer = true
        else
            spawnramp = false
            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
        end
    else
        QBCore.Functions.Notify(Config.Lang["RampAlreadySet"], 'warning')
    end
end, false)

RegisterCommand('deleteramp', function()
    if spawnramp then
        DeleteEntity(ramp)
        spawnramp = false
    end
end, false)

local CommandTable = {
    ["attachtrailer"] = function()
        local veh = GetVehiclePedIsIn(PlayerPedId())
        local havetobreak = false
        if veh ~= nil and veh ~= 0 then
            local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
            local boatCoordsInWorldLol = GetEntityCoords(veh)
            havefindclass = false
            testnb = 0.0
            while notfindtrailer do
                local trailerfind = GetVehicleInDirection(vector3(boatCoordsInWorldLol.x, boatCoordsInWorldLol.y, boatCoordsInWorldLol.z), vector3(belowFaxMachine.x, belowFaxMachine.y, belowFaxMachine.z - testnb))
                testnb = testnb + 0.1
                if not startdecompte then
                    startdecompte = true
                    Citizen.SetTimeout(5000, function()
                        if trailerfind ~= 0 and trailerfind ~= nil then
                            startdecompte = false
                            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
                            havetobreak = true
                        end
                    end)
                end
                if havetobreak then
                    break
                end
                Citizen.Wait(0)
            end
            if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
                for k, v in pairs(Config.VehicleCanTrail) do
                    if v.name == GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) then
                        for x, w in pairs(v.class) do
                            if w == GetVehicleClass(veh) then
                                havefindclass = true
                            end
                        end
                        if havefindclass then
                            AttachEntityToEntity(veh, trailerfind, GetEntityBoneIndexByName(trailerfind, 'chassis'), GetOffsetFromEntityGivenWorldCoords(trailerfind, boatCoordsInWorldLol), 0.0, 0.0, 0.0, false, false, true, false, 20, true)
                            TaskLeaveVehicle(PlayerPedId(), veh, 64)
                        else
                            QBCore.Functions.Notify(Config.Lang["CantSetThisType"], 'error')
                        end
                    end
                end
                trailerfind = nil
                notfindtrailer = true
            else
                QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
            end
        else
            QBCore.Functions.Notify(Config.Lang["NotInVehicle"], 'error')
        end
    end,
    ["detachtrailer"] = function()
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsIn(PlayerPedId())
            if DoesEntityExist(veh) and IsEntityAttached(veh) then
                DetachEntity(veh, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
                QBCore.Functions.Notify(Config.Lang["NoVehicleSet"], 'error')
            end
        else
            local vehicleintrailer = globalSearch()
            if tonumber(vehicleintrailer) ~= 0 and vehicleintrailer ~= nil and IsEntityAttached(vehicleintrailer) then
                DetachEntity(vehicleintrailer, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
                QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
            end
        end
    end,
    ["openramptr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 4, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
        end
    end,
    ["closeramptr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 4, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
        end
    end,
    ["opentrunktr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
        end
    end,
    ["closetrunktr2"] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            QBCore.Functions.Notify(Config.Lang["TrailerNotFound"], 'error')
        end
    end,
}

for k, v in pairs(Config.Command) do
    RegisterCommand(v, function()
        CommandTable[k]()
    end)
end