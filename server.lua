-- raise the closest car --
RegisterNetEvent(GetCurrentResourceName() .. ":raiseCar")
AddEventHandler(GetCurrentResourceName() .. ":raiseCar", function(netId)
	TriggerClientEvent(GetCurrentResourceName() .. ":raiseCar", -1, netId, source)
end)

RegisterNetEvent(GetCurrentResourceName() .. ":lowerCar")
AddEventHandler(GetCurrentResourceName() .. ":lowerCar", function(netId)
	TriggerClientEvent(GetCurrentResourceName() .. ":lowerCar", -1, netId, source)
end)