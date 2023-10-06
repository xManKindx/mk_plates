# mk_plates
# Vanity / Fake Plates script
# Written by ManKind [https://discord.gg/39fNFepADG] for QB-Core / ESX

## Dependencies
- [qb-core] / [es_extended] (Updated versions using Onesync Infinity)
- [oxmysql]
- [ox_lib]

# Features
- Install fake plate on an owned vehicle using an item (Inventory works / Vehicle lookup doesn't come back to player)
- Remove fake plate with an item
- Plate must be removed prior to storing the vehicle (qbcore)
- Install vanity plates on owned vehicles using an item (Inventory updates with plate)
- Vanity plate features:
-   Custom plate between 2 and 8 characters
-   Profanity filter support (edit in config)
-   Restrict certain plates (BCSO/LSPD/FOR SALE/ect in config)
-   Can set vehicle owners or certain jobs (ex: mechanics) to be able to install the plates
-   Must remove a fakeplate before installing a vanity plate. Fake plates work overtop of a vanity!
- All notifications available in config for language adjustment

# Fake Plates Framework Installation

# [qb-core]
- Add fakeplate item to [qb-core/shared/items.lua/QBShared.Items] table
    ```lua

        ['fakeplate'] 					 = {['name'] = 'fakeplate', 			  	  	['label'] = 'Fake Plate', 				['weight'] = 100, 		['type'] = 'item', 		['image'] = 'fakeplate.png', 			['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   	['description'] = 'The cops will never know.'},

    ```
- Add or adjust fakeplate removal item to [qb-core/shared/items.lua/QBShared.Items] table
    - If using existing item be sure to set ['useable'] = true and ['shouldClose'] = true on item
    ```lua

        ['screwdriverset'] 				 = {['name'] = 'screwdriverset', 			    ['label'] = 'Toolkit', 					['weight'] = 1000, 		['type'] = 'item', 		['image'] = 'screwdriverset.png', 		['unique'] = false, 	['useable'] = true, 	['shouldClose'] = true,    ['combinable'] = nil,   ['description'] = 'Very useful to screw... screws...'},

    ```

# [es_extended]
-   navigate to [es_extended/client/functions.lua]
    - locate `ESX.Game.SetVehicleProperties`
        - locate `if props.plate ~= nil` if/then statement and `replace it with the following:`
            ```lua

                if props.plate ~= nil then
                    if props.fakeplate then 
                        SetVehicleNumberPlateText(vehicle, props.fakeplate)
                    else
                        SetVehicleNumberPlateText(vehicle, props.plate)
                    end
                end

            ```

    - locate `ESX.Game.GetVehicleProperties`
        - locate `plate = ESX.Math.Trim(GetVehicleNumberPlateText(vehicle)),` and `replace it with:`
            ```lua

                plate = (Entity(vehicle).state.VehicleProperties and (Entity(vehicle).state.VehicleProperties.fakeplate ~= nil and (Entity(vehicle).state.VehicleProperties.plate and Entity(vehicle).state.VehicleProperties.plate or ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))) or ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))) or ESX.Math.Trim(GetVehicleNumberPlateText(vehicle))),
            
            ```
        - `on the line directly after what you just replaced add this:`
            ```lua

                fakeplate = Entity(vehicle).state.VehicleProperties and (Entity(vehicle).state.VehicleProperties.fakeplate ~= nil and Entity(vehicle).state.VehicleProperties.fakeplate or nil) or nil,

            ```    

# Fake Plates Inventory Installation 
-    # [qb-inventory]
       - Add item images (if new items) to [qb-inventory/html/images/] folder (.png) (fakeplate example provided in [mk_plates] images folder)
       - Locate function [IsVehicleOwned] inside [qb-inventory/server/main.lua] and replace with:
            ```lua

                local function IsVehicleOwned(plate)
                    local result = MySQL.scalar.await('SELECT 1 from player_vehicles WHERE plate = :plate OR fakeplate = :plate', {plate = plate})
                    return result
                end
            ```
        **Not doing the above function replace will not update glovebox/trunk items when fake plate is added.**
        - **NOTE: MAKE SURE YOUR TRUNKITEMS OR GLOVEBOXITEMS DATABASE TABLES HAVE AT LEAST 1 ENTRY IN THEM OR YOUR INVENTORIES WILL NOT UPDATE WHEN PLATES ARE CHANGED IF USING QB-INVENTORY**

-   # [ox_inventory] **Version 2.23.4+ Required**
       - Add item images (if new items) to [ox_inventory/web/images]
       - Add items to [ox_inventory/data/items.lua]
            ```lua

                ['fakeplate'] = {
                    label = 'Fake Plate',
                    weight = 160,
                    stack = false,
                    close = true,
                },

                ['screwdriverset'] = {
                    label = 'Toolset',
                    weight = 160,
                },
            ```

        - **FOLLOW OX_INVENTORY INTEGRATION STEPS SHOWN [HERE]**(https://github.com/xManKindx/mk_plates/blob/main/ox_inventory_setup.md)

        - **INTEGRATION WILL BE KEPT UP TO DATE IN THIS FILE TO PREVENT HAVING TO UPDATE THE SCRIPT BECAUSE OF AN OX_INVENTORY UPDATE**

# Vanity Plates Framework Installation 
# [qb-core]
- Add vanityplate item to [qb-core/shared/items.lua/QBShared.Items] table
    ```lua

        ['vanityplate'] 				 = {['name'] = 'vanityplate', 			  	  	['label'] = 'Vanity Plate', 			['weight'] = 100, 		['type'] = 'item', 		['image'] = 'vanityplate.png', 			['unique'] = true, 	['useable'] = true, 	['shouldClose'] = true,   ['combinable'] = nil,   	['description'] = 'Custom vehicle plate'},
        
    ```
-   [qb-garages]
    - Locate callback [qb-garage:server:spawnvehicle] inside [qb-garages/server/main.lua] and replace with:
        ```lua

            QBCore.Functions.CreateCallback('qb-garage:server:spawnvehicle', function (source, cb, vehInfo, coords, warp)
                local plate = vehInfo.plate
                local veh = QBCore.Functions.SpawnVehicle(source, vehInfo.vehicle, coords, warp)
                SetVehicleNumberPlateText(veh, plate)
                SetEntityHeading(veh, coords.w)
                local vehProps = {}
                local result = MySQL.query.await('SELECT mods FROM player_vehicles WHERE plate = ?', {plate})
                if result[1] then vehProps = json.decode(result[1].mods) end
                local netId = NetworkGetNetworkIdFromEntity(veh)
                OutsideVehicles[plate] = {netID = netId, entity = veh}
                cb(netId, vehProps)
            end)

        ```
    - Locate RegisterNetEvent [qb-garages:client:takeOutGarage] inside [qb-garages/client/main.lua] and replace with:
        ```lua

            RegisterNetEvent('qb-garages:client:takeOutGarage', function(data)
                local type = data.type
                local vehicle = data.vehicle
                local garage = data.garage
                local index = data.index
                QBCore.Functions.TriggerCallback('qb-garage:server:IsSpawnOk', function(spawn)
                    if spawn then
                        local location
                        if type == "house" then
                            if garage.takeVehicle.h then garage.takeVehicle.w = garage.takeVehicle.h end -- backward compatibility
                            location = garage.takeVehicle
                        else
                            location = garage.spawnPoint
                        end
                        QBCore.Functions.TriggerCallback('qb-garage:server:spawnvehicle', function(netId, properties)
                            local timeout = 0
                            local veh = 0
                            veh = NetworkGetEntityFromNetworkId(netId)
                            while veh == 0 and timeout < 50 do 
                                Wait(100)
                                timeout = timeout + 1
                            end
                            if veh > 0 then 
                                SetVehicleNumberPlateText(veh, vehicle.plate)
                                QBCore.Functions.SetVehicleProperties(veh, properties)
                                exports['LegacyFuel']:SetFuel(veh, vehicle.fuel)
                                doCarDamage(veh, vehicle)
                                TriggerServerEvent('qb-garage:server:updateVehicleState', 0, vehicle.plate, index)
                                closeMenuFull()
                                TriggerEvent("vehiclekeys:client:SetOwner", vehicle.plate)
                                SetVehicleEngineOn(veh, true, true)
                                if type == "house" then
                                    exports['qb-core']:DrawText(Lang:t("info.park_e"), 'left')
                                    InputOut = false
                                    InputIn = true
                                end
                            end
                        end, vehicle, location, true)
                    else
                        QBCore.Functions.Notify(Lang:t("error.not_impound"), "error", 5000)
                    end
                end, vehicle.plate, type)
            end)

        ```
    # Not doing the above 2 function replaces will result in not receiving keys for a vehicle with a custom plate.

# Vanity Plates Inventory Installation
# [qb-inventory]
-   Add item image (if new item) to [qb-inventory/html/images/] folder (.png) (vanityplate example provided in [mk_plates] images folder)
# [ox_inventory]
-   Add item image (if new item) to [ox_inventory/web/images]
-   Add item to [ox_inventory/data/items.lua]
    ```lua

        ['vanityplate'] = {
            label = 'Vanity Plate',
            weight = 160,
            stack = false,
            close = true,
        },
        
    ```

# Config
- Follow comments inside [config/config.lua] to make edits. If you are using default QBCore/ESX database structure you won't have to edit Config.Database

# Credits
-   [Overextended] Amazing MySQL and Lib resources! (https://github.com/overextended)
-   [MauriceButler] Profanity Filter (https://github.com/MauriceButler/badwords/blob/master/array.js)

# Exports
- exports["mk_plates"]:HasFakePlate(NetId) [Server] export you can use to check if a vehicle has a fake plate. 
-   Example of use:
    ```lua

        local src = source 
        local Vehicle = GetVehiclePedIsIn(PlayerPedId(src), false)
        if Vehicle > 0 then 
            local FakePlate = exports["mk_plates"]:HasFakePlate(NetworkGetNetworkIdFromEntity(Vehicle))
            if FakePlate then 
                print('this return is the fake plate number', FakePlate)
            else
                print('no fake plate on this vehicle')
            end
        end

    ```
    # You can use this export in any Server side file if you wish to add fake plate checks into any of your other scripts!

- exports["mk_plates"]:HasFakePlate(VehicleEntity) [Client] export you can use to check if a vehicle has a fake plate.
-   Example of use:
    ```lua

        if IsPedInAnyVehicle(PlayerPedId(), false) then 
            local curVeh = GetVehiclePedIsIn(PlayerPedId(), false)
            local Fake = exports["mk_plates"]:HasFakePlate(curVeh)
            if Fake then 
                print(curVeh, 'has a fake plate of', Fake)
            else
                print(curVeh, 'has no fake plate')
            end
        end
    
    ```

- exports["mk_plates"]:RemoveFakePlate(VehicleEntity, GiveKeys) [Client] export you can use client side to remove a fake plate from a vehicle (example: have police be able to remove a fake plate)
-   Please note if you call this export and the vehicle does not have a fake plate listed in the database then nothing happens
-   GiveKeys input should be a boolean. true = give keys to the person that removes the plate / false = do not give keys
-   Example of use:
    ```lua

        local vehicle = QBCore.Functions.GetClosestVehicle()
        if vehicle and vehicle > 0 then
            exports['mk_plates']:RemoveFakePlate(vehicle, false)
        end

    ```

# Notes
-   If you wish to add checks for fake plates in scripts that are already checking for plate numbers you will have to edit your MySQL queries.
        Example: 
            (Current) local Result = MySQL.query.await('SELECT * FROM player_vehicles WHERE plate = ?', {plate})
            (Replacement) local Result = MySQL.query.await('SELECT * FROM player_vehicles WHERE (plate = :vehplate OR fakeplate = :vehplate)', {vehplate = plate})
    #       This allows the script to still locate your vehicle even if it has a fake plate equipped.




