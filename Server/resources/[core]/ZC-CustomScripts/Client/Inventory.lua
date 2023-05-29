local HideHudComponentThisFrame, HudWeaponWheelIgnoreSelection, ShowHudComponentThisFrame = HideHudComponentThisFrame, HudWeaponWheelIgnoreSelection, ShowHudComponentThisFrame
local CreateThread, Wait = CreateThread, Wait
local ChangeWeaponDamage, DisableControlAction = N_0x4757f00bc6323cfe, DisableControlAction
local playerPed = nil

CreateThread(function()
    while true do
        playerPed = PlayerPedId()

		if IsPedInAnyVehicle(playerPed, false) then
            HideHudComponentThisFrame(14)
        end
        Wait(500)
    end
end)

CreateThread(function ()
    while not playerPed do
        Wait(500)
    end

	while true do
		Wait(5)

        HudWeaponWheelIgnoreSelection()
        HideHudComponentThisFrame(3)
        HideHudComponentThisFrame(4)
        HideHudComponentThisFrame(19)
        HideHudComponentThisFrame(1)  -- Wanted Stars
        HideHudComponentThisFrame(3)  -- Cash
        HideHudComponentThisFrame(4)  -- MP Cash
        HideHudComponentThisFrame(6)  -- Vehicle Name
        HideHudComponentThisFrame(8)  -- Vehicle Class
        HideHudComponentThisFrame(13) -- Cash Change
        HideHudComponentThisFrame(17) -- Save Game
        HideHudComponentThisFrame(20) -- Weapon Stats
        ShowHudComponentThisFrame(2)

        if IsPedArmed(playerPed, 6) then
            DisableControlAction(1, 140, true)
            DisableControlAction(1, 141, true)
            DisableControlAction(1, 142, true)
        end


        DisableControlAction(0, 37, true)
        DisableControlAction(0, 80, true)

        ChangeWeaponDamage(`WEAPON_NIGHTSTICK`, 0.2)
        ChangeWeaponDamage(`WEAPON_BATTLEAXE`, 0.0)
        ChangeWeaponDamage(`WEAPON_FLASHLIGHT`, 0.4)
        ChangeWeaponDamage(`WEAPON_CROWBAR`, 0.4)
        ChangeWeaponDamage(`WEAPON_GOLFCLUB`, 0.4)
        ChangeWeaponDamage(`WEAPON_UNARMED`, 0.2)
        ChangeWeaponDamage(`WEAPON_HAMMER`, 0.4)
        ChangeWeaponDamage(`WEAPON_WRENCH`, 0.4)
        ChangeWeaponDamage(`WEAPON_POOLCUE`, 0.4)
        ChangeWeaponDamage(`WEAPON_KNUCKLE`, 0.4)
        ChangeWeaponDamage(`WEAPON_BAT`, 0.4)
	end
end)

RegisterCommand('openhotbar', function()
    TriggerEvent('inventory:openHotbar')
end)

RegisterKeyMapping('openhotbar', 'Abrir hotbar', 'keyboard', 'TAB')