local Weapons = {}
local Loaded = true
local realWeapons = Cfg.RealWeapons
local handgunFlag = 'backhandgun'
local rifleFlag = 'assault'
local offsetCoords = nil
local weaponCategoryOffsets = {}
local showPistol = true
local showRifle = true
local showKnife = true
local holstered  = true
local switched = false
local canUse = true

local LoadWeapons = false

CanUseWeapons = function ()
    return canUse
end

RegisterCommand("armas", function()
    local ped = PlayerPedId()
    if showPistol and showKnife and showRifle then
        local _canHide = true
        for i, realweapon in pairs(realWeapons) do
            if HasPedGotWeapon(ped, GetHashKey(realWeapons[i].name), false) then
                if(not realWeapons[i].canHide) then
                    _canHide = false
                end
            end
        end
        if _canHide then
            SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
            SetPedCanSwitchWeapon(ped, false)
            showPistol = false
            showKnife = false
            canUse = false
            RemoveGears()
			ExecuteCommand('do Esconderia las armas entre su ropa')
            W.Notify("ARMAS", "Has escondido tus ~y~armas", "verify")
        else
			local Character = exports['ZC-Character']:GetSkin()
			if (Character['bags_1'] == 44 or Character['bags_1'] == 85 or Character['bags_1'] == 86 or Character['bags_1'] >= 100) then
				SetCurrentPedWeapon(ped, GetHashKey('WEAPON_UNARMED'), true)
				SetPedCanSwitchWeapon(ped, false)
				showPistol = false
				showKnife = false
				showRifle = false
				canUse = false
				RemoveGears()
				ExecuteCommand('do Esconderia armas entre su ropa')
				W.Notify("ARMAS", "Has escondido tus ~y~armas", "verify")
			else
				W.Notify("ARMAS", "No puedes guardar esto entre la ropa", "error")
			end
        end
    else
		showRifle = true
        showPistol = true
        showKnife = true
        canUse = true
        SetGears()
        SetPedCanSwitchWeapon(ped, true)
        W.Notify("ARMAS", "Has sacado tus ~y~armas", "verify")
		ExecuteCommand('do Sacaria las armas entre su ropa')
    end
end)

exports("GetWeaponsObjects", function(weapon)
	if(not weapon)then
		return Weapons
	elseif(Weapons[weapon])then
		return Weapons[weapon]
	else
		return false
	end
end)

RegisterNetEvent('weapons:showBack', function()
	LoadWeapons = true
end)

CreateThread(function()
	while not NetworkIsPlayerActive(PlayerId()) do
		Wait(500)
	end

	while not W.GetPlayerData().job do
		Wait(500)
	end

	while not LoadWeapons do
		Wait(500)
	end

	Wait(3000)
	local playerPed = PlayerPedId()
	--SetPedCanSwitchWeapon(playerPed, true)
	realWeapons = Cfg.RealWeapons
	weaponCategoryOffsets = Cfg.WeaponCategoryOffsets

	local removedByCar = false
	while true do
		Wait(1000)
		playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, true) then
			if not removedByCar then
				removedByCar = true
			end
		else
			if removedByCar then
				removedByCar = false
			end
		end

		for i=1, #realWeapons, 1 do
			local weaponHash = GetHashKey(realWeapons[i].name)
			local onPlayer = false
			if HasPedGotWeapon(playerPed, weaponHash, false) and showPistol and not removedByCar then -- /arma activo y si el arma que estas intentando comprobar lo tienes encima
				for weaponName, entity in pairs(Weapons) do
					if weaponName == realWeapons[i].name then -- tienes encima el arma y dibujada
						onPlayer = true
						break
					end
				end
				if onPlayer == false and weaponHash ~= GetSelectedPedWeapon(playerPed) then -- tienes el arma encima pero no la tienes en la mano 
					if (realWeapons[i].category == 'handguns' and realWeapons[i].category == 'revolver' and realWeapons[i].category == 'bighandgun' and realWeapons[i].category == 'smallmelee') then
						if (showPistol) then
							SetGear(realWeapons[i].name)
						else
							RemoveGear(realWeapons[i].name)
						end
					elseif realWeapons[i].model ~= nil then
						SetGear(realWeapons[i].name)
					end
					-- Si está equipada, quitamos el prop.
				elseif onPlayer and weaponHash == GetSelectedPedWeapon(playerPed) then
					RemoveGear(realWeapons[i].name)
				end
			else
				RemoveGear(realWeapons[i].name)
			end
		end
	end
