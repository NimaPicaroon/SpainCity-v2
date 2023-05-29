local W = exports.ZCore:get()

RegisterCommand('+tablet', function(source, args, rawCommand)
    SetNuiFocus(true, true)
    W.TriggerCallback("ox_tablet:getOpenData", function(data)
        local itemsServer = {}
        for k,v in pairs(data.Items) do
            table.insert(itemsServer, { label = v.label, name = v.name })
        end
        
        SendNUIMessage({
            action = "show",
            data  = data,
            penalties = Config.Multas,
            items = itemsServer
        })
        ExecuteCommand("e tablet2")
    end)
end)
RegisterKeyMapping('+tablet', 'Tablet Personal', 'keyboard', 'HOME')


RegisterNUICallback('close', function(data, cb)
	SetNuiFocus(false, false)
    --ClearPedTasks(PlayerPedId())
    ExecuteCommand("+HALG")
end)

RegisterNetEvent("ox_tablet:refreshRobos")
AddEventHandler("ox_tablet:refreshRobos", function(data)
    SendNUIMessage({
        action = "refreshrobos",
        data  = data
    })
end)

RegisterNUICallback("getphoto", function(data,cb)
	CreateMobilePhone(1)
	CellCamActivate(true, true)
	takePhoto = true
    SetNuiFocus(false, false)
	while takePhoto do
		Citizen.Wait(1)
            -- if IsControlJustPressed(1, 27) then -- Toogle Mode
            -- frontCam = not frontCam
            -- CellFrontCamActivate(frontCam)
        if IsControlJustPressed(1, 177) then -- CANCEL
			DestroyMobilePhone()
			CellCamActivate(false, false)
			takePhoto = false
			cb({photo = false})
		elseif IsControlJustPressed(1, 176) then -- TAKE.. PIC
			exports['screenshot-basic']:requestScreenshotUpload("https://discord.com/api/webhooks/1022981809803370526/zda2d2xo_GlY-bm5EBfFEfMagPyFiPLGepf138rOMhELaAvoYHf5t-0z0KDlmLjf9zjl", "files[]", function(data)
				local resp = json.decode(data)
				DestroyMobilePhone()
				CellCamActivate(false, false)
				cb({photo = resp.attachments[1].proxy_url})
                takePhoto = false
			end)
		end
		HideHudComponentThisFrame(7)
		HideHudComponentThisFrame(8)
		HideHudComponentThisFrame(9)
		HideHudComponentThisFrame(6)
		HideHudComponentThisFrame(19)
		HideHudAndRadarThisFrame()
	end
    SetNuiFocus(true, true)
end)

RegisterNUICallback('payInvoice', function(data, callback)
    W.TriggerCallback("okokBilling:PayInvoice", function(payed)
        callback({payed = payed})
    end, data.id)
end)

RegisterNUICallback('getUsersSAPD', function(data, callback)
    print("Nui callback")
    W.TriggerCallback("ox_tablet:getUsersSAPD", function(results)
        callback({users = results})
      
    end, data.name)
end)

RegisterNUICallback('getUsersAdmin', function(data, callback)
    print("Nui callback")
    W.TriggerCallback("ox_tablet:getUsersAdmin", function(results)
        callback({users = results})
        
    end, data.name)
end)

RegisterNUICallback('getUsersSearched', function(data, callback)
    W.TriggerCallback("ox_tablet:getUsersSearched", function(results)
        callback({users = results})
    end)
end)

RegisterNUICallback('getUsersEMS', function(data, callback)
    W.TriggerCallback("ox_tablet:getUsersEMS", function(results)
        callback({users = results})
    end, data.name)
end)

RegisterNUICallback('getVehiclesSAPD', function(data, callback)
    W.TriggerCallback("ox_tablet:getVehiclesSAPD", function(results)
        callback({vehs = results})
    end, data.plate)
end)

RegisterNUICallback('getUserSAPD', function(data, callback)
    print('Tetas', json.encode(data))
    W.TriggerCallback("ox_tablet:getUserSAPD", function(result)
        print(json.encode(result))
        callback({user = result})
    end, data.id)
end)

RegisterNUICallback('getUserAdmin', function(data, callback)
    W.TriggerCallback("ox_tablet:getUserAdmin", function(result)
        callback({user = result})
    end, data.id)
end)

RegisterNUICallback('getUserEMS', function(data, callback)
    W.TriggerCallback("ox_tablet:getUserEMS", function(result)
        callback({user = result})
    end, data.id)
end)

