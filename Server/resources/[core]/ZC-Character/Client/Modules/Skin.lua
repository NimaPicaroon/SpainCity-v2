Character = {["sex"]="mp_m_freemode_01"}
YourFade = {}
myPed = nil
local wasAumented = false
CharacterSkin = {}
Tattoos = {}

DefaultSkin = {["moles_2"]=0,["eyebrows_1"]=0,["bracelets_2"]=0,["makeup_4"]=0,["makeup_2"]=0,["mask_2"]=0,["lipstick_1"]=0,["chbbl"]=0,["pants_2"]=0,["decals_1"]=0,["glasses_1"]=0,["blush_3"]=0,["chest_2"]=0,["noset"]=0,["mask_1"]=0,["watches_2"]=0,["tshirt_1"]=0,["decals_2"]=0,["jbw"]=0,["helmet_1"]=-1,["blemishes_1"]=0,["makeup_3"]=0,["beard_3"]=0,["chain_2"]=0,["makeup_1"]=0,["nosebh"]=0,["eyeop"]=0,["blush_1"]=0,["helmet_2"]=0,["blush_2"]=0,["lipstick_4"]=0,["arms_2"]=0,["skin"]=0,["bags_1"]=0,["ears_2"]=0,["neckt"]=0,["lipstick_3"]=0,["complexion_1"]=0,["hair_color_2"]=0,["beard_4"]=0,["eye_color"]=0,["chw"]=0,["blemishes_2"]=0,["beard_1"]=0,["nosel"]=0,["eyebrows_4"]=0,["moles_1"]=0,["age_1"]=0,["tshirt_2"]=0,["eyebf"]=0,["arms"]=0,["bproof_2"]=0,["chho"]=0,["beard_2"]=0,["jbbl"]=0,["bodyb_1"]=0,["chbble"]=0,["torso_1"]=0,["noseh"]=0,["pants_1"]=0,["hair_2"]=0,["hair_color_1"]=0,["nosew"]=0,["bracelets_1"]=-1,["sex"]='mp_m_freemode_01', ["shoes_1"]=0,["chbw"]=0,["lipstick_2"]=0,["chest_3"]=0,["bodyb_2"]=0,["face_2"]=-1,["eyebrows_2"]=0,["chain_1"]=0,["eyebh"]=0,["eyebrows_3"]=0,["sun_1"]=0,["ears_1"]=-1,["cbw"]=0,["hair_1"]=0,["bproof_1"]=0,["bags_2"]=0,["cbh"]=0,["shoes_2"]=0,["torso_2"]=0,["nosepl"]=0,["face"]=0,["lipst"]=0,["chest_1"]=0,["complexion_2"]=0,["age_2"]=0,["sun_2"]=0,["watches_1"]=-1,["glasses_2"] = 0}
local cam, isCameraActive
local zoomOffset, camOffset = 0.6, 0.65
local cams = {
	['sex'] =				{zoomOffset = 0.6,		camOffset = 0.65},
	['face'] =				{zoomOffset = 0.6,		camOffset = 0.65},
	['face_2'] =			{zoomOffset = 0.6,		camOffset = 0.65},
	['skin'] =				{zoomOffset = 0.6,		camOffset = 0.65},
	['fade'] =				{zoomOffset = 0.6,		camOffset = 0.65},
	['hair_1'] =			{zoomOffset = 0.6,		camOffset = 0.65,  skipM={ 32,100 }, skipF={ 57,100 }},
	['hair_2'] =			{zoomOffset = 0.6,		camOffset = 0.65},
	['hair_color_1'] =		{zoomOffset = 0.6,		camOffset = 0.65},
	['hair_color_2'] =		{zoomOffset = 0.6,		camOffset = 0.65},
	['tshirt_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 32,100 }, skipF={ 26,100 }},
	['tshirt_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'tshirt_1'},
	['torso_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 75,100 }, skipF={ 73,100 }},
	['torso_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'torso_1'},
	['decals_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 7,100 }, skipF={ 7,100 }},
	['decals_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'decals_1'},
	['arms'] =				{zoomOffset = 0.75,		camOffset = 0.15,  skipM={ 20,100 }, skipF={ 16,100 }},
	['arms_2'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['pants_1'] =			{zoomOffset = 0.8,		camOffset = -0.5, skipM={ 31,100 }, skipF={ 42,100 }},
	['pants_2'] =			{zoomOffset = 0.8,		camOffset = -0.5,	textureof	= 'pants_1'},
	['shoes_1'] =			{zoomOffset = 0.8,		camOffset = -0.8, skipM={ 33,100 }, skipF={ 26,100 }},
	['shoes_2'] =			{zoomOffset = 0.8,		camOffset = -0.8,	textureof	= 'shoes_1'},
	['mask_1'] =			{zoomOffset = 0.6,		camOffset = 0.65, skipM={ 16,100 }, skipF={ 12,100 }},
	['mask_2'] =			{zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'mask_1'},
	['bproof_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 9,100 }, skipF={ 7,100 }},
	['bproof_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bproof_1'},
	['chain_1'] =			{zoomOffset = 0.6,		camOffset = 0.65, skipM={ 18,100 }, skipF={ 15,100 }},
	['chain_2'] =			{zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'chain_1'},
	['helmet_1'] =			{zoomOffset = 0.4,		camOffset = 0.85,	componentId	= 0, skipM={ 20,100 }, skipF={ 20,100 }},
	['helmet_2'] =			{zoomOffset = 0.4,		camOffset = 0.85,	textureof	= 'helmet_1'},
	['glasses_1'] =			{zoomOffset = 0.6,		camOffset = 0.65, skipM={ 15,100 }, skipF={ 11,100 }},
	['glasses_2'] =			{zoomOffset = 0.6,		camOffset = 0.65,	textureof	= 'glasses_1'},
	['watches_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 1,100 }, skipF={ 1,100 }},
	['watches_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'watches_1'},
	['bracelets_1'] =		{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 0,100 }, skipF={ 0,100 }},
	['bracelets_2'] =		{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bracelets_1'},
	['bags_1'] =			{zoomOffset = 0.75,		camOffset = 0.15, skipM={ 9,100 }, skipF={ 8,100 }},
	['bags_2'] =			{zoomOffset = 0.75,		camOffset = 0.15,	textureof	= 'bags_1'},
	['eye_color'] =			{zoomOffset = 0.35,		camOffset = 0.65},
	['eyebrows_2'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['eyebrows_1'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['eyebrows_3'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['eyebrows_4'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['makeup_1'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['makeup_2'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['makeup_3'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['makeup_4'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['lipstick_1'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['lipstick_2'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['lipstick_3'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['lipstick_4'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['ears_1'] =			{zoomOffset = 0.4,		camOffset = 0.65, skipM={ 0,100 }, skipF={ 0,100 }},
	['ears_2'] =			{zoomOffset = 0.4,		camOffset = 0.65,	textureof	= 'ears_1'},
	['chest_1'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['chest_2'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['chest_3'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['nosew'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['noseh'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['nosel'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['nosebh'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['nosepl'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['noset'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['eyebh'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['eyebf'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['cbh'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['cbw'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['chw'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['eyeop'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['lipst'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['jbw'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['jbbl'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['chbbl'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['chbble'] = 			{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['chbw'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['chho'] = 				{zoomOffset = 0.6, 		camOffset = 0.65}, 
	['neckt'] = 			{zoomOffset = 0.6, 		camOffset = 0.65},
	['bodyb_1'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['bodyb_2'] =			{zoomOffset = 0.75,		camOffset = 0.15},
	['age_1'] =				{zoomOffset = 0.4,		camOffset = 0.65},
	['age_2'] =				{zoomOffset = 0.4,		camOffset = 0.65},
	['blemishes_1'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['blemishes_2'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['blush_1'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['blush_2'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['blush_3'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['complexion_1'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['complexion_2'] =		{zoomOffset = 0.4,		camOffset = 0.65},
	['sun_1'] =				{zoomOffset = 0.4,		camOffset = 0.65},
	['sun_2'] =				{zoomOffset = 0.4,		camOffset = 0.65},
	['moles_1'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['moles_2'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['beard_1'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['beard_2'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['beard_3'] =			{zoomOffset = 0.4,		camOffset = 0.65},
	['beard_4'] =			{zoomOffset = 0.4,		camOffset = 0.65}
}

Citizen.CreateThread(function()
	while not exports.ZCore:isPlayerLoaded() do
		Wait(1000)
	end

	Wait(3000)
	TriggerServerEvent('ZC-Character:loadPlayer')
end)

RegisterNetEvent('ZC-Character:updateSkin', function(skin)
	CharacterSkin = Character
end)

RegisterNetEvent('character:getSkin', function(callback)
	if callback then
		callback(CharacterSkin)
	end
end)

RegisterNetEvent("ZC-Character:loadSkin", function(skin, save, fade, model, first, playerPed, fixpj)
	local vida = GetEntityHealth(PlayerPedId())
	local armour = GetPedArmour(PlayerPedId())

	if model and model ~= '' and IsModelValid(GetHashKey(model)) then
		myPed = model

		if not playerPed or not DoesEntityExist(playerPed) then
			playerPed = PlayerPedId()
		end

		LoadModel(ped)
		Wait(3000)
		ApplySkin(skin, nil, save, playerPed)
		PutTattoos()
		ApplyFade(fade)
		TriggerServerEvent('ZCore:giveLoadout')

		if fixpj then
			if not exports['ZC-Menupersonal']:CanUseWeapons() then
				ExecuteCommand('armas')
			end
			Wait(200)
			exports['ZC-Menupersonal']:SetGears()
			Wait(1000)
		end

		Wait(1000)
		if GetEntityMaxHealth(PlayerPedId()) < 200 then
			SetEntityMaxHealth(PlayerPedId(), 200)
		end

		SetEntityHealth(PlayerPedId(), vida)
		SetPedArmour(PlayerPedId(), armour)
	else
		for k,v in pairs(skin) do
			Character[k] = v
		end
		LoadDefaultModel(function()
			ApplySkin(skin, nil, save)
			PutTattoos()
			ApplyFade(fade)
			TriggerServerEvent('ZCore:giveLoadout')

			if not fixpj then
				if GetEntityMaxHealth(PlayerPedId()) < 200 then
					SetEntityMaxHealth(PlayerPedId(), 200)
				end
			end

			SetEntityHealth(PlayerPedId(), vida)
			SetPedArmour(PlayerPedId(), armour)
		end, first)
	end
end)

RegisterNetEvent("ZC-Character:loadFade", function(fade)
	PutTattoos()
	ApplyFade(fade)
end)

RegisterNetEvent("ZC-Character:saveOutfit", function(name)
	local skin = {
		['tshirt_1'] =			Character['tshirt_1'],
		['tshirt_2'] =			Character['tshirt_2'],
		['torso_1'] =			Character['torso_1'],
		['torso_2'] =			Character['torso_2'],
		['decals_1'] =			Character['decals_1'],
		['decals_2'] =			Character['decals_2'],
		['arms'] =				Character['arms'],
		['arms_2'] =			Character['arms_2'],
		['pants_1'] =			Character['pants_1'],
		['pants_2'] =			Character['pants_2'],
		['shoes_1'] =			Character['shoes_1'],
		['shoes_2'] =			Character['shoes_2'],
		['mask_1'] =			Character['mask_1'],
		['mask_2'] =			Character['mask_2'],
		['bproof_1'] =			Character['bproof_1'],
		['bproof_2'] =			Character['bproof_2'],
		['chain_1'] =			Character['chain_1'],
		['chain_2'] =			Character['chain_2'],
		['helmet_1'] =			Character['helmet_1'],
		['helmet_2'] =			Character['helmet_2'],
		['glasses_1'] =			Character['glasses_1'],
		['glasses_2'] =			Character['glasses_2'],
		['watches_1'] =			Character['watches_1'],
		['watches_2'] =			Character['watches_2'],
		['bracelets_1'] =		Character['bracelets_1'],
		['bracelets_2'] =		Character['bracelets_2'],
		['bags_1'] =			Character['bags_1'],
		['bags_2'] =			Character['bags_2']
	}
	TriggerServerEvent('ZC-Character:saveOutfit', skin, name)
end)

RegisterNetEvent("ZC-Character:asignOutfit", function(job, name)
	local skin = {
		['tshirt_1'] =			Character['tshirt_1'],
		['tshirt_2'] =			Character['tshirt_2'],
		['torso_1'] =			Character['torso_1'],
		['torso_2'] =			Character['torso_2'],
		['decals_1'] =			Character['decals_1'],
		['decals_2'] =			Character['decals_2'],
		['arms'] =				Character['arms'],
		['arms_2'] =			Character['arms_2'],
		['pants_1'] =			Character['pants_1'],
		['pants_2'] =			Character['pants_2'],
		['shoes_1'] =			Character['shoes_1'],
		['shoes_2'] =			Character['shoes_2'],
		['mask_1'] =			Character['mask_1'],
		['mask_2'] =			Character['mask_2'],
		['bproof_1'] =			Character['bproof_1'],
		['bproof_2'] =			Character['bproof_2'],
		['chain_1'] =			Character['chain_1'],
		['chain_2'] =			Character['chain_2'],
		['helmet_1'] =			Character['helmet_1'],
		['helmet_2'] =			Character['helmet_2'],
		['glasses_1'] =			Character['glasses_1'],
		['glasses_2'] =			Character['glasses_2'],
		['watches_1'] =			Character['watches_1'],
		['watches_2'] =			Character['watches_2'],
		['bracelets_1'] =		Character['bracelets_1'],
		['bracelets_2'] =		Character['bracelets_2'],
		['bags_1'] =			Character['bags_1'],
		['bags_2'] =			Character['bags_2']
	}
	TriggerServerEvent('jobcreatorv2:server:asignOutfit', skin, job, name)
end)

RegisterNetEvent("ZC-Character:asigngangOutfit", function(name)
	local skin = {
		['tshirt_1'] =			Character['tshirt_1'],
		['tshirt_2'] =			Character['tshirt_2'],
		['torso_1'] =			Character['torso_1'],
		['torso_2'] =			Character['torso_2'],
		['decals_1'] =			Character['decals_1'],
		['decals_2'] =			Character['decals_2'],
		['arms'] =				Character['arms'],
		['arms_2'] =			Character['arms_2'],
		['pants_1'] =			Character['pants_1'],
		['pants_2'] =			Character['pants_2'],
		['shoes_1'] =			Character['shoes_1'],
		['shoes_2'] =			Character['shoes_2'],
		['mask_1'] =			Character['mask_1'],
		['mask_2'] =			Character['mask_2'],
		['bproof_1'] =			Character['bproof_1'],
		['bproof_2'] =			Character['bproof_2'],
		['chain_1'] =			Character['chain_1'],
		['chain_2'] =			Character['chain_2'],
		['helmet_1'] =			Character['helmet_1'],
		['helmet_2'] =			Character['helmet_2'],
		['glasses_1'] =			Character['glasses_1'],
		['glasses_2'] =			Character['glasses_2'],
		['watches_1'] =			Character['watches_1'],
		['watches_2'] =			Character['watches_2'],
		['bracelets_1'] =		Character['bracelets_1'],
		['bracelets_2'] =		Character['bracelets_2'],
		['bags_1'] =			Character['bags_1'],
		['bags_2'] =			Character['bags_2']
	}
	TriggerServerEvent('Ox-Gangs:asignOutfit', skin, name)
end)

RegisterNUICallback('changeValues', function(data)
    local type = data.type
    local value = data.value

    -- zoomOffset = cams[type].zoomOffset
    -- camOffset = cams[type].camOffset
	local oldHealth = GetEntityHealth(GetPlayerPed(-1))
    if type == 'sex' then
		ApplySex(value)
	elseif type == 'fade' then
		ApplyFade(tonumber(value), true)
    else
        ApplySkin({[type] = tonumber(value)})
    end
	Citizen.Wait(150)
	SetEntityHealth(GetPlayerPed(-1), oldHealth)
end)

RegisterNUICallback('changeCam', function(data)
    local type = data.type
	local ped = PlayerPedId()
	local heading = GetEntityHeading(ped)

    if type == 'back' then
        SetEntityHeading(ped, heading-180)
	elseif type == 'rotate' then
		SetEntityHeading(ped, heading + 30)
	elseif type == 'rotate2' then
		SetEntityHeading(ped, heading - 30)
	elseif type == 'head' then
		zoomOffset = 0.6
		camOffset = 0.65
	elseif type == 'body' then
		zoomOffset = 1.55
		camOffset = -0.15
	elseif type == 'shoes' then
		zoomOffset = 0.8
		camOffset = -0.8
    end
end)

function ApplySex(sex)
    if sex == 'mp_m_freemode_01' or sex == 'mp_f_freemode_01' then
        FreezeEntityPosition(PlayerPedId(), true)

        local model = GetHashKey(sex)
        RequestModel(model)
        while not HasModelLoaded(model) do
            RequestModel(model)
            Wait(0)
        end

        SetPlayerModel(PlayerId(), model)
        SetPedDefaultComponentVariation(PlayerPedId())
        SetModelAsNoLongerNeeded(model)

        local ped = PlayerPedId()
        ClearPedTasksImmediately(ped)
        SetEntityHealth(ped, 200)
        SetPedMaxHealth(ped, 200)
        FreezeEntityPosition(ped, false)
		Character['sex'] = sex
	end
end

function ApplySkin(skin, shop, save, ped)
	local playerPed = PlayerPedId()

	if ped then
		playerPed = ped
	end

	for k,v in pairs(skin) do
		Character[k] = v
	end

	CharacterSkin = Character

	SendNUIMessage({ max = GetMaxVals() })

	local hash = GetEntityModel(PlayerPedId())
	local isFreemodePed = false

	if hash == GetHashKey('mp_m_freemode_01') or hash == GetHashKey('mp_f_freemode_01') then
		isFreemodePed = true
	end
	if Character['sex'] == 'mp_m_freemode_01' or Character['sex'] == 'mp_f_freemode_01' and isFreemodePed then
		if Character['face_2'] == -1 then
			SetPedHeadBlendData			(playerPed, Character['face'], Character['face'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 1.0, 1.0, 1.0, true)
		else
			SetPedHeadBlendData			(playerPed, Character['face'], Character['face_2'], Character['face'], Character['skin'], Character['skin'], Character['skin'], 0.5, 0.5, 0.0, true)
		end

		SetPedHairColor				(playerPed,			Character['hair_color_1'],		Character['hair_color_2'])					-- Hair Color
	end

	SetPedHeadOverlay			(playerPed, 3,		Character['age_1'],				(Character['age_2'] / 10) + 0.0)			-- Age + opacity
	SetPedHeadOverlay			(playerPed, 0,		Character['blemishes_1'],		(Character['blemishes_2'] / 10) + 0.0)		-- Blemishes + opacity
	SetPedHeadOverlay			(playerPed, 1,		Character['beard_1'],			(Character['beard_2'] / 10) + 0.0)			-- Beard + opacity
	SetPedEyeColor				(playerPed,			Character['eye_color'], 0, 1)												-- Eyes color
	SetPedHeadOverlay			(playerPed, 2,		Character['eyebrows_1'],		(Character['eyebrows_2'] / 10) + 0.0)		-- Eyebrows + opacity
	SetPedHeadOverlay			(playerPed, 4,		Character['makeup_1'],			(Character['makeup_2'] / 10) + 0.0)			-- Makeup + opacity
	SetPedHeadOverlay			(playerPed, 8,		Character['lipstick_1'],		(Character['lipstick_2'] / 10) + 0.0)		-- Lipstick + opacity
	SetPedComponentVariation	(playerPed, 2,		Character['hair_1'],			Character['hair_2'], 2)						-- Hair
	SetPedHeadOverlayColor		(playerPed, 1, 1,	Character['beard_3'],			Character['beard_4'])						-- Beard Color
	SetPedHeadOverlayColor		(playerPed, 2, 1,	Character['eyebrows_3'],		Character['eyebrows_4'])					-- Eyebrows Color
	SetPedHeadOverlayColor		(playerPed, 4, 1,	Character['makeup_3'],			Character['makeup_4'])						-- Makeup Color
	SetPedHeadOverlayColor		(playerPed, 8, 1,	Character['lipstick_3'],		Character['lipstick_4'])					-- Lipstick Color
	SetPedHeadOverlay			(playerPed, 5,		Character['blush_1'],			(Character['blush_2'] / 10) + 0.0)			-- Blush + opacity
	SetPedHeadOverlayColor		(playerPed, 5, 2,	Character['blush_3'])														-- Blush Color
	SetPedHeadOverlay			(playerPed, 6,		Character['complexion_1'],		(Character['complexion_2'] / 10) + 0.0)		-- Complexion + opacity
	SetPedHeadOverlay			(playerPed, 7,		Character['sun_1'],				(Character['sun_2'] / 10) + 0.0)			-- Sun Damage + opacity
	SetPedHeadOverlay			(playerPed, 9,		Character['moles_1'],			(Character['moles_2'] / 10) + 0.0)			-- Moles/Freckles + opacity
	SetPedHeadOverlay			(playerPed, 10,		Character['chest_1'],			(Character['chest_2'] / 10) + 0.0)			-- Chest Hair + opacity
	SetPedHeadOverlayColor		(playerPed, 10, 1,	Character['chest_3'])														-- Torso Color
	SetPedHeadOverlay			(playerPed, 11,		Character['bodyb_1'],			(Character['bodyb_2'] / 10) + 0.0)			-- Body Blemishes + opacity
	SetPedComponentVariation	(playerPed, 3,		Character['arms'],				Character['arms_2'], 2)						-- Arms
	SetPedFaceFeature(playerPed, 0, (Character['nosew'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 1, (Character['noseh'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 2, (Character['nosel'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 3, (Character['nosebh'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 4, (Character['nosepl'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 5, (Character['noset'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 6, (Character['eyebh'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 7, (Character['eyebf'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 8, (Character['cbh'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 9, (Character['cbw'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 10, (Character['chw'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 11, (Character['eyeop'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 12, (Character['lipst'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 13, (Character['jbw'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 14, (Character['jbbl'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 15, (Character['chbbl'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 16, (Character['chbble'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 17, (Character['chbw'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 18, (Character['chho'] / 10) + 0.0)
	SetPedFaceFeature(playerPed, 19, (Character['neckt'] / 10) + 0.0)

	if Character['ears_1'] == -1 then
		ClearPedProp(playerPed, 2)
	else
		SetPedPropIndex			(playerPed, 2,		Character['ears_1'],			Character['ears_2'], 2)						-- Ears Accessories
	end

	SetPedComponentVariation	(playerPed, 8,		Character['tshirt_1'],			Character['tshirt_2'], 2)					-- Tshirt
	SetPedComponentVariation	(playerPed, 11,		Character['torso_1'],			Character['torso_2'], 2)					-- torso parts
	SetPedComponentVariation	(playerPed, 10,		Character['decals_1'],			Character['decals_2'], 2)					-- decals
	SetPedComponentVariation	(playerPed, 4,		Character['pants_1'],			Character['pants_2'], 2)					-- pants
	SetPedComponentVariation	(playerPed, 6,		Character['shoes_1'],			Character['shoes_2'], 2)					-- shoes
	if(ignoreMask ~= true)then
		SetPedComponentVariation	(playerPed, 1,		Character['mask_1'],			Character['mask_2'], 2)						-- mask
	end
	SetPedComponentVariation	(playerPed, 9,		Character['bproof_1'],			Character['bproof_2'], 2)					-- bulletproof
	SetPedComponentVariation	(playerPed, 7,		Character['chain_1'],			Character['chain_2'], 2)					-- chain
	SetPedComponentVariation	(playerPed, 5,		Character['bags_1'],			Character['bags_2'], 2)						-- Bag
	if Character['bags_1'] <= 0 and wasAumented then
		wasAumented = false
		TriggerServerEvent('ZCore:updateWeight', 'default')
	elseif (Character['bags_1'] == 44 or Character['bags_1'] == 85 or Character['bags_1'] == 86 or Character['bags_1'] >= 100) and not wasAumented then
		wasAumented = true
		TriggerServerEvent('ZCore:updateWeight', 'added')
	end
	if Character['helmet_1'] == -1 then
		ClearPedProp(playerPed, 0)
	else
		SetPedPropIndex			(playerPed, 0,		Character['helmet_1'],			Character['helmet_2'], 2)					-- Helmet
	end

	if Character['glasses_1'] == -1 then
		ClearPedProp(playerPed, 1)
	else
		SetPedPropIndex			(playerPed, 1,		Character['glasses_1'],			Character['glasses_2'], 2)					-- Glasses
	end

	if Character['watches_1'] == -1 then
		ClearPedProp(playerPed, 6)
	else
		SetPedPropIndex			(playerPed, 6,		Character['watches_1'],			Character['watches_2'], 2)					-- Watches
	end

	if Character['bracelets_1'] == -1 then
		ClearPedProp(playerPed,	7)
	else
		SetPedPropIndex			(playerPed, 7,		Character['bracelets_1'],		Character['bracelets_2'], 2)				-- Bracelets
	end

	if save then
		TriggerServerEvent('ZC-Character:saveSkin', Character)
	end
end

function CreateSkinCam()
    if not DoesCamExist(cam) then
        cam = CreateCam('DEFAULT_SCRIPTED_CAMERA', true)
    end
	local playerPed = PlayerPedId()

    SetCamActive(cam, true)
    RenderScriptCams(true, true, 500, true, true)

    isCameraActive = true
    SetCamRot(cam, 0.0, 0.0, 270.0, true)
    SetEntityHeading(playerPed, 90.0)
end

function DeleteSkinCam()
    isCameraActive = false
    SetCamActive(cam, false)
    RenderScriptCams(false, true, 500, true, true)
    cam = nil
end

Citizen.CreateThread(function()
    while true do
		local sleep = 1000

        if isCameraActive then
			sleep = 0
            DisableControlAction(2, 30, true)
            DisableControlAction(2, 31, true)
            DisableControlAction(2, 32, true)
            DisableControlAction(2, 33, true)
            DisableControlAction(2, 34, true)
            DisableControlAction(2, 35, true)
            DisableControlAction(0, 25, true) -- Input Aim
            DisableControlAction(0, 24, true) -- Input Attack

            local playerPed = PlayerPedId()
            local coords    = GetEntityCoords(playerPed)

            local angle = 180 * math.pi / 180.0
            local theta = {
                x = math.cos(angle),
                y = math.sin(angle)
            }

            local pos = {
                x = coords.x + (zoomOffset * theta.x),
                y = coords.y + (zoomOffset * theta.y)
            }

			local angleToLook = 120
            local thetaToLook = {
                x = math.cos(angleToLook),
                y = math.sin(angleToLook)
            }

            local posToLook = {
                x = coords.x + (zoomOffset * thetaToLook.x),
                y = coords.y + (zoomOffset * thetaToLook.y)
            }

            SetCamCoord(cam, pos.x, pos.y, coords.z + camOffset)
            PointCamAtCoord(cam, posToLook.x, posToLook.y, coords.z + camOffset)
        end

		Citizen.Wait(sleep)
    end
end)

Fades = {}
Fades['FadeMale'] = {
	{['nameHash'] = "FM_Hair_Fuzz", ['dlc'] = 'mpbeach_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_001", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_002", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_003", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_004", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_005", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_006", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_007", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_008", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_009", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_013", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_014", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_015", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_011", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_012", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_M_Hair_012", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBea_M_Hair_000", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBea_M_Hair_001", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_000", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_001", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_002", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_004", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_005", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_M_Hair_006", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_001_M", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_002_M", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_003_M", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_004_M", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_005_M", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Gunrunning_Hair_M_000_M", ['dlc'] = 'mpgunrunning_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Gunrunning_Hair_M_001_M", ['dlc'] = 'mpgunrunning_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9}
}

Fades['FadeFemale'] = {
	{['nameHash'] = "FM_Hair_Fuzz", ['dlc'] = 'mpbeach_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_001", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_002", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_003", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_004", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_005", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_006", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_007", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_008", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_009", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_010", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_011", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_012", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_013", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_014", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_015", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBea_F_Hair_000", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBea_F_Hair_001", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NG_F_Hair_007", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBus_F_Hair_000", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "NGBus_F_Hair_001", ['dlc'] = 'multiplayer_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_000", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_001", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_002", ['dlc'] = 'mplowrider_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_004", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_005", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "LR_F_Hair_006", ['dlc'] = 'mplowrider2_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_001_F", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_002_F", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_003_F", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_004_F", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Biker_Hair_005_F", ['dlc'] = 'mpbiker_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Gunrunning_Hair_F_000_F", ['dlc'] = 'mpgunrunning_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9},
	{['nameHash'] = "MP_Gunrunning_Hair_F_001_F", ['dlc'] = 'mpgunrunning_overlays', ['addedX'] = 0.3, ['addedY'] =-0.2, ['addedZ'] =0.7, ['rotZ'] = 56.9}
}

LoadFadedHairstyles = function()
	local num = 0
	local _hair = "FadeMale"
	if Character['sex'] == 'mp_m_freemode_01' then
		_hair = 'FadeMale'
	else
		_hair = 'FadeFemale'
	end

	for _key,_value in ipairs(Fades[_hair]) do
		num = num + 1
	end

	return num
end

ApplyFade = function(num, inskinMenu)
	if not Tattoos or inskinMenu then
		ClearPedDecorations(PlayerPedId())
	end
	if type(num) == 'number' and num then
		if Character['sex'] == 'mp_m_freemode_01' then
			AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(Fades['FadeMale'][num]['dlc']), GetHashKey(Fades['FadeMale'][num]['nameHash']))
		else
			AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(Fades['FadeFemale'][num]['dlc']), GetHashKey(Fades['FadeFemale'][num]['nameHash']))
		end

		YourFade = {}

		table.insert(YourFade, {
			['dlc'] = Fades['FadeMale'][num]['dlc'] or nil,
			['nameHash'] = Fades['FadeMale'][num]['nameHash'] or nil
		})
	else
		if num and num[1] and num[1]['dlc'] then
			if Character['sex'] == 'mp_m_freemode_01' then
				AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(num[1]['dlc']), GetHashKey(num[1]['nameHash']))
			else
				AddPedDecorationFromHashes(PlayerPedId(), GetHashKey(num[1]['dlc']), GetHashKey(num[1]['nameHash']))
			end

			YourFade = {}

			table.insert(YourFade, {
				['dlc'] = num[1]['dlc'] or nil,
				['nameHash'] = num[1]['nameHash'] or nil
			})
		end
	end
end


function GetMaxVals()
	local playerPed = PlayerPedId()

	local data = {
		{type = 'age_1'	, value = GetNumHeadOverlayValues(3)-1},
		{type = 'beard_1'	, value = GetNumHeadOverlayValues(1)-1},
		{type = 'beard_3'	, value = GetNumHairColors()-1},
		{type = 'beard_4'	, value = GetNumHairColors()-1},
		{type = 'hair_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 2) - 1},
		{type = 'hair_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 2, Character['hair_1']) - 1},
		{type = 'hair_color_1'	, value = GetNumHairColors()-1},
		{type = 'hair_color_2'	, value = GetNumHairColors()-1},
		{type = 'eye_color'	, value = 31},
		{type = 'eyebrows_1'	, value = GetNumHeadOverlayValues(2)-1},
		{type = 'eyebrows_3'	, value = GetNumHairColors()-1},
		{type = 'eyebrows_4'	, value = GetNumHairColors()-1},
		{type = 'makeup_1'	, value = GetNumHeadOverlayValues(4)-1},
		{type = 'makeup_3'	, value = GetNumHairColors()-1},
		{type = 'makeup_4'	, value = GetNumHairColors()-1},
		{type = 'lipstick_1'	, value = GetNumHeadOverlayValues(8)-1},
		{type = 'lipstick_3'	, value = GetNumHairColors()-1},
		{type = 'lipstick_4'	, value = GetNumHairColors()-1},
		{type = 'blemishes_1'	, value = GetNumHeadOverlayValues(0)-1},
		{type = 'blush_1'	, value = GetNumHeadOverlayValues(5)-1},
		{type = 'blush_3'	, value = GetNumHairColors()-1},
		{type = 'complexion_1'	, value = GetNumHeadOverlayValues(6)-1},
		{type = 'sun_1'	, value = GetNumHeadOverlayValues(7)-1},
		{type = 'moles_1'	, value = GetNumHeadOverlayValues(9)-1},
		{type = 'chest_1'	, value = GetNumHeadOverlayValues(10)-1},
		{type = 'chest_3'	, value = GetNumHairColors()-1},
		{type = 'bodyb_1'	, value = GetNumHeadOverlayValues(11)-1},
		{type = 'ears_1'	, value = GetNumberOfPedPropDrawableVariations	(playerPed, 1) - 1},
		{type = 'ears_2'	, value = GetNumberOfPedPropTextureVariations	(playerPed, 1, Character['ears_1'] and (Character['ears_1'] - 1) or 0)},
		{type = 'tshirt_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 8) - 1},
		{type = 'tshirt_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 8, Character['tshirt_1'] and Character['tshirt_1'] or 0) - 1},
		{type = 'torso_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 11) - 1},
		{type = 'torso_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 11, Character['torso_1'] and Character['torso_1'] or 0) - 1},
		{type = 'decals_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 10) - 1},
		{type = 'decals_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 10, Character['decals_1'] and Character['decals_1'] or 0) - 1},
		{type = 'arms'	, value = GetNumberOfPedDrawableVariations		(playerPed, 3) - 1},
		{type = 'pants_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 4) - 1},
		{type = 'pants_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 4, Character['pants_1'] and Character['pants_1'] or 0) - 1},
		{type = 'shoes_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 6) - 1},
		{type = 'shoes_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 6, Character['shoes_1'] and Character['shoes_1'] or 0) - 1},
		{type = 'mask_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 1) - 1},
		{type = 'mask_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 1, Character['mask_1'] and Character['mask_1'] or 0) - 1},
		{type = 'bproof_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 9) - 1},
		{type = 'bproof_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 9, Character['bproof_1'] and Character['bproof_1'] or 0) - 1},
		{type = 'chain_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 7) - 1},
		{type = 'chain_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 7, Character['chain_1'] and Character['chain_1'] or 0) - 1},
		{type = 'bags_1'	, value = GetNumberOfPedDrawableVariations		(playerPed, 5) - 1},
		{type = 'bags_2'	, value = GetNumberOfPedTextureVariations		(playerPed, 5, Character['bags_1'] and Character['bags_1'] or 0) - 1},
		{type = 'helmet_1'	, value = GetNumberOfPedPropDrawableVariations	(playerPed, 0) - 1},
		{type = 'helmet_2'	, value = GetNumberOfPedPropTextureVariations	(playerPed, 0, Character['helmet_1'] and Character['helmet_1'] or 0) - 1},
		{type = 'glasses_1'	, value = GetNumberOfPedPropDrawableVariations	(playerPed, 1) - 1},
		{type = 'glasses_2'	, value = GetNumberOfPedPropTextureVariations	(playerPed, 1, Character['glasses_1'] and (Character['glasses_1'] - 1) or 0)},
		{type = 'watches_1'	, value = GetNumberOfPedPropDrawableVariations	(playerPed, 6) - 1},
		{type = 'watches_2'	, value = GetNumberOfPedPropTextureVariations	(playerPed, 6, Character['watches_1'] and Character['watches_1'] or 0) - 1},
		{type = 'bracelets_1'	, value = GetNumberOfPedPropDrawableVariations	(playerPed, 7) - 1},
		{type = 'bracelets_2'	, value = GetNumberOfPedPropTextureVariations	(playerPed, 7, Character['bracelets_1'] and (Character['bracelets_1'] - 1) or 0)},
		{type = 'fade'	, value = LoadFadedHairstyles()}
	}

	return data
end

local cooldown = false

function LoadDefaultModel(cb, first)
	local playerPed = PlayerPedId()
	local characterModel

	if Character['sex'] then
		characterModel = GetHashKey(Character['sex'])
	end

	RequestModel(characterModel)

	Citizen.CreateThread(function()
		while not HasModelLoaded(characterModel) do
			RequestModel(characterModel)
			Citizen.Wait(0)
		end

		if IsModelInCdimage(characterModel) and IsModelValid(characterModel) then
			SetPlayerModel(PlayerId(), characterModel)
			SetPedDefaultComponentVariation(playerPed)
		end

		SetModelAsNoLongerNeeded(characterModel)
		SetPedMaxHealth(PlayerPedId(), 200)
		if first then
			SetEntityHealth(PlayerPedId(), 200)
		end
		if cb then
			cb()
		end
	end)
end

local function joaat(s)
	return GetHashKey(s)
end

function LoadModel(model)
	Character['sex'] = model
	model  = joaat(model)

	if IsModelValid(model) and IsModelInCdimage(model) and IsModelValid(model) then
		RequestModel(model)
		Citizen.CreateThread(function()
			while not HasModelLoaded(model) do
				RequestModel(model)

				Citizen.Wait(0)
			end

			SetPlayerModel(PlayerId(), model)
			SetPedDefaultComponentVariation(model)

			SetEntityHealth(PlayerPedId(), 200)
			SetPedMaxHealth(PlayerPedId(), 200)
		end)
	end
end

RegisterNetEvent('ZC-Character:updateModel', LoadModel)

RegisterCommand("fixpj",function()
	local ped = PlayerPedId()
	
	if exports['ZC-Smoke']:isBusy() or exports['Ox-Needs']:isBusy() then
		W.Notify('FIXPJ', 'No puedes hacer esto ahora mismo', 'error')

		return
	end

	if not IsPedDeadOrDying(ped) and GetEntityHeightAboveGround(ped) < 1.2 then
		if suelo then
			ExecuteCommand('suelo')
		end

		local vida = GetEntityHealth(ped)
		
		TriggerServerEvent('ZC-Character:loadPlayer', true)
	else
		W.Notify('FIXPJ', 'No puedes hacer esto ahora mismo', 'error')
	end
end)

exports('loadEntire', function()
	LoadDefaultModel(function()
		if myPed then
			LoadModel(myPed)
		end
		ApplySkin(Character)
		W.TriggerCallback('Ox-Tattoo:GetPlayerTattoos', function(tattooList)
			if tattooList then
				ClearPedDecorations(PlayerPedId())
				for k, v in pairs(tattooList) do
					if v.Count ~= nil then
						for i = 1, v.Count do
							SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
						end
					else
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				end
			end
		end)
		ApplyFade(YourFade)
		TriggerServerEvent('ZCore:giveLoadout')
	end)
end)

GetSkin = function()
    return Character
end

exports('GetSkin', GetSkin)

GetTattoos = function()
    return Tattoos
end

exports('GetTattoos', GetTattoos)

PutTattoos = function()
	W.TriggerCallback('Ox-Tattoo:GetPlayerTattoos', function(tattooList)
		if tattooList then
			Tattoos = tattooList
			ClearPedDecorations(PlayerPedId())
			for k, v in pairs(tattooList) do
				if v.Count ~= nil then
					for i = 1, v.Count do
						SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
					end
				else
					SetPedDecoration(PlayerPedId(), v.collection, v.nameHash)
				end
			end
			ApplyFade(YourFade)
		end
	end)
end

exports('PutTattoos', PutTattoos)