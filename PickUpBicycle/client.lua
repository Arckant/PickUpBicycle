local anims = {
	{'veh@aligns@bike@ds', 'pickup'},
	{'amb@lo_res_idles@', 'world_human_bum_freeway_lo_res_base'}
}

RegisterCommand('PickUpBicycle', function())
	player = PlayerPedId()
	
	local flag_PedHit, PedCoords, target = GetVehicleInDirection(GetEntityCoords(player), GetPlayerLookingVector(player, 3), 2)
	
	if GetVehicleType(target) == "bike" and GetPedInVehicleSeat(target, -1) == 0 then return end
		
	NetworkRequestControlOfNetworkId(VehToNet(target))
	
	RequestAnimDict(anims[2][1])
	local i = 0
	RequestAnimDict(anims[2][1])
	while not HasAnimDictLoaded(anims[2][1]) and i < 30 do
		i = i + 1
		Citizen.Wait(10)
	end
	if not HasAnimDictLoaded(anims[2][1]) then return end
	
	TaskPlayAnim(player, anims[2][1], anims[2][2], 4.0, 4.0, -1, 50, 0.0)

	local delta = GetEntityHeading(target) - GetEntityHeading(player)
	if delta > 180 then delta = 360 - delta end
	if delta < -180 then delta = 360 + delta end
	local bcRot
	if delta >= 0 then bcRot = 90.0 else bcRot = -90.0 end
	
	AttachEntityToEntity(target, player, GetPedBoneIndex(player, 0x60F2), -0.25, 0.3, -0.1, 0.0, 90.0, bcRot, 1, 1, 1, 0, 1, 1)
	Wait(150)
	
	while IsEntityPlayingAnim(player, 'amb@lo_res_idles@', 'world_human_bum_freeway_lo_res_base', 3) do
		Wait(50)
	end
	
	if Raycast(GetOffsetFromEntityInWorldCoords(player, 0.0, 0.0, 0.0), GetOffsetFromEntityInWorldCoords(player, 0.0, 1.0, 0.0)) ~= nil then
		SetEntityCoords(player, GetOffsetFromEntityInWorldCoords(player, 0.0, -0.3, -1.0), 1, 0, 0, 0)
	end
	
	DetachEntity(target, 1, 1)
end

function GetPlayerLookingVector(playerped, radius)
	local yaw = GetEntityHeading(playerped)
	local pitch = 90.0-GetGameplayCamRelativePitch()

	if yaw > 180 then
		yaw = yaw - 360
	elseif yaw < -180 then
		yaw = yaw + 360
	end

	local pitch = pitch * math.pi / 180
	local yaw = yaw * math.pi / 180
	local x = radius * math.sin(pitch) * math.sin(yaw)
	local y = radius * math.sin(pitch) * math.cos(yaw)
	local z = radius * math.cos(pitch)

	local playerpedcoords = GetEntityCoords(playerped)
	local xcorr = -x+ playerpedcoords.x
	local ycorr = y+ playerpedcoords.y
	local zcorr = z+ playerpedcoords.z
	local Vector = vector3(tonumber(xcorr), tonumber(ycorr), tonumber(zcorr))
	return Vector
end

function Raycast(coordFrom, coordTo, hitTarget)
	local ped = PlayerPedId()
	if hitTarget == nil then hitTarget = 4294967295 end
	local shapeTest = StartShapeTestLosProbe(coordFrom, coordTo, hitTarget, GetPlayerPed(-1), 0)
	local retval, hit, endCoords, surfaceNormal, entityHit
	local i
	
	while i ~= 2 do
		retval, hit, endCoords, surfaceNormal, entityHit = GetShapeTestResult(shapeTest)
		i = retval
		Wait(0)
	end
	if hit == 1 then return entityHit end
	return nil
end
