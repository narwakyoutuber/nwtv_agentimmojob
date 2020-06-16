ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'realestateagent', Config.MaxInService)
end

TriggerEvent('esx_phone:registerNumber', 'realestateagent', _U('agent_client'), true, true)
TriggerEvent('esx_society:registerSociety', 'realestateagent', 'Realestateagent', 'society_realestateagent', 'society_realestateagent', 'society_realestateagent', {type = 'public'})

--agentimmo
RegisterServerEvent('nwtv_agentimmijob:revoke')
AddEventHandler('nwtv_agentimmijob:revoke', function(property, owner)
	local xPlayer = ESX.GetPlayerFromId(source)

	if xPlayer.job.name == 'realestateagent' then
		TriggerEvent('esx_property:removeOwnedPropertyIdentifier', property, owner)
	else
		print(('nwtv_agentimmijob: %s attempted to revoke a property!'):format(xPlayer.identifier))
	end
end)

RegisterServerEvent('nwtv_agentimmijob:sell')
AddEventHandler('nwtv_agentimmijob:sell', function(target, property, price)
	local xPlayer, xTarget = ESX.GetPlayerFromId(source), ESX.GetPlayerFromId(target)

	if xPlayer.job.name ~= 'realestateagent' then
		print(('nwtv_agentimmijob: %s attempted to sell a property!'):format(xPlayer.identifier))
		return
	end

	if xTarget.getMoney() >= price then
		xTarget.removeMoney(price)

		TriggerEvent('esx_addonaccount:getSharedAccount', 'society_realestateagent', function(account)
			account.addMoney(price)
		end)
	
		TriggerEvent('esx_property:setPropertyOwned', property, price, false, xTarget.identifier)
	else
		TriggerClientEvent('esx:showNotification', xPlayer.source, _U('client_poor'))
	end
end)

RegisterServerEvent('nwtv_agentimmijob:rent')
AddEventHandler('nwtv_agentimmijob:rent', function(target, property, price)
	local xPlayer = ESX.GetPlayerFromId(target)

	TriggerEvent('esx_property:setPropertyOwned', property, price, true, xPlayer.identifier)
end)

ESX.RegisterServerCallback('nwtv_agentimmijob:getCustomers', function(source, cb)
	TriggerEvent('esx_ownedproperty:getOwnedProperties', function(properties)
		local xPlayers  = ESX.GetPlayers()
		local customers = {}

		for i=1, #properties, 1 do
			for j=1, #xPlayers, 1 do
				local xPlayer = ESX.GetPlayerFromId(xPlayers[j])

				if xPlayer.identifier == properties[i].owner then
					table.insert(customers, {
						name           = xPlayer.name,
						propertyOwner  = properties[i].owner,
						propertyRented = properties[i].rented,
						propertyId     = properties[i].id,
						propertyPrice  = properties[i].price,
						propertyName   = properties[i].name,
						propertyLabel  = properties[i].label
					})
				end
			end
		end

		cb(customers)
	end)
end)

RegisterServerEvent('nwtv_agentimmijob:dutyoff')
AddEventHandler('nwtv_agentimmijob:dutyoff', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if job == 'realestateagent' then
        xPlayer.setJob('offrealestateagent', grade)
    end

end)

RegisterServerEvent('nwtv_agentimmijob:dutyon')
AddEventHandler('nwtv_agentimmijob:dutyon', function(job)

    local _source = source
    local xPlayer = ESX.GetPlayerFromId(_source)
    local job = xPlayer.job.name
    local grade = xPlayer.job.grade
    
    if job == 'offrealestateagent' then
        xPlayer.setJob('realestateagent', grade)
    end

end)