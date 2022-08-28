QBCore = exports['qb-core']:GetCoreObject()

QBCore.Commands.Add("giveitem", "Eşya Ver", {
    {name="id", help="Oyunucun İD'si"},
    {name="item", help="Eşya"},
    {name="amount", help="Adet"}
}, true, function(source, args)
    -- print(json.encode(args))
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))
	local item    = args[2]
	local count   = (args[3] == nil and 1 or tonumber(args[3]))

	if count ~= nil then
		if xPlayer ~= nil then
            TriggerClientEvent('player:receiveItem', xPlayer.PlayerData.source, ""..item.."", count)
		else
            TriggerClientEvent('notify', source, 'Geçersiz Kişi', 2)
		end
	else
        TriggerClientEvent('notify', source, 'Geçersiz adet', 2)
	end
end, "admin")


QBCore.Commands.Add("openinv", "Envanterini aç", {
    {name="id", help="Oyunucun İD'si"}
}, true, function(source, args)
    -- print(json.encode(args))
	local _source = source
	local xPlayer = QBCore.Functions.GetPlayer(tonumber(args[1]))


		if xPlayer ~= nil then
			TriggerServerEvent("searching-person", GetPlayerServerId(xPlayer.PlayerData.source))
		else
            TriggerClientEvent('notify', source, 'Geçersiz Kişi', 2)
		end
end, "admin")

