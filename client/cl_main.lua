local notfindtrailer = true
local globalSearch = function()
    return GetVehicleInDirection(GetEntityCoords(PlayerPedId()), GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0))
end
local TrailerBuy = {}
TRAIL = {}
TRAIL.Menu = {}
TRAIL.Menu.Main = RageUI.CreateMenu('', 'Trailer Shop', nil, nil, 'root_cause', 'shopui_title_elitastravel')
TRAIL.Menu.RefoundTrailer = RageUI.CreateMenu('', 'Refound Trailer', nil, nil, 'root_cause', 'shopui_title_elitastravel')

if Config.FrameWork == 'ESX' then
    ESX = nil
    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(500)
        end
        ESX.PlayerData.job = ESX.GetPlayerData().job
    end)
    RegisterNetEvent('esx:playerLoaded')
    AddEventHandler('esx:playerLoaded', function(xPlayer)
        ESX.PlayerData = xPlayer
    end)
    RegisterNetEvent('esx:setJob')
    AddEventHandler('esx:setJob', function(job)
        ESX.PlayerData.job = job
    end)
elseif Config.FrameWork == 'QBCore' then
    PlayerJob = {}
    QBCore = exports['qb-core']:GetCoreObject()
    RegisterNetEvent('QBCore:Client:OnPlayerLoaded')
    AddEventHandler('QBCore:Client:OnPlayerLoaded', function()
        PlayerJob = QBCore.Functions.GetPlayerData().job
    end)
    RegisterNetEvent('QBCore:Client:OnJobUpdate')
    AddEventHandler('QBCore:Client:OnJobUpdate', function(JobInfo)
        PlayerJob = JobInfo
    end)
end

Citizen.CreateThread(function()
    for k, v in pairs(Config.TrailerShop) do
        local blip = AddBlipForCoord(v.npccoords.x, v.npccoords.y, v.npccoords.z)
        SetBlipSprite(blip, 479)
        SetBlipDisplay(blip, 4)
        SetBlipScale(blip, 0.75)
        SetBlipColour(blip, 45)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName('STRING')
        AddTextComponentString(Config.Lang['Blip'])
        EndTextCommandSetBlipName(blip)
    end
end)

function OpenMenuTrailer(index)
    RageUI.Visible(TRAIL.Menu.Main, not RageUI.Visible(TRAIL.Menu.Main))
    while RageUI.Visible(TRAIL.Menu.Main) do
        RageUI.IsVisible(TRAIL.Menu.Main, function()
            for k, v in pairs(Config.TrailerShop[index].trailertobuy) do
                RageUI.Button(Config.Lang['BuyFor'] .. v.price .. ' $ ' .. v.label, nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(TRAIL.Menu.Main, not RageUI.Visible(TRAIL.Menu.Main))
                        SpawnRemorque(v.label, v.name, v.coordsspawn, v.heading, v.price)
                    end
                })
            end
            if #TrailerBuy > 0 then
                RageUI.Button(Config.Lang['refoundTrailer'], '', {}, true, {
                    onSelected = function()
                        RageUI.Visible(TRAIL.Menu.Main, not RageUI.Visible(TRAIL.Menu.Main))
                        RefoundTrailer()
                    end
                })
            end
        end)
        Citizen.Wait(0)
    end
end

function RefoundTrailer()
    TrailerFound = {}
    for k, v in pairs(GetGamePool('CVehicle')) do
        for x, w in pairs(TrailerBuy) do
            if w == v then
                local distanceToVehicle = GetDistanceBetweenCoords(GetEntityCoords(PlayerPedId()), GetEntityCoords(v), true)
                if distanceToVehicle < 20 then
                    table.insert(TrailerFound, v)
                end
            end
        end
    end
    RageUI.Visible(TRAIL.Menu.RefoundTrailer, not RageUI.Visible(TRAIL.Menu.RefoundTrailer))
    while RageUI.Visible(TRAIL.Menu.RefoundTrailer) do
        RageUI.IsVisible(TRAIL.Menu.RefoundTrailer, function()
            for k, v in pairs(TrailerFound) do
                RageUI.Button('Retourn [' .. v .. ']', nil, {}, true, {
                    onSelected = function()
                        RageUI.Visible(TRAIL.Menu.RefoundTrailer, not RageUI.Visible(TRAIL.Menu.RefoundTrailer))
                        DeleteEntity(v)
                        TriggerServerEvent('az_trailer:refound')
                    end,
                    onActive = function()
                        local entcoords = GetEntityCoords(v)
                        DrawMarker(20, entcoords.x, entcoords.y, entcoords.z + 1.1, 0.0, 0.0, 0.0, 0.0, 180.0, 0.0, 0.3, 0., 0.3, 255, 255,
                                   255, 200, 1, true, 2, 0, nil, nil, 0)
                    end
                })
            end
        end)
        Citizen.Wait(0)
    end