RegisterNUICallback('delInvoice', function(data, callback)
    W.TriggerCallback("okokBilling:CancelInvoice", function(payed)
        callback({payed = payed})
    end, data.id)
end)

RegisterNUICallback('delLicense', function(data, callback)
    W.TriggerCallback("ox_tablet:delLicense", function(del)
        callback({deleted = del})
    end, data.id, data.name)
end)

RegisterNUICallback('delAdminHouse', function(data, callback)
    W.TriggerCallback("ox_tablet:delAdminHouse", function(del)
        callback({deleted = del})
    end, data.id)
end)

RegisterNUICallback('delAdminCar', function(data, callback)
    W.TriggerCallback("ox_tablet:delAdminCar", function(del)
        callback({deleted = del})
    end, data.id)
end)

RegisterNUICallback('delAdminDelitos', function(data, callback)
    W.TriggerCallback("ox_tablet:delAdminDelitos", function(del)
        callback({deleted = del})
    end, data.id)
end)

RegisterNUICallback('delAdminMedicHist', function(data, callback)
    W.TriggerCallback("ox_tablet:delAdminMedicHist", function(del)
        callback({deleted = del})
    end, data.id)
end)

RegisterNUICallback('setSecure', function(data, callback)
   TriggerServerEvent("ox_tablet:swapStatusSecure", data.secure, data.citizenid)
end)

RegisterNUICallback('setDanger', function(data, callback)
    TriggerServerEvent("ox_tablet:swapStatusDanger", data.danger, data.citizenid)
end)

RegisterNUICallback('setSearched', function(data, callback)
    TriggerServerEvent("ox_tablet:swapStatusSearched", data.searched, data.citizenid)
end)

RegisterNUICallback('addPenalties', function(data, callback)
    W.TriggerCallback("ox_tablet:addPenalties", function(returned)
        callback({completed = returned.completed})
    end, data)
end)

RegisterNUICallback('addNotes', function(data, callback)
    print(json.encode(data, { indent = true }))
    W.TriggerCallback("ox_tablet:addNotes", function(returned)
        callback({completed = returned.completed})
    end, data)
end)

RegisterNUICallback('addAdminNotes', function(data, callback)
    W.TriggerCallback("ox_tablet:addAdminNotes", function(returned)
        callback({completed = returned.completed})
    end, data)
end)

RegisterNUICallback('updateMedical', function(data, callback)
    -- W.TriggerCallback("ox_tablet:updateMedical", function(returned)
    --     callback({completed = returned.completed})
    -- end, data)
    callback({completed = false})
end)

RegisterNUICallback('updateMedicalRecords', function(data, callback)
    -- W.TriggerCallback("ox_tablet:updateMedicalRecords", function(returned)
    --     callback({completed = returned.completed})
    -- end, data)
    callback({completed = false})
end)

RegisterNUICallback('getMedicalRecord', function(data, callback)
    W.TriggerCallback("ox_tablet:getMedicalRecord", function(returned)
        callback({data = returned})
    end, data)
end)

RegisterNUICallback('modifyUser', function(data, callback)
    W.TriggerCallback("ox_tablet:modifyUser", function(returned)
        callback({completed = returned.completed})
    end, data)
end)

RegisterNUICallback('delNote', function(data, callback)
    TriggerServerEvent("ox_tablet:deleteNote", data.id)
end)

RegisterNUICallback('delAdminNote', function(data, callback)
    TriggerServerEvent("ox_tablet:deleteAdminNote", data.id)
end)

RegisterNUICallback('setPhoto', function(data, callback)
    TriggerServerEvent("ox_tablet:setPhoto", data.citizenid, data.photo)
end)

RegisterNUICallback('delMedicalRecord', function(data, callback)
    TriggerServerEvent("ox_tablet:delMedicalRecord", data.id)
end)

RegisterNUICallback('giveItem', function(data, callback)
    TriggerServerEvent("ox_tablet:giveItem", data.item, data.count)
end)

RegisterNUICallback('deleteRobbery', function(data, callback)
    W.TriggerCallback("ox_tablet:deleteRobbery", function(r)
        callback({completed = r})
    end, data)
end)

RegisterNUICallback('updateRobberies', function(data, callback)
    W.TriggerCallback("ox_tablet:updateRobberies", function(r)
        callback({completed = r})
    end, data)
end)

RegisterNUICallback('setJob', function(data, callback)
    W.TriggerCallback("ox_tablet:setJob", function(r)
        callback(r)
        --[[
            Meter dentro del callback del NUI en caso de que la variable "completed" sea false,
            una notificación de que el jugador no existe
        ]]
    end, data)
end)