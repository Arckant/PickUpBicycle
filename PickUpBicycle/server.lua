RegisterNetEvent("SetClimbUpMarker", function(animOffset, heading, endPoint)
	local initiator = source
	TriggerClientEvent('ClimbUpMarker', -1, animOffset, heading, endPoint, initiator)
end)

RegisterNetEvent("TriggerClimbUpMarker", function(animOffset, heading, initiator)
	TriggerClientEvent('ClimbUp1', initiator)
	TriggerClientEvent('ClimbUp2', source, animOffset, heading)
	print(initiator, source)
	
end)

RegisterNetEvent("DeleteClimbUpMarker", function()
	TriggerClientEvent('DeleteClimbUpMarker', -1)
end)



RegisterNetEvent("SetBoostMarker", function(offset, animOffset, heading, entity)
	local initiator = source
	local entity = CreateObject(-1186769817, offset.x, offset.y, offset.z - 0.15, true, false)
	while not DoesEntityExist(entity) do Wait(1) end
	local entity = NetworkGetNetworkIdFromEntity(entity)
	TriggerClientEvent('BoostMarker', -1, offset, animOffset, heading, entity, initiator)
	TriggerClientEvent('BoostEntityRemove', initiator, entity)
end)

RegisterNetEvent("TriggerBoostMarker", function(animOffset, heading, entity, initiator)
	TriggerClientEvent('Boost1', initiator)
	TriggerClientEvent('Boost2', source, animOffset, heading, entity)
end)

RegisterNetEvent("DeleteBoostMarker", function(entity)
	DeleteEntity(NetworkGetEntityFromNetworkId(entity))
	TriggerClientEvent('DeleteBoostMarker', -1, entity)
end)