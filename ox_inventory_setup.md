# ox_inventory setup for mk_plates
# version 2.23.4+ [ox_inventory]

# Note - Lua code is wrapped in ```` ```lua``` ```` inside this file for visual purposes. Do not add this to your file, just the code located between the backticks ```` ``` ```` example: ```` ```lua (this is the code) ``` ````

-   navigate to [ox_inventory/modules/inventory/server.lua]
    - replace function `prepareInventorySave` with:
        ```lua
        
            local function prepareInventorySave(inv, buffer, time)
                local shouldSave = not inv.datastore and inv.changed
                local n = 0

                for k, v in pairs(inv.items) do
                    if not Items.UpdateDurability(inv, v, Items(v.name), nil, time) and shouldSave then
                        n += 1
                        buffer[n] = {
                            name = v.name,
                            count = v.count,
                            slot = k,
                            metadata = next(v.metadata) and v.metadata or nil
                        }
                    end
                end

                if not shouldSave then return end

                local data = next(buffer) and json.encode(buffer) or nil
                inv.changed = false
                table.wipe(buffer)

                if inv.player then
                    if shared.framework == 'esx' then return end

                    return 1, { data, inv.owner }
                end

                if inv.type == 'trunk' then
                    return 2, fakeColumn and {data, inv.dbId, inv.dbId } or { data, inv.dbId }
                end

                if inv.type == 'glovebox' then
                    return 3, fakeColumn and {data, inv.dbId, inv.dbId } or { data, inv.dbId }
                end

                return 4, { data, inv.owner and tostring(inv.owner) or '', inv.dbId }
            end
        
        ```
-   navigate to [ox_inventory/modules/mysql/server.lua]
    -   on the first empty line in this file add the following
        ```lua
        
            fakeColumn = false

        ```
    -   locate `local Query = {}`
        -   replace `SELECT_GLOVEBOX` `SELECT_TRUNK` `UPDATE_TRUNK` `UPDATE_GLOVEBOX` inside this table with the following:
            ```lua
            
                SELECT_GLOVEBOX = 'SELECT plate, glovebox FROM `{vehicle_table}` WHERE `{vehicle_column}`',
                SELECT_TRUNK = 'SELECT plate, trunk FROM `{vehicle_table}` WHERE `{vehicle_column}`',
                UPDATE_TRUNK = 'UPDATE `{vehicle_table}` SET trunk = ? WHERE `{vehicle_column}`',
                UPDATE_GLOVEBOX = 'UPDATE `{vehicle_table}` SET glovebox = ? WHERE `{vehicle_column}`',
            
            ```
    -   replace `if shared.framework == 'ox'` entire if statement with the following:
        ```lua
        
            if shared.framework == 'ox' then
                    playerTable = 'character_inventory'
                    playerColumn = 'charid'
                    vehicleTable = 'vehicles'
                    vehicleColumn = 'id'
                    fakeColumn = 'fakeplate'
                elseif shared.framework == 'esx' then
                    playerTable = 'users'
                    playerColumn = 'identifier'
                    vehicleTable = 'owned_vehicles'
                    vehicleColumn = 'plate'
                    fakeColumn = 'fakeplate'
                elseif shared.framework == 'qb' then
                    playerTable = 'players'
                    playerColumn = 'citizenid'
                    vehicleTable = 'player_vehicles'
                    vehicleColumn = 'plate'
                    fakeColumn = 'fakeplate'
                elseif shared.framework == 'nd' then
                    playerTable = 'characters'
                    playerColumn = 'character_id'
                    vehicleTable = 'vehicles'
                    vehicleColumn = 'id'
                    fakeColumn = 'fakeplate'
                end
        
        ```

    - replace `Query[k] = ` entire statement with the following:
        ```lua
        
            Query[k] = v:gsub('{user_table}', playerTable):gsub('{user_column}', playerColumn):gsub('{vehicle_table}', vehicleTable):gsub('`{vehicle_column}`', vehicleColumn and (fakeColumn and '`'..vehicleColumn..'` = ? OR `'..fakeColumn..'` = ?' or '`'..vehicleColumn..'` = ?') or '`'..vehicleColumn..'` = ?')
        
        ```

    - replace `db.saveGlovebox` `db.loadGlovebox` `db.saveTrunk` `db.loadTrunk` functions with the following:
        ```lua
        
            function db.saveGlovebox(id, inventory)
                return MySQL.prepare(Query.UPDATE_GLOVEBOX, fakeColumn and { inventory,  id, id } or {inventory, id})
            end

            function db.loadGlovebox(id)
                return MySQL.prepare.await(Query.SELECT_GLOVEBOX, fakeColumn and { id, id } or { id })
            end

            function db.saveTrunk(id, inventory)
                return MySQL.prepare(Query.UPDATE_TRUNK, fakeColumn and { inventory, id, id } or { inventory, id })
            end

            function db.loadTrunk(id)
                return MySQL.prepare.await(Query.SELECT_TRUNK, fakeColumn and { id, id } or { id })
            end
        
        ```