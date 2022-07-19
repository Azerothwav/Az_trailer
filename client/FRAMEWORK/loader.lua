if Config.UseESX then
    ESX = nil -- Global ESX object

    Citizen.CreateThread(function()
        while ESX == nil do
            TriggerEvent('esx:getSharedObject', function(obj)
                ESX = obj
            end)
            Citizen.Wait(500)
        end

        while ESX.GetPlayerData().job == nil do
            Citizen.Wait(100)
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
elseif Config.UseQBCore then
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