end)

AddEventHandler('ZCore:playerLoaded', function()
    Wait(5000)
 	Loaded = true
end)

-- Remove only one weapon that's on the ped
function RemoveGear(weapon)
	local _Weapons = {}
	for weaponName, entity in pairs(Weapons) do
		if weaponName ~= weapon then
			_Weapons[weaponName] = entity
		else
			while DoesEntityExist(entity) do DeleteObject(entity); DeleteEntity(entity);  Wait(0) end
		end
	end

	Weapons = _Weapons
end

exports('RemoveGears', function()
    RemoveGears()
end)

-- Remove all weapons that are on the ped	
function RemoveGears()
	for weaponName, entity in pairs(Weapons) do
		while DoesEntityExist(entity) do 
			DeleteObject(entity); 
			DeleteEntity(entity);  
			Wait(0) 
		end
	end
	Weapons = {}
end

-- Get the coords for the specific category 
function GetCoords(cat)
	for i=1, #weaponCategoryOffsets, 1 do
		if weaponCategoryOffsets[i].category == cat then
			return weaponCategoryOffsets[i].bone, weaponCategoryOffsets[i].x, weaponCategoryOffsets[i].y, weaponCategoryOffsets[i].z, weaponCategoryOffsets[i].xRot, weaponCategoryOffsets[i].yRot, weaponCategoryOffsets[i].zRot
		end
	end
end

-- Add one weapon on the ped
function SetGear(weapon)
	local bone       = nil
	local boneX      = 0.0
	local boneY      = 0.0
	local boneZ      = 0.0
	local boneXRot   = 0.0
	local boneYRot   = 0.0
	local boneZRot   = 0.0
	local playerPed  = PlayerPedId()
	local model      = nil
	local isPolice = nil

	for i=1, #realWeapons, 1 do
		if realWeapons[i].name == weapon then
			if realWeapons[i].category == 'handguns' or realWeapons[i].category == 'revolver' then
				if isPolice and not switched then
					offsetCoords = "handguns"
					handgunFlag = "handguns"
				else
					offsetCoords = handgunFlag
				end
			elseif realWeapons[i].category == 'machine' or realWeapons[i].category == 'assault' or realWeapons[i].category == 'shotgun' or realWeapons[i].category == 'sniper' or realWeapons[i].category == 'heavy' then
				offsetCoords = rifleFlag
			else
				offsetCoords = realWeapons[i].category
			end
			bone, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot = GetCoords(offsetCoords)
			model      = realWeapons[i].model
			break
		end
	end

	CreateThread(function()
        if not HasModelLoaded(model) and IsModelInCdimage(model) then
            RequestModel(model)
            while not HasModelLoaded(model) do
                Wait(1)
            end
        end
		local object = CreateObject(model, x, y, z, true, false, true)
		SetEntityCollision(object, false, true)
		SetEntityCompletelyDisableCollision(object, false, true)
		SetModelAsNoLongerNeeded(model)
		local boneIndex = GetPedBoneIndex(playerPed, bone)
		AttachEntityToEntity(object, playerPed, boneIndex, boneX, boneY, boneZ, boneXRot, boneYRot, boneZRot, false, false, false, false, 2, true)
		Weapons[weapon] = object
	end)
end

