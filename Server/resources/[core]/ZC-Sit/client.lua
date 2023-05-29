local debugProps, sitting, lastPos, currentSitCoords, currentScenario = {}
local seats = {}

closestsit = {
	'prop_bench_01a',
	'prop_bench_01b',
	'prop_bench_01c',
	'prop_bench_02',
	'prop_bench_03',
	'prop_bench_04',
	'prop_bench_05',
	'prop_bench_06',
	'prop_bench_05',
	'prop_bench_08',
	'prop_bench_09',
	'prop_bench_10',
	'prop_bench_11',
	'prop_fib_3b_bench',
	'prop_ld_bench01',
	'prop_wait_bench_01',
	'hei_prop_heist_off_chair',
	'hei_prop_hei_skid_chair',
	'prop_chair_01a',
	'prop_chair_01b',
	'prop_chair_02',
	'prop_chair_03',
	'prop_chair_04a',
	'prop_chair_04b',
	'prop_chair_05',
	'prop_chair_06',
	'prop_chair_05',
	'prop_chair_08',
	'prop_chair_09',
	'prop_chair_10',
	'v_club_stagechair',
	'prop_chateau_chair_01',
	'prop_clown_chair',
	'prop_cs_office_chair',
	'prop_direct_chair_01',
	'prop_direct_chair_02',
	'prop_gc_chair02',
	'prop_off_chair_01',
	'prop_off_chair_03',
	'prop_off_chair_04',
	'prop_off_chair_04b',
	'prop_off_chair_04_s',
	'prop_off_chair_05',
	'prop_old_deck_chair',
	'prop_old_wood_chair',
	'prop_rock_chair_01',
	'prop_skid_chair_01',
	'prop_skid_chair_02',
	'prop_skid_chair_03',
	'prop_sol_chair',
	'prop_wheelchair_01',
	'prop_wheelchair_01_s',
	'p_armchair_01_s',
	'p_clb_officechair_s',
	'p_dinechair_01_s',
	'p_ilev_p_easychair_s',
	'p_soloffchair_s',
	'p_yacht_chair_01_s',
	'v_club_officechair',
	'v_corp_bk_chair3',
	'v_corp_cd_chair',
	'v_corp_offchair',
	'v_ilev_chair02_ped',
	'v_ilev_hd_chair',
	'v_ilev_p_easychair',
	'v_ret_gc_chair03',
	'prop_ld_farm_chair01',
	'prop_table_04_chr',
	'prop_table_05_chr',
	'prop_table_06_chr',
	'v_ilev_leath_chr',
	'prop_table_01_chr_a',
	'prop_table_01_chr_b',
	'prop_table_02_chr',
	'prop_table_03b_chr',
	'prop_table_03_chr',
	'prop_torture_ch_01',
	'v_ilev_fh_dineeamesa',
	'v_ilev_fh_kitchenstool',
	'v_ilev_tort_stool',
	'v_ilev_fh_kitchenstool',
	'v_ilev_fh_kitchenstool',
	'v_ilev_fh_kitchenstool',
	'v_ilev_fh_kitchenstool',
	'hei_prop_yah_seat_01',
	'hei_prop_yah_seat_02',
	'hei_prop_yah_seat_03',
	'prop_waiting_seat_01',
	'prop_yacht_seat_01',
	'prop_yacht_seat_02',
	'prop_yacht_seat_03',
	'prop_hobo_seat_01',
	'prop_rub_couch01',
	'miss_rub_couch_01',
	'prop_ld_farm_couch01',
	'prop_ld_farm_couch02',
	'prop_rub_couch02',
	'prop_rub_couch03',
	'prop_rub_couch04',
	'p_lev_sofa_s',
	'p_res_sofa_l_s',
	'p_v_med_p_sofa_s',
	'p_yacht_sofa_01_s',
	'v_ilev_m_sofa',
	'v_res_tre_sofa_s',
	'v_tre_sofa_mess_a_s',
	'v_tre_sofa_mess_b_s',
	'v_tre_sofa_mess_c_s',
	'prop_roller_car_01',
	'prop_roller_car_02'
}


