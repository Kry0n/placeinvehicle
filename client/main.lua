invehicle = false

RegisterCommand('pv', function(source, args)
	local player, distance = GetClosestPlayer()
    if(distance ~= -1 and distance < 3) then
        if not invehicle then
            local v = GetVehiclePedIsIn(PlayerPedId(), true)
            TriggerServerEvent("pv-command:seatPlayerSV", GetPlayerServerId(player))
            invehicle = true
        else 
            TriggerServerEvent("pv-command:unseatPlayerSV", GetPlayerServerId(player))
            invehicle = false
        end
	else
	    TriggerEvent("chatMessage", "No Player Nearby")
	end
end)

RegisterNetEvent("pv-command:seatPlayer")
AddEventHandler("pv-command:seatPlayer", function()
    local pos = GetEntityCoords(GetPlayerPed(-1))
    local entityWorld = GetOffsetFromEntityInWorldCoords(GetPlayerPed(-1), 0.0, 20.0, 0.0)
    local rayHandle = CastRayPointToPoint(pos.x, pos.y, pos.z, entityWorld.x, entityWorld.y, entityWorld.z, 10, GetPlayerPed(-1), 0)
    local _, _, _, _, vehicleHandle = GetRaycastResult(rayHandle)
    if vehicleHandle ~= nil then
        SetPedIntoVehicle(GetPlayerPed(-1), vehicleHandle, 2)
    end
end)

RegisterNetEvent("pv-command:unseatPlayer")
AddEventHandler("pv-command:unseatPlayer", function(pl)
	local ped = GetPlayerPed(pl)
	ClearPedTasksImmediately(ped)
	plyPos = GetEntityCoords(PlayerPedId(),  true)
	local xnew = plyPos.x-0
	local ynew = plyPos.y-0
	SetEntityCoords(PlayerPedId(), xnew, ynew, plyPos.z)
end)

function GetPlayers()
    local players = {}

    for i = 0, 31 do
        if NetworkIsPlayerActive(i) then
            table.insert(players, i)
        end
    end

    return players
end

function GetClosestPlayer()
	local players = GetPlayers()
	local closestDistance = -1
	local closestPlayer = -1
	local ply = PlayerPedId()
	local plyCoords = GetEntityCoords(ply, 0)
	
	for index,value in ipairs(players) do
		local target = GetPlayerPed(value)
		if target ~= ply then
			local targetCoords = GetEntityCoords(GetPlayerPed(value), 0)
			local distance = Vdist(targetCoords["x"], targetCoords["y"], targetCoords["z"], plyCoords["x"], plyCoords["y"], plyCoords["z"])
			if(closestDistance == -1 or closestDistance > distance) then
				closestPlayer = value
				closestDistance = distance
			end
		end
	end
	return closestPlayer, closestDistance
end