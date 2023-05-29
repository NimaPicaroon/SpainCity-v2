W = exports.ZCore:get()

-- Blacklisted vehicle models
BlacklistedCars = {
    [GetHashKey('police')] = true,
    [GetHashKey('police2')] = true,
    [GetHashKey('police3')] = true,
    [GetHashKey('police4')] = true,
    [GetHashKey('policeb')] = true,
    [GetHashKey('policeold1')] = true,
    [GetHashKey('policeold2')] = true,
    [GetHashKey('pranger')] = true,
    --[GetHashKey('predator')] = true,
    [GetHashKey('sheriff')] = true,
    --[GetHashKey('fbi')] = true,
    --[GetHashKey('fbi2')] = true,
    [GetHashKey('sheriff2')] = true,
    [GetHashKey('rhino')] = true,
    [GetHashKey('buzzard')] = true,
    [GetHashKey('buzzard2')] = true,
    --[GetHashKey('polmav')] = true,
    [GetHashKey('frogger')] = true,
    [GetHashKey('lazer')] = true,
    [GetHashKey('cargoplane')] = true,
    [GetHashKey('blimp')] = true,
    [GetHashKey('blimp2')] = true,
    [GetHashKey('blimp3')] = true,
    --[GetHashKey('dump')] = true,
    --[GetHashKey('cutter')] = true,
    --[GetHashKey('bulldozer')] = true,
    [GetHashKey('oppressor2')] = true,
    [GetHashKey('oppressor')] = true,
    [GetHashKey('khanjali')] = true,
    [GetHashKey('minitank')] = true,
    --[GetHashKey('rcbandito')] = true,
    [GetHashKey('apc')] = true,
    [GetHashKey('luxor')] = true,
    [GetHashKey('luxor2')] = true,
    [GetHashKey('miljet')] = true,
    [GetHashKey('shamal')] = true,
    [GetHashKey('nimbus')] = true,
    [GetHashKey('jet')] = true,
    [GetHashKey('titan')] = true
}

function isCarBlacklisted(Model)
    if not Model then return end
    
    if BlacklistedCars[Model] then
        return true
    end

    return false
end

Citizen.CreateThread(function()
    DisableIdleCamera(true)

	while true do
        local Vehicles = GetGamePool('CVehicle')

        for key, value in next, Vehicles do
            local Model = GetEntityModel(value)

            if DoesEntityExist(value) and isCarBlacklisted(Model) then
                DeleteEntity(value)
                DeleteVehicle(value)
            end
        end

        Citizen.Wait(1000)
	end
end)