end

function SpawnRemorque(label, spawnname, coords, heading, price)
    if Config.FrameWork == 'ESX' then
        ESX.TriggerServerCallback('az_trail:buyTrailer', function(canbuy)
            if canbuy then
                Config.SendNotification(Config.Lang['YouBuy'] .. label .. Config.Lang['For'] .. price .. ' $')
                ESX.Game.SpawnVehicle(spawnname, coords, heading, function(vehicle)
                    SetEntityHeading(vehicle, heading)
                    SetVehicleOnGroundProperly(vehicle)
                    table.insert(TrailerBuy, vehicle)
                end)
            else
                Config.SendNotification(Config.Lang['CantBuy'])
            end
        end, price)
    elseif Config.FrameWork == 'QBCore' then
        QBCore.Functions.TriggerCallback('az_trail:buyTrailer', function(canbuy)
            if canbuy then
                Config.SendNotification(Config.Lang['YouBuy'] .. label .. Config.Lang['For'] .. price .. ' $')
                QBCore.Functions.SpawnVehicle(spawnname, function(vehicle)
                    SetEntityHeading(vehicle, heading)
                    SetVehicleOnGroundProperly(vehicle)
                    table.insert(TrailerBuy, vehicle)
                end, coords, true)
            else
                Config.SendNotification(Config.Lang['CantBuy'])
            end
        end, price)
    end
end

function createPNJ(coords, ped)
    if not IsModelValid(GetHashKey(ped)) then
        return
    end
    RequestModel(GetHashKey(ped))
    while not HasModelLoaded(GetHashKey(ped)) do
        Citizen.Wait(0)
    end
    local tempPNJ = CreatePed(7, GetHashKey(ped), coords.x, coords.y, coords.z - 1, coords.w, 0, false, false)
    while tempPNJ == nil do
        Citizen.Wait(100)
    end
    SetEntityAsMissionEntity(tempPNJ, true, false)
    FreezeEntityPosition(tempPNJ, true)
    ClearPedTasksImmediately(tempPNJ)
    SetEntityInvincible(tempPNJ, true)
    SetBlockingOfNonTemporaryEvents(tempPNJ, 1)
    return tempPNJ
end

AddEventHandler('onResourceStop', function(resourceName)
    if GetCurrentResourceName() == resourceName then
        for k, v in pairs(Config.TrailerShop) do
            DeleteEntity(v.entityPed)
        end
    end
end)

Citizen.CreateThread(function()
    for k, v in pairs(Config.TrailerShop) do
        v.entityPed = createPNJ(vec4(v.npccoords.x, v.npccoords.y, v.npccoords.z, v.heading), v.ped)
        if Config.UseOxTarget then
            exports.ox_target:addLocalEntity(v.entityPed, {
                {
                    icon = 'fas fa-truck-moving',
                    label = Config.Lang['OpenTarget'],
                    canInteract = function(entity)
                        return true
                    end,
                    onSelect = function(entity)
                        OpenMenuTrailer(k)
                    end
                }
            })
        end
    end
    if not Config.UseOxTarget then
        while true do
            local wait = 2000
            local playercoords = GetEntityCoords(PlayerPedId())
            for k, v in pairs(Config.TrailerShop) do
                if GetDistanceBetweenCoords(playercoords, v.npccoords, true) <= 2 then
                    wait = 0
                    Config.ShowHelpNotification(Config.Lang['PressToOpen'])
                    if IsControlJustReleased(0, 38) then
                        if v.job == Config.GetJob() or v.job == 'none' then
                            OpenMenuTrailer(k)
                        else
                            Config.SendNotification(Config.Lang['NotGoodJob'])
                        end
                        Citizen.Wait(1000)
                    end
                end
            end
            Citizen.Wait(wait)
        end
    end
end)

