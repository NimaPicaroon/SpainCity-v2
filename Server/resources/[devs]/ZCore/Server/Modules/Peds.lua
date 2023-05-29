RegisterNetEvent("ZCore:registerPed", function(key)
    local src = source
    local player = W.GetPlayer(src)

    PerformHttpRequest("https://waverp.es/foro/applications/nexus/interface/licenses/?info&key=".. key .."", function(err, data, headers)
        data = json.decode(data)
        if data and data.uses == 0 then
            pedname = data.purchase_name
            pedname = pedname:gsub("%(", "")
            pedname = pedname:gsub("%)", "")
            pedname = pedname:gsub("%Ped del servidor (", "")
            player.updatePed(pedname)

            PerformHttpRequest("https://waverp.es/foro/applications/nexus/interface/licenses/?activate&key=".. key .."", function (errorCode, resultData, resultHeaders)
                print("La llave ha sido activada con exito para el ped:", pedname)
            end)
        elseif data and data.uses == 1 then
            print("La licencia ya ha sido activada!")
        else
            print("La licencia no es valida!")
        end
    end, "GET", "", {["Content-Type"] = "application/json", ['User-Agent'] = 'Foro', ['Host'] = "waverp.es"}) 
end)