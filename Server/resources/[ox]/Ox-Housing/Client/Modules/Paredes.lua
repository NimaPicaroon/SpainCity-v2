function editWalls(shell, id)
    exports['ZC-HelpNotify']:close('suelo')
    CreateThread(function()
        local selected = 1
        local type = "paredes"
        local wtxd = nil
        local wtxn = nil
        local ftxd = nil
        local ftxn = nil
        for k, v in pairs(Housing['shellDict']) do
            if v.shell == shell then
                if v.type == "pared" then
                    wtxd = v.txd
                    wtxn = v.txn
                elseif v.type == "suelo" then
                    ftxd = v.txd
                    ftxn = v.txn
                end
            end
        end
        editing = true
        exports['ZC-HelpNotify']:open('PAREDES | Usa <strong>flechita izq y flechita der</strong> para cambiar de textura | Usa <strong>flechita arr.</strong> para cambiar de modificación | Usa <strong>BORRAR</strong> para terminar', 'walls')
        while true do
            Wait(0)
            if wtxd and wtxn then
                if type == "paredes" then
                    if IsControlJustPressed(1, 175) then
                        if selected == #Housing['walls'] then
                            selected = 1
                        else
                            selected = selected + 1
                        end
                        local url = Housing['walls'][selected]
                        changeWall(wtxd, wtxn, Housing['walls'][selected], id)
                        TriggerServerEvent("Ox-Housing:server:syncToPlayersInside", "paredes", wtxd, wtxn, url, id)
                        Wait(500)
                    end

                    if IsControlJustPressed(1, 174) then
                        if selected == 1 then
                            selected = #Housing['walls']
                        else
                            selected = selected - 1
                        end
                        local url = Housing['walls'][selected]
                        changeWall(wtxd, wtxn, Housing['walls'][selected], id)
                        TriggerServerEvent("Ox-Housing:server:syncToPlayersInside", "paredes", wtxd, wtxn, url, id)
                        Wait(500)
                    end

                    if IsControlJustPressed(1, 172) then
                        local have = false
                        for k, v in pairs(Housing['shellDict']) do
                            if v.shell == shell then
                                if v.type == 'suelo' then
                                    have = true
                                end
                            end
                        end
                        Wait(100)
                        if have then
                            editFloor(shell, id)
                            TriggerServerEvent("Ox-Housing:server:addPaint", "paredes", wtxd, wtxn, Housing['walls'][selected], id)
                            editing = false
                            break
                        else
                            W.Notify("CASA", 'No hay otra cosa para cambiar', 'error')
                            exports['ZC-HelpNotify']:close('walls')
                            editing = false
                            break
                        end
                    end

                    if IsControlJustPressed(0, 194) then
                        TriggerServerEvent("Ox-Housing:server:addPaint", "paredes", wtxd, wtxn, Housing['walls'][selected], id)
                        editing = false
                        exports['ZC-HelpNotify']:close('walls')
                        break
                    end
                end
            elseif ftxd and ftxn then
                editFloor(shell, id)
                exports['ZC-HelpNotify']:close('walls')
                editing = false
                break
            else
                W.Notify("CASA", 'No hay nada para cambiar', 'error')
                editing = false
                break
            end
        end
    end)
end

function editFloor(shell, id)
    exports['ZC-HelpNotify']:close('walls')
    CreateThread(function()
        local selected = 1
        local wtxd = nil
        local wtxn = nil
        local ftxd = nil
        local ftxn = nil
        for k, v in pairs(Housing['shellDict']) do
            if v.shell == shell then
                if v.type == "pared" then
                    wtxd = v.txd
                    wtxn = v.txn
                elseif v.type == "suelo" then
                    ftxd = v.txd
                    ftxn = v.txn
                end
            end
        end
        editing = true
        exports['ZC-HelpNotify']:open('SUELO | Usa <strong>flechita izq y flechita der</strong> para cambiar de textura | Usa <strong>flechita arr.</strong> para cambiar de modificación | Usa <strong>BORRAR</strong> para terminar', 'suelo')
        while true do
            if IsControlJustPressed(1, 175) then
                if selected == #Housing['floors'] then
                    selected = 1
                else
                    selected = selected + 1
                end
                local url = Housing['floors'][selected]
                changeFloor(ftxd, ftxn, Housing['floors'][selected], id)
                TriggerServerEvent("Ox-Housing:server:syncToPlayersInside", "suelo", ftxd, ftxn, url)
                Wait(500)
            end

            if IsControlJustPressed(1, 174) then
                if selected == 1 then
                    selected = #Housing['floors']
                else
                    selected = selected - 1
                end
                local url = Housing['floors'][selected]
                changeFloor(ftxd, ftxn, Housing['floors'][selected], id)
                TriggerServerEvent("Ox-Housing:server:syncToPlayersInside", "suelo", ftxd, ftxn, url)
                Wait(500)
            end

            if IsControlJustPressed(1, 172) then
                local have = false
                for k, v in pairs(Housing['shellDict']) do
                    if v.shell == shell then
                        if v.type == 'pared' then
                            have = true
                        end
                    end
                end
                Wait(100)
                if have then
                    editWalls(shell, id)
                    TriggerServerEvent("Ox-Housing:server:addPaint", "suelo", wtxd, wtxn, Housing['floors'][selected], id)
                    editing = false
                    break
                else
                    W.Notify("CASA", 'No hay otra cosa para cambiar', 'error')
                    exports['ZC-HelpNotify']:close('suelo')
                    editing = false
                    break
                end
            end

            if IsControlJustPressed(0, 194) then
                TriggerServerEvent("Ox-Housing:server:addPaint", "suelo", wtxd, wtxn, Housing['floors'][selected], id)
                editing = false
                exports['ZC-HelpNotify']:close('suelo')
                break
            end
            Wait(0)
        end
    end)
