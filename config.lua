Config = {}

Config.UseESX = true
Config.UseQBCore = false

Config.TrailerShop = {
    [1] ={
        npccoords = vector3(-247.51, 6213.35, 31.94), 
        heading = 120.0, 
        ped = 'a_f_m_downtown_01', 
        trailertobuy = {
            {label = 'une remorque bateau', name = 'boattrailer', price = 250, coordsspawn = vector3(-251.8, 6223.12, 31.49), heading = 311.34, job = 'none'}, 
            {label = 'une remorque voiture', name = 'trailersmall', price = 250, coordsspawn = vector3(-251.09, 6223.35, 32.49), heading =  311.34, job = 'none'}
        }
    },
}

Config.VehicleCanTrail = {
    {name = 'GUARDIAN', class = {8}},
    {name = 'SQUADDIE', class = {8}},
    {name = 'BENSON', class = {8}},
    {name = 'EVERON', class = {8}},
    {name = 'TITAN', class = {8}},
    {name = 'SANDKING', class = {8}},
    {name = 'SANDKIN2', class = {8}},
    {name = 'DUBSTA3', class = {8}},
    {name = 'BOBCATXL', class = {8}},
    {name = 'BOATTRAILER', class = {14}},
    {name = 'TRAILER', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 18, 19, 20}},
    {name = 'WASTLNDR', class = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9, 11, 12, 13, 14, 15, 16, 17, 18, 19, 20}},
}

Config.Lang = {
    ["TrailerNotFind"] = 'Remorque non trouvée',
    ["RampeAlreadySet"] = 'Une rampe est déjà posée',
    ["NoVehicleSet"] = 'Aucun véhicule attachée trouvée',
    ["CantSetThisType"] = 'Vous ne pouvez pas attacher ce genre de véhicule a cette remorque',
    ["NotGoodJob"] = 'Vous ne faites pas partis du métier ciblée',
    ["PressToOpen"] = 'Appuyez sur E pour ouvrir le menu',
    ["YouBuy"] = 'Vous avez louer : ',
    ["For"] = ' pour : ',
    ["CantBuy"] = 'Tu ne peux pas acheter cela',
    ["BuyFor"] = 'Louer pour : ',
    ["Blip"] = 'Location de remorque',
    ["TrailerNotFind"] = 'Remorque non trouvée',
    ["NotInVehicle"] = 'Vous n\'êtes pas dans un véhicule'
}

Config.AttachCommand = 'attacherremorque'
Config.DetachCommand = 'detacherremorque'