function SetGears()
	local playerPed  = PlayerPedId()

	for j=1, #realWeapons, 1 do
		if HasPedGotWeapon(playerPed, GetHashKey(realWeapons[j].name), false) then
			SetGear(realWeapons[j].name)
		end
	end
end

RegisterCommand('holster', function(source, args)
	if not args[1] then
		OpenHolsterMenu()
	elseif args[1] == 'handguns' or args[1] == 'waisthandgun' then
		handgunFlag = args[1]
        W.Notify('ARMAS', 'Has cambiado la posición de la pistola a la cadera')
	elseif args[1] == 'backhandgun' then 
		handgunFlag = args[1]
		W.Notify('ARMAS', 'Has cambiado la posición de la pistola a la espalda')
	elseif args[1] == 'leghandgun' or args[1] == 'hiphandgun' or args[1] == 'handguns2' then
		handgunFlag = args[1]
        W.Notify('ARMAS', 'Has cambiado la posición de la pistola a la pierna')
	elseif args[1] == 'chesthandgun' then
		handgunFlag = args[1]
		W.Notify('ARMAS', 'Has cambiado la posición de la pistola a el pecho')
	elseif args[1] == 'boxers' then
		handgunFlag = args[1]
        W.Notify('ARMAS', 'Has cambiado la posición de la pistola a los calzoncillos')
	elseif args[1] == 'assault' then
		rifleFlag = args[1]
		W.Notify('ARMAS', 'Has cambiado la posición de las armas largas a la espalda')
	elseif args[1] == 'tacticalrifle' then
		rifleFlag = args[1]
        W.Notify('ARMAS', 'Has cambiado la posición de las armas largas a el pecho')
	end
	RemoveGears()
	switched = true
end)


function OpenHolsterMenu()
	local elements = {}
	table.insert(elements, {label = "Posición de Pistolas", menu = 'pistolas'})
	table.insert(elements, {label = "Posición de Rifles y SMG", menu = 'rifles'})

    W.OpenMenu("Menú de Armas", "weapons_menu", elements, function (data, name)
		W.DestroyMenu(name)

		local select = data.menu
		if select == "pistolas" then
            Wait(200)
			OpenPistolsMenu()
		elseif select == "rifles" then
            Wait(200)
			OpenRiflesMenu()
		end
	end)
end

function OpenPistolsMenu()
	local elements = {}
	table.insert(elements, {label = "Pistola delante", command = 'boxers'})
	table.insert(elements, {label = "Pistola detrás", command = 'backhandgun'})
	table.insert(elements, {label = "Cartuchera cintura", command = 'waisthandgun'})
	table.insert(elements, {label = "Cartuchera normal", command = 'handguns'})
	table.insert(elements, {label = "Cartuchera pecho", command = 'chesthandgun'})
	table.insert(elements, {label = "Cartuchera muslo", command = 'hiphandgun'})
	table.insert(elements, {label = "Cartuchera pierna", command = 'leghandgun'})
	table.insert(elements, {label = "Cartuchera pierna separada", command = 'handguns2'})

    W.OpenMenu("Menú de posición para Pistolas", "pistols_menu", elements, function (data, name)
		W.DestroyMenu(name)

		local select = data.command
		if select then
            ExecuteCommand("holster " .. select)
            Wait(200)
            OpenHolsterMenu()
		end
	end)
end

function OpenRiflesMenu()
	local elements = {}
	table.insert(elements, {label = "Rifle pecho", command = 'tacticalrifle'})
	table.insert(elements, {label = "Rifle espalda", command = 'assault'})

    W.OpenMenu("Menú de posición para Pistolas", "rifles_menu", elements, function (data, name)
		W.DestroyMenu(name)

		local select = data.command
		if select then
            ExecuteCommand("holster " .. select)
            Wait(100)
            OpenHolsterMenu()
		end
	end)
end

-- ###########################################################################################
-- ANIMACIONES DE ARMAS
-- ###########################################################################################
function loadAnimDict(dict)
	while not HasAnimDictLoaded(dict) do
		RequestAnimDict(dict)
		Wait(0)
	end