local spawnarampe = false
RegisterCommand('setrampe', function()
    if not spawnarampe then
        spawnarampe = true
        local ped = PlayerPedId()
        local coordA = GetEntityCoords(PlayerPedId(), 1)
        local coordB = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)
        local trailerfind = GetVehicleInDirection(coordA, coordB)
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            local playercoords = GetEntityCoords(PlayerPedId())
            rampe =
                CreateObject(GetHashKey('prop_water_ramp_02'), playercoords.x, playercoords.y, playercoords.z - 1.4, false, false, false)
            SetEntityHeading(rampe, GetEntityHeading(PlayerPedId()))
            trailerfind = nil
            notfindtrailer = true
        else
            spawnarampe = false
            Config.SendNotification(Config.Lang['TrailerNotFind'])
        end
    else
        Config.SendNotification(Config.Lang['RampeAlreadySet'])
    end
end, false)

RegisterCommand('deleterampe', function()
    if spawnarampe then
        DeleteEntity(rampe)
        spawnarampe = false
    end
end, false)

local CommandTable = {
    ['attachtrailer'] = function()
        local veh = GetVehiclePedIsIn(PlayerPedId())
        local havetobreak = false
        if veh ~= nil and veh ~= 0 then
            local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
            local boatCoordsInWorldLol = GetEntityCoords(veh)
            havefindclass = false
            testnb = 0.0
            while notfindtrailer do
                local trailerfind = GetVehicleInDirection(vector3(boatCoordsInWorldLol.x, boatCoordsInWorldLol.y, boatCoordsInWorldLol.z),
                                                          vector3(belowFaxMachine.x, belowFaxMachine.y, belowFaxMachine.z - testnb))
                testnb = testnb + 0.1
                if not startdecompte then
                    startdecompte = true
                    Citizen.SetTimeout(5000, function()
                        if trailerfind ~= 0 and trailerfind ~= nil then
                            startdecompte = false
                            Config.SendNotification(Config.Lang['TrailerNotFind'])
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
                            AttachEntityToEntity(veh, trailerfind, GetEntityBoneIndexByName(trailerfind, 'chassis'),
                                                 GetOffsetFromEntityGivenWorldCoords(trailerfind, boatCoordsInWorldLol), 0.0, 0.0, 0.0,
                                                 false, false, true, false, 20, true)
                            TaskLeaveVehicle(PlayerPedId(), veh, 64)
                        else
                            Config.SendNotification(Config.Lang['CantSetThisType'])
                        end
                    end
                end
                trailerfind = nil
                notfindtrailer = true
            else
                Config.SendNotification(Config.Lang['TrailerNotFind'])
            end
        else
            Config.SendNotification(Config.Lang['NotInVehicle'])
        end
    end,
    ['detachtrailer'] = function()
        if IsPedInAnyVehicle(PlayerPedId(), true) then
            local veh = GetVehiclePedIsIn(PlayerPedId())
            if DoesEntityExist(veh) and IsEntityAttached(veh) then
                DetachEntity(veh, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
                Config.SendNotification(Config.Lang['NoVehicleSet'])
            end
        else
            local vehicleintrailer = globalSearch()
            if tonumber(vehicleintrailer) ~= 0 and vehicleintrailer ~= nil and IsEntityAttached(vehicleintrailer) then
                DetachEntity(vehicleintrailer, true, true)
                notfindtrailer = true
                trailerfind = nil
            else
                Config.SendNotification(Config.Lang['TrailerNotFind'])
            end
        end
    end,
    ['openrampetr2'] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 4, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            Config.SendNotification(Config.Lang['TrailerNotFind'])
        end
    end,
    ['closerampetr2'] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 4, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            Config.SendNotification(Config.Lang['TrailerNotFind'])
        end
    end,
    ['opentrunktr2'] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorOpen(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            Config.SendNotification(Config.Lang['TrailerNotFind'])
        end
    end,
    ['closetrunktr2'] = function()
        local trailerfind = globalSearch()
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
                SetVehicleDoorShut(trailerfind, 5, false, false)
            end
            trailerfind = nil
            notfindtrailer = true
        else
            Config.SendNotification(Config.Lang['TrailerNotFind'])
        end
    end
}

for k, v in pairs(Config.Command) do
    RegisterCommand(v, function()
        CommandTable[k]()
    end)
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
