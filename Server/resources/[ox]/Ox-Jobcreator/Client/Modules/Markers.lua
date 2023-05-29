GLOBAL_BLIPS = {}
isBoss = false

---comment
JOB.CreateBlips = function()
    for k,v in pairs(GLOBAL_BLIPS) do
        RemoveBlip(v.blip)
    end

    for k,v in pairs(GlobalState.JobsBlips) do
        if v.x and v.y and v.z then
            local blip = AddBlipForCoord(vector3(tonumber(v.x) + 0.0, tonumber(v.y) + 0.0, tonumber(v.z) + 0.0))
            SetBlipSprite(blip, tonumber(v.sprite))
            SetBlipColour(blip, tonumber(v.color))
            SetBlipScale(blip, 0.8)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(v.text)
            EndTextCommandSetBlipName(blip)

            table.insert(GLOBAL_BLIPS, { blip = blip })
        end
    end
end

JOB.HandleAll = function ()
    JOB.Variables.IsChanging = true
    CreateThread(function ()
        Wait(10)

        while not JOB.GlobalData.job do
            Wait(1000)
        end

        JOB.Variables.IsChanging = false
        JOB.Variables.OwnJob = JOB.GlobalData.job
        local JobData = GlobalState[JOB.Variables.OwnJob.name.."-guille"]
        local oldRankname = JOB.Variables.OwnJob.rankname
        if(JobData and JobData.ranks)then
            for i = 1, #JobData.ranks, 1 do
                if JobData.ranks[i].name == JOB.GlobalData.job.rankname then
                    isBoss = JobData.ranks[i].isBoss
    
                    if isBoss == 'true' then
                        isBoss = true
                    elseif isBoss == 'false' then
                        isBoss = false
                    else
                        isBoss = false
                    end
                end
            end
        end

        JOB.CreateBlips(JobData)
        while true do
            local PlayerPed = PlayerPedId()
            local PlayerCoords = GetEntityCoords(PlayerPed)
            local Sleep = 1000
            for k, v in pairs(JobData.points) do
                local MarkerCoords = vec3(tonumber(v.x), tonumber(v.y), tonumber(v.z) - 0.93)
                local Distance = #(MarkerCoords - PlayerCoords)

                if Distance < 5.0 then
                    Sleep = 0

                    if oldRankname ~= JOB.GlobalData.job.rankname then
                        oldRankname = JOB.GlobalData.job.rankname

                        for i = 1, #JobData.ranks, 1 do
                            if JobData.ranks[i].name == JOB.GlobalData.job.rankname then
                                isBoss = JobData.ranks[i].isBoss

                                if isBoss == 'true' then
                                    isBoss = true
                                elseif isBoss == 'false' then
                                    isBoss = false
                                else
                                    isBoss = false
                                end
                            end
                        end
                    end

                    if JOB.Variables.OwnJob.duty then
                        if v.selected == 'savevehs' then
                            DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 3.401, 3.401, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                        elseif v.selected == 'getvehs' then
                            DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 255, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                        elseif v.selected == 'getheli' then
                            if IsPedInAnyVehicle(PlayerPedId()) then
                                DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 6.01, 6.01, 0.11, 255, 0, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                            else
                                DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.11, 0, 255, 0, 255, 0, 0, 0, 0, 0, 0, 0)
                            end
                        elseif v.selected == 'duty' then
                            DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                        elseif v.selected == 'boss' then
                            if isBoss then
                                DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                            end
                        else
                            DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 190, 45, 255, 0, 0, 0, 0, 0, 0, 0)
                        end
                    elseif not JOB.Variables.Own and v.selected == 'duty' then
                        DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                    end
                    if Distance < 2.0 then
                        JOB.Markers[v.selected](MarkerCoords, isBoss)
                    end
                end
            end

            if JOB.Variables.OwnJob.name == "ambulance" then
                local MarkerCoords = vec3(-459.16, -312.24, 33.97)
                local Distance = #(MarkerCoords - PlayerCoords)
                if Distance < 3.0 then
                    Sleep = 0
                    DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                    W.ShowText(vector3(MarkerCoords.x, MarkerCoords.y, MarkerCoords.z + 1), '~y~Hospital\n~w~Sacar una silla de ruedas', 0.5, 8)
                    if Distance < 1.5 then
                        if IsControlJustReleased(0, 38) then
                            local chair = CreateVehicle(GetHashKey("wheelchair"), vec3(-459.16, -312.24, 33.97), 285.88, true, true)
                            exports['LegacyFuel']:SetFuel(chair, 100.0)
                        end
                    end
                end
            end

            if JOB.Variables.OwnJob.name == "police" then
                local MarkerCoords = vec3(474.36, -991.24, 25.27)
                local Distance = #(MarkerCoords - PlayerCoords)
                if Distance < 3.0 then
                    Sleep = 0
                    DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                    W.ShowText(vector3(MarkerCoords.x, MarkerCoords.y, MarkerCoords.z + 1), '~y~Comisaría\n~w~Incautaciones', 0.5, 8)
                    if Distance < 1.5 then
                        if IsControlJustReleased(0, 38) then
                            JOB.OpenArmory(true)
                        end
                    end
                end
            end

            if JOB.Variables.OwnJob.name == "police" then
                local MarkerCoords = vec3(-450.8, 5998.22, 26.70)
                local Distance = #(MarkerCoords - PlayerCoords)
                if Distance < 3.0 then
                    Sleep = 0
                    DrawMarker(1, MarkerCoords, 0, 0, 0, 0, 0, 0, 1.401, 1.401, 0.051, 255, 255, 255, 255, 0, 0, 0, 0, 0, 0, 0)
                    W.ShowText(vector3(MarkerCoords.x, MarkerCoords.y, MarkerCoords.z + 1), '~y~Comisaría\n~w~Incautaciones', 0.5, 8)
                    if Distance < 1.5 then
                        if IsControlJustReleased(0, 38) then
                            JOB.OpenArmory(true)
                        end
                    end
                end
            end

            if JOB.Variables.IsChanging then
                break
            end
            Wait(Sleep)
        end
    end)
end