end

function changeWall(initTxd, initTxn, nTxn, id)
    CreateThread(function()
        if nTxn == "default" then
            log("Restableciendo default...")
            --AddReplaceTexture(initTxd, initTxn, initTxd, initTxn)
            RemoveReplaceTexture(initTxd, initTxn)
        else
            local txd = CreateRuntimeTxd('duiTxd'..id)
            local duiObj = CreateDui(nTxn, 1100, 620)
            _G.duiObj = duiObj
            local dui = GetDuiHandle(duiObj)
            local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
            AddReplaceTexture(initTxd, initTxn, 'duiTxd'..id, 'duiTex')
        end
    end)
end

function changeFloor(initTxd, initTxn, nTxn, id)
    CreateThread(function()
        if nTxn == "default" then
            log("Restableciendo default...")
            --AddReplaceTexture(initTxd, initTxn, initTxd, initTxn)
            RemoveReplaceTexture(initTxd, initTxn)
        else
            local txd = CreateRuntimeTxd('duiTxd'..id) 
            local duiObj = CreateDui(nTxn, 1100, 618)
            _G.duiObj = duiObj
            local dui = GetDuiHandle(duiObj)
            local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
            AddReplaceTexture(initTxd, initTxn, 'duiTxd'..id, 'duiTex')
        end
    end)
end

function changeWallOnLoad(shell, nTxn, id)
    local initTxd = nil
    local initTxn = nil
    for k, v in pairs(Housing['shellDict']) do
        if v.shell == shell then
            if v.type == "pared" then
                initTxd = v.txd
                initTxn = v.txn
                break
            end
        end
    end
    if initTxn and initTxd then
        CreateThread(function()
            if nTxn == "default" then
                log("Restableciendo default...")
                --AddReplaceTexture(initTxd, initTxn, initTxd, initTxn)
                RemoveReplaceTexture(initTxd, initTxn)
            else
                local txd = CreateRuntimeTxd('duiTxd'..id) 
                local duiObj = CreateDui(nTxn, 1100, 620)
                _G.duiObj = duiObj
                local dui = GetDuiHandle(duiObj)
                local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
                AddReplaceTexture(initTxd, initTxn, 'duiTxd'..id, 'duiTex')
            end
        end)
    end
end

function changeFloorOnLoad(shell, nTxn, id)
    local initTxd = nil
    local initTxn = nil
    for k, v in pairs(Housing['shellDict']) do
        if v.shell == shell then
            if v.type == "suelo" then
                initTxd = v.txd
                initTxn = v.txn
            end
        end
    end
    if initTxn and initTxd then
        CreateThread(function()
            if nTxn == "default" then
                log("Restableciendo default...")
                --print(initTxd, initTxn)
                RemoveReplaceTexture(initTxd, initTxn)
                --AddReplaceTexture(initTxd, initTxn, initTxd, initTxn)
            else
                local txd = CreateRuntimeTxd('duiTxd'..id) 
                local duiObj = CreateDui(nTxn, 1100, 618)
                _G.duiObj = duiObj
                local dui = GetDuiHandle(duiObj)
                local tx = CreateRuntimeTextureFromDuiHandle(txd, 'duiTex', dui)
                AddReplaceTexture(initTxd, initTxn, 'duiTxd'..id, 'duiTex')
            end
        end)
    end
end

RegisterNetEvent("Ox-Housing:client:syncType")
AddEventHandler("Ox-Housing:client:syncType", function(type, ftxd, ftxn, url, id)
    if type == "paredes" then
        changeWall(ftxd, ftxn, url, id)
    elseif type == "suelo" then
        changeFloor(ftxd, ftxn, url, id)
    end
end)