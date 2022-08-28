local QBCore = exports['qb-core']:GetCoreObject()
local plyCarryingObjects = {}

RegisterNetEvent("propattach:carryingItem")
AddEventHandler("propattach:carryingItem", function(pCarrying)
    local src = source
	
    plyCarryingObjects[src] = pCarrying
end)

QBCore.Functions.CreateCallback("isPlayerCarryingObjects", function(source, cb)
    local src = source
    local isPlyCarrying = plyCarryingObjects[src]

    if isPlyCarrying then
        cb(true)
    else
        cb(false)
    end
end)  