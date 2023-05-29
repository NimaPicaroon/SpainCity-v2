function deleteFurni(id, coordsShell, houseShell)
    W.DestroyAllMenus()
    CreateThread(function()
        local add = 'apunta'
        exports['ZC-HelpNotify']:open('MUEBLES | Apunta una entidad para borrarla | Usa <strong>BORRAR</strong> para terminar', 'furniture')
        while true do
            local hit, coords, entity = RayCastGamePlayCamera(1000.0)
            Wait(0)
            local housee = GetHashKey(houseShell)
            local hashEntity = GetHashKey(entity)
            if entity and hashEntity ~= housee then
                DrawLine(GetEntityCoords(PlayerPedId()), GetEntityCoords(entity), 255, 0, 0, 255)
                if add == 'apunta' then
                    exports['ZC-HelpNotify']:close('furniture')
                    add = true
                    exports['ZC-HelpNotify']:open('MUEBLES | Usa <strong>E</strong> para el mueble | Usa <strong>BORRAR</strong> para terminar', 'furniture')
                end
                if IsControlJustPressed(1, 38) then
                    exports['ZC-HelpNotify']:close('furniture')
                    TriggerServerEvent("Ox-Housing:server:deleteFurn", GetEntityCoords(entity), id)
                    DeleteObject(entity)
                end
            elseif hashEntity == housee then
                if add ~= 'apunta' then
                    exports['ZC-HelpNotify']:close('furniture')
                    add = 'apunta'
                    exports['ZC-HelpNotify']:open('MUEBLES | Apunta una entidad para borrarla | Usa <strong>BORRAR</strong> para terminar', 'furniture')
                end
                DrawLine(GetEntityCoords(PlayerPedId()), coords, 0, 0, 0, 255)
            else
                if add ~= 'apunta' then
                    exports['ZC-HelpNotify']:close('furniture')
                    add = 'apunta'
                    exports['ZC-HelpNotify']:open('MUEBLES | Apunta una entidad para borrarla | Usa <strong>BORRAR</strong> para terminar', 'furniture')
                end
                DrawLine(GetEntityCoords(PlayerPedId()), coords, 0, 0, 0, 255)
            end
            if IsControlJustPressed(0, 194) then
                editing = false
                exports['ZC-HelpNotify']:close('furniture')
                break
            end
        end
    end)
end