end

function CheckWeapon(ped, newWeap)
	if IsEntityDead(ped) then
			return false
		else
			for i = 1, #realWeapons do
				if GetHashKey(realWeapons[i].name) == GetSelectedPedWeapon(ped) then
					return true
				end
			end
		return false
	end
end

RegisterNetEvent('ZCore:setJob')
AddEventHandler('ZCore:setJob', function(job)
	if job.name == 'police' then
		handgunFlag = 'handguns'
	end
	RemoveGears()
	Wait(2000)
end)

CreateThread(function()
	loadAnimDict("rcmjosh4")
    loadAnimDict("reaction@intimidation@cop@unarmed")
    loadAnimDict("reaction@intimidation@1h")
	loadAnimDict("combat@combat_reactions@pistol_1h_gang")
	loadAnimDict("combat@combat_reactions@pistol_1h_hillbilly")
	loadAnimDict("reaction@male_stand@big_variations@d")
	local rot = 0
	local wepCat
	local lastWep

	while (true) do
		local ped = PlayerPedId()
		Wait(200)
		rot = GetEntityHeading(ped)
		if not IsPedInAnyVehicle(ped, true) then
			if (GetPedParachuteState(ped) == -1 or GetPedParachuteState(ped) == 0) and not IsPedInParachuteFreeFall(ped) then
				wepCat = GetWeapontypeGroup(GetSelectedPedWeapon(ped))
				if CheckWeapon(ped) then -- CHECK WEAPON COMPRUEBA SI TIENE UN ARMA DEL CONFIG ENCIMA
					if(wepCat == 416676503 or wepCat == 690389602) then
						if holstered then
							if handgunFlag == 'backhandgun' then
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							elseif handgunFlag == 'boxers' then
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							elseif handgunFlag == 'chesthandgun' then
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							elseif handgunFlag == 'leghandgun' then
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							else
								SetPedCurrentWeaponVisible(ped, 0, 1, 1, 1)
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnim(ped, "rcmjosh4", "josh_leadout_cop2", 8.0, 2.0, -1, 48, 10, 0, 0, 0 )
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							end
						end
					else
						if holstered then
							if rifleFlag == 'tacticalrifle' then
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_hillbilly", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							else
								SetPedCurrentWeaponVisible(ped, 1, 1, 1, 1)
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "intro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.325, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = false
								lastWep = GetSelectedPedWeapon(ped)
							end
						end
					end
				else
					if (GetWeapontypeGroup(lastWep) == 416676503 or GetWeapontypeGroup(lastWep) == 690389602) then
						if not holstered then
							if handgunFlag == 'backhandgun' then
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							elseif handgunFlag == 'boxers' then
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							elseif handgunFlag == 'leghandgun' then
								TaskPlayAnimAdvanced(ped, "reaction@male_stand@big_variations@d", "react_big_variations_m", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							elseif handgunFlag == 'chesthandgun' then
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0)
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							else
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@cop@unarmed", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							end
						end
					else
						if not holstered then
							if rifleFlag == 'tacticalrifle' then
								TaskPlayAnimAdvanced(ped, "combat@combat_reactions@pistol_1h_gang", "0", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							else
								TaskPlayAnimAdvanced(ped, "reaction@intimidation@1h", "outro", GetEntityCoords(ped, true), 0, 0, rot, 8.0, 3.0, -1, 50, 0.125, 0, 0) -- Change 50 to 30 if you want to stand still when holstering weapon
								Wait(700)
								ClearPedTasks(ped)
								holstered = true
							end
						end
					end
				end
			elseif (GetVehiclePedIsTryingToEnter (ped) == 0) then
				holstered = false
			else
				SetCurrentPedWeapon(ped, GetHashKey("WEAPON_UNARMED"), true)
			end
		else
			holstered = true
		end
	end
end)