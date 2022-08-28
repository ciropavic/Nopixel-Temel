local QBCore = exports['qb-core']:GetCoreObject()

RegisterServerEvent('update-cid', function()
    local ply = QBCore.Functions.GetPlayer(source)
    TriggerClientEvent('updatecid', source, ply.PlayerData.citizenid)
    TriggerClientEvent('isPed:UpdateCash', source, ply.PlayerData.money.cash)
    TriggerClientEvent('banking:updateBalance', source, ply.PlayerData.money.bank)
end)