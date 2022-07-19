TRAIL = {}
TRAIL.Menu = {}
TRAIL.Menu.IsInService = false
TRAIL.Menu.IsOpen = false
TRAIL.Menu.Main = RageUI.CreateMenu("", "Magasin", nil, nil, "root_cause", "shopui_title_elitastravel")

TRAIL.Menu.Main.Closed = function()
    TRAIL.Menu.Close()
end

function TRAIL.Menu.Close()
    TRAIL.Menu.IsOpen = false
    RageUI.CloseAll()
    RageUI.Visible(TRAIL.Menu.Main, false)
end

Citizen.CreateThread(function()
	for k, v in pairs (Config.TrailerShop) do
		
		local blip = AddBlipForCoord(v.npccoords.x, v.npccoords.y, v.npccoords.z)
		SetBlipSprite (blip, 479)
		SetBlipDisplay(blip, 4)
		SetBlipScale(blip, 0.75)
		SetBlipColour (blip, 45)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(Config.Lang["Blip"])
		EndTextCommandSetBlipName(blip)
	end
end)


function TRAIL.Menu.Open(index)
    Citizen.CreateThread(function()
        while TRAIL.Menu.IsOpen do
            RageUI.IsVisible(TRAIL.Menu.Main, function()
                for k, v in pairs(Config.TrailerShop[index].trailertobuy) do
                    RageUI.Button(Config.Lang["BuyFor"] .. v.price.. ' $ '.. v.label, nil, {}, true, {
                        onSelected = function()
                            SpawnRemorque(v.label, v.name, v.coordsspawn, v.heading, v.price)
                            RageUI.CloseAll()
                        end,
                    })
                end
            end)
            Citizen.Wait(1)
        end
    end)
end

function SpawnRemorque(label, spawnname, coords, heading, price)
    if Config.UseESX then
        ESX.TriggerServerCallback('az_trail:buyTrailer', function(canbuy)
            if canbuy then
                ESX.ShowNotification(Config.Lang["YouBuy"]..label.. Config.Lang["For"]..price..' $')
                ESX.Game.SpawnVehicle(spawnname, coords, heading, function(vehicle)
                    SetVehicleOnGroundProperly(vehicle)
                end)
            else
                ESX.ShowNotification(Config.Lang["CantBuy"])
            end
        end, price)
    elseif Config.UseQBCore then
        QBCore.Functions.TriggerCallback('az_trail:buyTrailer', function(canbuy)
            if canbuy then
                QBCore.Functions.Notify(Config.Lang["YouBuy"]..label.. Config.Lang["For"]..price..' $', "success")
                QBCore.Functions.SpawnVehicle(spawnname, function(vehicle)
                    SetEntityHeading(vehicle, heading)
                    SetVehicleOnGroundProperly(vehicle)
                end, coords, true)
            else
                QBCore.Functions.Notify(Config.Lang["CantBuy"], "error")
            end
        end, price)
    end
end

local npcspawn = false
local lastcoords = nil
local notshown = true
Citizen.CreateThread(function()
    while true do
        local wait = 2000
        local playercoords = GetEntityCoords(GetPlayerPed(-1))
        for k, v in pairs(Config.TrailerShop) do
            if GetDistanceBetweenCoords(playercoords, v.npccoords, true) < 50 and not npcspawn then
                lastshop = true
                lastcoords = v.npccoords
                CreatePNJ(v.npccoords, v.heading, v.ped, nil, true)
                npcspawn = true
            elseif GetDistanceBetweenCoords(playercoords, v.npccoords, true) < 2 then
                wait = 0
                if Config.UseESX then
                    ESX.ShowHelpNotification(Config.Lang["PressToOpen"])
                    if IsControlJustReleased(0, 38) then
                        if v.job == ESX.PlayerData.job.name or v.job == 'none' then
                            inmenu = true
                            OpenMenuTrailer(k)
                        else
                            ESX.ShowNotification(Config.Lang["NotGoodJob"])
                        end
                    end
                elseif Config.UseQBCore then
                    if notshown then
                        notshown = false
                        QBCore.Functions.Notify(Config.Lang["PressToOpen"], "success")
                    end
                    if IsControlJustReleased(0, 38) then
                        if PlayerJob.name == v.job or v.job == 'none' then
                            inmenu = true
                            OpenMenuTrailer(k)
                        else
                            QBCore.Functions.Notify(Config.Lang["NotGoodJob"], "error")
                        end
                    end
                end
            elseif GetDistanceBetweenCoords(playercoords, lastcoords, true) > 2 and inmenu then
                wait = 2000
                inmenu = false
            elseif GetDistanceBetweenCoords(playercoords, lastcoords, true) > 100 and lastshop then
                DeleteEntity(MissionPed)
                npcspawn = false
                lastcoords = nil
                wait = 2000
                inmenu = false
            end
        end
        Citizen.Wait(wait)
    end
end)

