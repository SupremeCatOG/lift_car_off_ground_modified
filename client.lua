local decorRegistered = false

local waitTime = 75

local height = 0.15
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- Function to check if vehicle is a car
-----------------------------------------------------------------------------------------------------------------------------------------------------
IsCar = function(veh)
		    local vc = GetVehicleClass(veh)
		    return (vc >= 0 and vc <= 7) or (vc >= 9 and vc <= 12) or (vc >= 17 and vc <= 20)
        end	
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- decor management --
-----------------------------------------------------------------------------------------------------------------------------------------------------
Citizen.CreateThread(function()
	while not decorRegistered do
		if NetworkIsSessionStarted() then
			DecorRegister('isRaised', 2)
			DecorRegister('jackStand1', 3)
			DecorRegister('jackStand2', 3)
			DecorRegister('jackStand3', 3)
			DecorRegister('jackStand4', 3)
			decorRegistered = true
		end
		Wait(200)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- raise the closest car --
-----------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("raisecar", function()
	local netId = getNearestVeh()
	local veh = NetworkGetEntityFromNetworkId(netId)
	if IsEntityAVehicle(veh) and IsCar(veh) and not(IsPedInAnyVehicle(ped, false)) and IsVehicleSeatFree(veh, -1) and IsVehicleStopped(veh) and (not DecorExistOn(veh, 'isRaised') or not DecorGetBool(veh, 'isRaised')) then
		TriggerServerEvent(GetCurrentResourceName() .. ":raiseCar", netId)
	end
end)

RegisterNetEvent(GetCurrentResourceName() .. ":raiseCar")
AddEventHandler(GetCurrentResourceName() .. ":raiseCar", function(netId, playerId)
	local veh = NetworkGetEntityFromNetworkId(netId)
	local ped = PlayerPedId()

	DecorSetBool(veh, 'isRaised', true)
	FreezeEntityPosition(veh, true)
	local vehpos = GetEntityCoords(veh)

	if playerId == GetPlayerServerId(PlayerId()) then
		local model = 'xs_prop_x18_axel_stand_01a'

		while not HasModelLoaded(model) do
			RequestModel(model)
			Wait(1)
		end

		local flWheelStand = CreateObject(GetHashKey(model), vehpos.x - 0.5, vehpos.y + 1.0, vehpos.z - 0.5, true, true, true)
		PlaceObjectOnGroundProperly(flWheelStand)
		DecorSetInt(veh, 'jackStand1', NetworkGetNetworkIdFromEntity(flWheelStand))

		local frWheelStand = CreateObject(GetHashKey(model), vehpos.x + 0.5, vehpos.y + 1.0, vehpos.z - 0.5, true, true, true)
		PlaceObjectOnGroundProperly(frWheelStand)
		DecorSetInt(veh, 'jackStand2', NetworkGetNetworkIdFromEntity(frWheelStand))

		local rlWheelStand = CreateObject(GetHashKey(model), vehpos.x - 0.5, vehpos.y - 1.0, vehpos.z - 0.5, true, true, true)
		PlaceObjectOnGroundProperly(rlWheelStand)
		DecorSetInt(veh, 'jackStand3', NetworkGetNetworkIdFromEntity(rlWheelStand))

		local rrWheelStand = CreateObject(GetHashKey(model), vehpos.x + 0.5, vehpos.y - 1.0, vehpos.z - 0.5, true, true, true)
		PlaceObjectOnGroundProperly(rrWheelStand)
		DecorSetInt(veh, 'jackStand4', NetworkGetNetworkIdFromEntity(rrWheelStand))

		AttachEntityToEntity(flWheelStand, veh, 0, -0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(frWheelStand, veh, 0, 0.5, 1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(rlWheelStand, veh, 0, -0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)
		AttachEntityToEntity(rrWheelStand, veh, 0, 0.5, -1.0, -0.8, 0.0, 0.0, 0.0, false, false, false, false, 0, true)	
	end

	local addZ = 0

	while addZ < height do
		addZ = addZ + 0.001
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z + addZ, true, true, true)
		Citizen.Wait(waitTime)
	end
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- lower the previously raised car --
-----------------------------------------------------------------------------------------------------------------------------------------------------
RegisterCommand("lowercar", function()
	local netId = getNearestVeh()
	local veh = NetworkGetEntityFromNetworkId(netId)
    if (DecorExistOn(veh, 'isRaised') and DecorGetBool(veh, 'isRaised')) then
		TriggerServerEvent(GetCurrentResourceName() .. ":lowerCar", netId)
	end
end)

RegisterNetEvent(GetCurrentResourceName() .. ":lowerCar")
AddEventHandler(GetCurrentResourceName() .. ":lowerCar", function(netId, playerId)
	local veh = NetworkGetEntityFromNetworkId(netId)

	local WheelStand1 = nil
	local WheelStand2 = nil
	local WheelStand3 = nil
	local WheelStand4 = nil

	NetworkRequestControlOfEntity(veh)
	if DecorExistOn(veh, 'jackStand1') then
		WheelStand1 = NetworkGetEntityFromNetworkId(DecorGetInt(veh, 'jackStand1'))
		NetworkRequestControlOfEntity(WheelStand1)
	end
	if DecorExistOn(veh, 'jackStand2') then
		WheelStand2 = NetworkGetEntityFromNetworkId(DecorGetInt(veh, 'jackStand2'))
		NetworkRequestControlOfEntity(WheelStand2)
	end
	if DecorExistOn(veh, 'jackStand3') then
		WheelStand3 = NetworkGetEntityFromNetworkId(DecorGetInt(veh, 'jackStand3'))
		NetworkRequestControlOfEntity(WheelStand3)
	end
	if DecorExistOn(veh, 'jackStand4') then
		WheelStand4 = NetworkGetEntityFromNetworkId(DecorGetInt(veh, 'jackStand4'))
		NetworkRequestControlOfEntity(WheelStand4)
	end

	local vehpos = GetEntityCoords(veh)

	local removeZ = 0

	while removeZ < height do
		removeZ = removeZ + 0.001
		SetEntityCoordsNoOffset(veh, vehpos.x, vehpos.y, vehpos.z - removeZ, true, true, true)
		Citizen.Wait(waitTime)
	end

	DetachEntity(WheelStand1)
	SetEntityAsNoLongerNeeded(WheelStand1)
	DeleteObject(WheelStand1)

	DetachEntity(WheelStand2)
	SetEntityAsNoLongerNeeded(WheelStand2)
	DeleteObject(WheelStand2)

	DetachEntity(WheelStand3)
	SetEntityAsNoLongerNeeded(WheelStand3)
	DeleteObject(WheelStand3)

	DetachEntity(WheelStand4)
	SetEntityAsNoLongerNeeded(WheelStand4)
	DeleteObject(WheelStand4)

	FreezeEntityPosition(veh, false)

	DecorSetBool(veh, 'isRaised', false)
end)
-----------------------------------------------------------------------------------------------------------------------------------------------------
-- get nearest vehicle function
-----------------------------------------------------------------------------------------------------------------------------------------------------
function getNearestVeh()
	local pos = GetEntityCoords(PlayerPedId())
		local entityWorld = GetOffsetFromEntityInWorldCoords(PlayerPedId(), 0.0, 20.0, 0.0)

		local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, PlayerPedId(), 0)
		local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
		local netId = NetworkGetNetworkIdFromEntity(vehicleHandle)
	return netId
end