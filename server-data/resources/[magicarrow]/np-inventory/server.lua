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

local ammoTable = {}

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

RegisterServerEvent("cash:remove")
AddEventHandler("cash:remove", function(pSource, pAmount)
    local QBCore = exports['qb-core']:GetCoreObject()
    local src = pSource
    local Player = QBCore.Functions.GetPlayer(src)

    Player.Functions.RemoveMoney("cash", pAmount) 
end)


function GetCurrentWeapons()
    local returnTable = {}
    for i,v in pairs(clientInventory) do
        if (tonumber(v.item_id)) then
            local t = { ["hash"] = v.item_id, ["id"] = v.id, ["information"] = v.information, ["name"] = v.item_id, ["slot"] = v.slot }
            returnTable[#returnTable+1]=t
        end
    end
    if returnTable == nil then
        return {}
    end
    return returnTable
end

function getFreeSpace()
    local space = 40
    for i,v in pairs(clientInventory) do
        if v.item_id then
            space = space - 1
        end
    end
    return space
end

function getQuantity(itemid, checkQuality, metaInformation)
  local amount = 0
  for i,v in pairs(clientInventory) do
      local qCheck = not checkQuality or v.quality > 0
      if v.item_id == itemid and qCheck then
          if metaInformation then
              local totalMetaKeys = 0
              local metaFoundCount = 0
              local itemMeta = json.decode(v.information)
              for metaKey, metaValue in pairs(metaInformation) do
                  totalMetaKeys = totalMetaKeys + 1
                  if itemMeta[metaKey] and itemMeta[metaKey] == metaValue then
                      metaFoundCount = metaFoundCount + 1
                  end
              end
              if totalMetaKeys <= metaFoundCount then
                  amount = amount + v.amount
              end
          else
              amount = amount + v.amount
          end
      end
  end
  return amount
end

function hasEnoughOfItem(itemid,amount,shouldReturnText,checkQuality, metaInformation)
  if shouldReturnText == nil then shouldReturnText = true end
  if itemid == nil or itemid == 0 or amount == nil or amount == 0 then
      if shouldReturnText then
          TriggerEvent("DoLongHudText","I dont seem to have " .. itemid .. " in my pockets.",2)
      end
      return false
  end
  amount = tonumber(amount)
  local slot = 0
  local found = false

  if getQuantity(itemid, checkQuality, metaInformation) >= amount then
      return true
  end
  if (shouldReturnText) then
      TriggerEvent("DoLongHudText","I dont have enough of that item...",2)
  end
  return false
end


function getItemsOfType(itemid, limitAmount, checkQuality, metaInformation)
    if itemid == nil then
        return nil
    end
    local minQuality = type(checkQuality) == "number" and checkQuality or 0
    local itemsFound = {}
    local amount = tonumber(limitAmount)
    for i,v in pairs(clientInventory) do
        if amount and #itemsFound >= amount then
            break
        end

        local qCheck = not checkQuality or v.quality > minQuality
        if v.item_id == itemid and qCheck then
          if metaInformation then
              local totalMetaKeys = 0
              local metaFoundCount = 0
              local itemMeta = json.decode(v.information)
              for metaKey, metaValue in pairs(metaInformation) do
                  totalMetaKeys = totalMetaKeys + 1
                  if itemMeta[metaKey] and itemMeta[metaKey] == metaValue then
                      metaFoundCount = metaFoundCount + 1
                  end
              end
              if totalMetaKeys <= metaFoundCount then
                  itemsFound[#itemsFound+1] = v
              end
          else
              itemsFound[#itemsFound+1] = v
          end
      end
  end
  return itemsFound
end