Config = {}

-- Prices
Config.RefundPrice = 150 -- default refund amount
Config.TrailersmallPrice = 250
Config.BoattrailerPrice = 250
--Config.TracktrailerPrice = 7500

-- Trailer Ped
Config.PedLocation = vector4(-58.62, -1691.88, 28.48, 300)
Config.PedModel = 'S_F_M_Autoshop_01'
Config.PedScenario = 'WORLD_HUMAN_STAND_IMPATIENT_UPRIGHT_FACILITY'

-- Blip
Config.BlipName = 'Trailer Rental'
Config.BlipSprite = 479 -- trailer sprite
Config.BlipScale = 0.8
Config.BlipColour = 0 -- white

-- Trailers
Config.TrailersmallSpawnLocation = vector4(-48.56, -1692.29, 30, 280) -- right of ped
Config.BoattrailerSpawnLocation = vector4(-57.40, -1685.42, 29.49, 300) -- left of ped
---Config.TracktrailerSpawnLocation = vector4(-29.00, -1680.40, 29.45, 117.05) -- infront of big garage door

-- Set which vehicles can attach a trailer
Config.VehicleCanTrail = {
    {name = 'GUARDIAN',     class = {8}},
    {name = 'SQUADDIE',     class = {8}},
    {name = 'BENSON',       class = {8}},
    {name = 'EVERON',       class = {8}},
    {name = 'TITAN',        class = {8}},
    {name = 'SANDKING',     class = {8}},
    {name = 'SANDKIN2',     class = {8}},
    {name = 'DUBSTA3',      class = {8}},
    {name = 'BOBCATXL',     class = {8}},
    {name = 'BOATTRAILER',  class = {14}},
    {name = 'WASTLNDR',     class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
    {name = 'TRAILER',      class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}}
}

-- General Locale
Config.Lang = {
    ["TrailerNotFound"] =    'Trailer not found',
    ["RampAlreadySet"] =   'A ramp is already attached',
    ["NoVehicleSet"] =      'No vehicle attached found',
    ["CantSetThisType"] =   'You cannot attach this type of vehicle to this trailer',
    ["NotInVehicle"] =      'You are not in a vehicle',
}

-- Command Locale
Config.Command = {
    ["attachtrailer"] = "attach",
    ["detachtrailer"] = "detach",

    -- TR2 TRAILER
    ["openramptr2"] = "openramptr2",
    ["opentrunktr2"] = "opentrunktr2",
    ["closeramptr2"] = "closeramptr2",
    ["closetrunktr2"] = "closetrunktr2",
}