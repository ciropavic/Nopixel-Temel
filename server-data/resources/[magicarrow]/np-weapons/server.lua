
RegisterServerEvent('np-weapons:weaponEquiped')
AddEventHandler('np-weapons:weaponEquiped', function(pWeaponHash, newInformation, sqlID, itemToRemove, pArmed)
end)    

RegisterServerEvent('np-weapons:updateAmmo')
AddEventHandler('np-weapons:updateAmmo', function(pAmmo, pType, pTable)
    local QBCore = exports['qb-core']:GetCoreObject()
    local src = source
    local Player = QBCore.Functions.GetPlayer(src)
    local char = Player.PlayerData.citizenid

    exports.oxmysql:executeSync("SELECT ammo FROM player_weapons WHERE type = @type AND cid = @cid", { ['@type'] = pType, ['@cid'] = char }, function(result)
        if result[1] == nil then
            MySQL.insert('INSERT INTO player_weapons (cid, type, ammo) VALUES (@cid, @type, @ammo)', {
                ['@cid'] = char,
                ['@type'] = pType,
                ['@ammo'] = pAmmo
            })
        else
            MySQL.update('UPDATE player_weapons SET ammo = @newammo WHERE type = @type AND ammo = @ammo AND cid = @cid', {
                ['@cid'] = char,
                ['@type'] = pType,
                ['@ammo'] = result[1].ammo,
                ['@newammo'] = pAmmo
            })
        end
    end)    
end)

RegisterServerEvent('np-weapons:getAmmo')
AddEventHandler('np-weapons:getAmmo', function()
    local QBCore = exports['qb-core']:GetCoreObject()
    local src = source
	local Player = QBCore.Functions.GetPlayer(src)
    local char = Player.PlayerData.citizenid

    exports.oxmysql:executeSync("SELECT type, ammo FROM player_weapons WHERE cid = @cid", { ['@cid'] = char }, function(result)
        for i = 1, #result do
            if ammoTable["" .. result[i].type .. ""] == nil then
                ammoTable["" .. result[i].type .. ""] = {}
                ammoTable["" .. result[i].type .. ""]["ammo"] = result[i].ammo
                ammoTable["" .. result[i].type .. ""]["type"] = ""..result[i].type..""
            end
        end

        TriggerClientEvent('np-items:SetAmmo', src, ammoTable)
    end)
end)