Citizen.CreateThread(function()
	while true do
		local sleep = 1000
		local playerPed = PlayerPedId()

		if sitting then
			sleep = 5
			if not IsPedUsingScenario(playerPed, currentScenario) or IsControlPressed(0, 73) then
				wakeup()
			end
		end
		Citizen.Wait(sleep)
	end
end)

function RayCastGamePlayCamera(distance)
    local cameraRotation = GetGameplayCamRot()
	local cameraCoord = GetGameplayCamCoord()
	local direction = RotationToDirection(cameraRotation)
	local destination =
	{
		x = cameraCoord.x + direction.x * distance,
		y = cameraCoord.y + direction.y * distance,
		z = cameraCoord.z + direction.z * distance
	}
	local a, b, c, d, e = GetShapeTestResult(StartShapeTestRay(cameraCoord.x, cameraCoord.y, cameraCoord.z, destination.x, destination.y, destination.z, -1, PlayerPedId(), 0))
	return b, c, e
end


function RotationToDirection(rotation)
	local adjustedRotation =
	{
		x = (math.pi / 180) * rotation.x,
		y = (math.pi / 180) * rotation.y,
		z = (math.pi / 180) * rotation.z
	}
	local direction =
	{
		x = -math.sin(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		y = math.cos(adjustedRotation.z) * math.abs(math.cos(adjustedRotation.x)),
		z = math.sin(adjustedRotation.x)
	}
	return direction
end

InChair = function ()
    local hit, ocoords, entity = RayCastGamePlayCamera(1000.0)
    local coords = GetEntityCoords(PlayerPedId())

    if hit and GetEntityType(entity) ~= 0 and IsEntityAnObject(entity) and entity ~= 0 then
        for k,v in pairs(Config.Sitable) do
            if GetHashKey(tostring(k)) == GetEntityModel(entity) then
                local objCoords = GetEntityCoords(entity)
                if #(objCoords - coords) < 2.5 then
                    return true, entity, k, v, objCoords
                end
            end
        end
    end

    return nil
end

Citizen.CreateThread(function()
    while true do
		local sleep = 800
		local playerPed = PlayerPedId()
		local inChair, entity, k, v, objCoords =  InChair()

		if IsPedOnFoot(playerPed) and inChair and not sitting then
			sleep = 0
			W.ShowText(objCoords + vector3(0,0,1.5), '~y~Silla\n~w~Shift + E para sentarte', 0.5, 8)
			if IsControlJustPressed(0, 38) and IsControlPressed(0, 21)  then
				sit(entity, k, v)
			end
		end
		Citizen.Wait(sleep)
	end
end)

function wakeup()
	local playerPed = PlayerPedId()
	ClearPedTasks(playerPed)

	sitting = false

	SetEntityCoords(playerPed, lastPos)
	FreezeEntityPosition(playerPed, false)

	TriggerServerEvent('ZC-Sit:leavePlace', currentSitCoords)
	currentSitCoords, currentScenario = nil, nil
end

function sit(object, modelName, data)
	local pos = GetEntityCoords(object)
	local objectCoords = pos.x .. pos.y .. pos.z

	if seats[objectCoords] then
		W.Notify('NOTIFICACIÓN', 'Dónde vas, ¿no ves que hay una persona?', 'error')
	else
		local playerPed = PlayerPedId()
		lastPos, currentSitCoords = GetEntityCoords(playerPed), objectCoords

		TriggerServerEvent('ZC-Sit:takePlace', objectCoords)
		FreezeEntityPosition(object, true)

		currentScenario = data.scenario
		TaskStartScenarioAtPosition(playerPed, currentScenario, pos.x, pos.y, pos.z - data.verticalOffset, GetEntityHeading(object) + 180.0, 0, true, true)
		Citizen.Wait(1000)
		sitting = true
	end
end

RegisterNetEvent('ZC-Sit:updatePlaces', function(list)
	seats = list
end)