function CreatePNJ(coords, heading, ped, scenario, freeze)
    MissionPed = nil
    RequestModel(GetHashKey(ped))
    while not HasModelLoaded(GetHashKey(ped)) do
        Citizen.Wait(0)
    end
    MissionPed = CreatePed(7,GetHashKey(ped),coords.x, coords.y, coords.z - 1, heading,0,true,true)
    if scenario ~= nil then
        TaskStartScenarioInPlace(MissionPed, scenario, 0, false)
    end
    if freeze then
        FreezeEntityPosition(MissionPed, true)
		SetBlockingOfNonTemporaryEvents(MissionPed, 1)
    end
end

function OpenMenuTrailer(index)
    RageUI.CloseAll()
    RageUI.Visible(TRAIL.Menu.Main, not RageUI.Visible(TRAIL.Menu.Main))
    TRAIL.Menu.IsOpen = not TRAIL.Menu.IsOpen
    TRAIL.Menu.Open(index)
end

notfindtrailer = true
RegisterCommand(Config.AttachCommand, function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    local havetobreak = false
    if veh ~= nil and veh ~= 0 then
        trailerfind = nil
        local belowFaxMachine = GetOffsetFromEntityInWorldCoords(veh, 1.0, 0.0, -1.0)
        local boatCoordsInWorldLol = GetEntityCoords(veh)
        havefindclass = false
        testnb = 0.0
        while notfindtrailer do
            GetVehicleInDirection(vector3(boatCoordsInWorldLol.x, boatCoordsInWorldLol.y, boatCoordsInWorldLol.z), vector3(belowFaxMachine.x, belowFaxMachine.y, belowFaxMachine.z - testnb))
            testnb = testnb + 0.1
            if not startdecompte then
                startdecompte = true
                Citizen.SetTimeout(5000, function()
                    if trailerfind ~= 0 and trailerfind ~= nil then
                        startdecompte = false
                        if Config.UseESX then
                            ESX.ShowNotification(Config.Lang["TrailerNotFind"])
                        elseif Config.UseQBCore then
                            QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
                        end
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
                        TaskLeaveVehicle(ped, veh, 64)
                    else
                        if Config.UseESX then
                            ESX.ShowNotification(Config.Lang["CantSetThisType"])
                        elseif Config.UseQBCore then
                            QBCore.Functions.Notify(Config.Lang["CantSetThisType"], "error")
                        end
                    end
                end
            end
            trailerfind = nil
            notfindtrailer = true
        else
            if Config.UseESX then
                ESX.ShowNotification(Config.Lang["TrailerNotFind"])
            elseif Config.UseQBCore then
                QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
            end
        end
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["NotInVehicle"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["NotInVehicle"], "error")
        end
    end
end, false)

spawnarampe = false
RegisterCommand('setrampe', function()
    if not spawnarampe then
        spawnarampe = true
        local ped = GetPlayerPed(-1)
        trailerfind = nil
        local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
        local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
        GetVehicleInDirection(coordA, coordB)
        if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
            local playercoords = GetEntityCoords(GetPlayerPed(-1))
            rampe = CreateObject(GetHashKey('prop_water_ramp_02'), playercoords.x, playercoords.y, playercoords.z - 1.4, false, false, false)
            SetEntityHeading(rampe, GetEntityHeading(GetPlayerPed(-1)))
            trailerfind = nil
            notfindtrailer = true
        else
            spawnarampe = false
            if Config.UseESX then
                ESX.ShowNotification(Config.Lang["TrailerNotFind"])
            elseif Config.UseQBCore then
                QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
            end
        end
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["RampeAlreadySet"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["RampeAlreadySet"], "error")
        end
    end
end, false)

RegisterCommand('deleterampe', function()
    if spawnarampe then
        DeleteEntity(rampe)
        spawnarampe = false
    end
end, false)

RegisterCommand('openrampe', function()
    local ped = GetPlayerPed(-1)
    trailerfind = nil
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    GetVehicleInDirection(coordA, coordB)
    if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
        if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
            SetVehicleDoorOpen(trailerfind, 4, false, false)
        end
        trailerfind = nil
        notfindtrailer = true
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["TrailerNotFind"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
        end
    end
end, false)

RegisterCommand('openremorque', function()
    local ped = GetPlayerPed(-1)
    trailerfind = nil
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    GetVehicleInDirection(coordA, coordB)
    if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
        if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
            SetVehicleDoorOpen(trailerfind, 5, false, false)
        end
        trailerfind = nil
        notfindtrailer = true
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["TrailerNotFind"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
        end
    end
end, false)

RegisterCommand('closerampe', function()
    local ped = GetPlayerPed(-1)
    trailerfind = nil
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    GetVehicleInDirection(coordA, coordB)
    if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
        if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
            SetVehicleDoorShut(trailerfind, 4, false, false)
        end
        trailerfind = nil
        notfindtrailer = true
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["TrailerNotFind"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
        end
    end
end, false)

RegisterCommand('closeremorque', function()
    local ped = GetPlayerPed(-1)
    trailerfind = nil
    local coordA = GetEntityCoords(GetPlayerPed(-1), 1)
    local coordB = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    GetVehicleInDirection(coordA, coordB)
    if tonumber(trailerfind) ~= 0 and trailerfind ~= nil then
        if GetDisplayNameFromVehicleModel(GetEntityModel(trailerfind)) == 'TRAILER' then
            SetVehicleDoorShut(trailerfind, 5, false, false)
        end
        trailerfind = nil
        notfindtrailer = true
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["TrailerNotFind"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["TrailerNotFind"], "error")
        end
    end
end, false)

function GetVehicleInDirection(cFrom, cTo)
    trailerfind = nil
    notfindtrailer = true
    local rayHandle = CastRayPointToPoint(cFrom.x, cFrom.y, cFrom.z, cTo.x, cTo.y, cTo.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicle = GetRaycastResult(rayHandle)
    if vehicle == 0 then
        notfindtrailer = true
    else
        notfindtrailer = false
        trailerfind = vehicle
    end
end

RegisterCommand(Config.DetachCommand, function()
    local ped = GetPlayerPed(-1)
    local veh = GetVehiclePedIsIn(ped)
    if IsPedInAnyVehicle(ped, true) then
        local veh = GetVehiclePedIsIn(ped)
        if DoesEntityExist(veh) and IsEntityAttached(veh) then
            DetachEntity(veh, true, true)
            notfindtrailer = true
            trailerfind = nil
        else
            if Config.UseESX then
                ESX.ShowNotification(Config.Lang["NoVehicleSet"])
            elseif Config.UseQBCore then
                QBCore.Functions.Notify(Config.Lang["NoVehicleSet"], "error")
            end
        end
    else
        if Config.UseESX then
            ESX.ShowNotification(Config.Lang["NotInVehicle"])
        elseif Config.UseQBCore then
            QBCore.Functions.Notify(Config.Lang["NotInVehicle"], "error")
        end
    end
end, false)
