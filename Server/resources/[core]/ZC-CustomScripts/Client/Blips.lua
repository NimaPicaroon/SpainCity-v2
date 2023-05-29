local blips = {
    [1] = { text = 'Comisaría de Mission Row', color = 29, sprite = 60, coords = vec3(428.65, -980.47, 30.71) },
    -- [2] = { text = 'Departamento Policial de Rockford Hills', color = 29, sprite = 60, coords = vec3(-560.84, -133.6, 37.13) },
    [2] = { text = 'Cuartel del Sheriff (Paleto Bay)', color = 2, sprite = 60, coords = vec3(-439.55, 6016.19, 31.49) },
    -- [3] = { text = 'Departamento Policial de La Mesa', color = 29, sprite = 60, coords = vec3(818.28, -1290.16, 25.33) },
    -- [4] = { text = 'Departamento Policial de Vinewood', color = 29, sprite = 60, coords = vec3(648.29, -9.15, 82.76) },
    [3] = { text = 'Cuartel del Sheriff (Sandy)', color = 2, sprite = 60, coords = vec3(1838.9353, 3685.6821, 39.0762) },
    -- [4] = { text = 'Departamento Federal', color = 5, sprite = 60, coords = vec3(374.96, -1611.4, 28.33) },
    -- [5] = { text = 'Prisión Penintenciaria de Bolingbroke', color = 0, sprite = 188, coords = vec3(1692.8647, 2603.6797, 49.6458) },
    [4] = { text = 'IKEA', color = 0, sprite = 402, coords = vec3(2749.2, 3482.84, 54.73) },
    --[7] = { text = 'Iglesia del Santisimo Salvatore', color = 0, sprite = 120, coords = vec3(-320.7, 2818.95, 59.45) },
    [5] = { text = 'Maze Bank Arena', color = 0, sprite = 124, coords = vec3(-324.2564, -1968.7487, 22.3923) },
    --[6] = { text = 'Weazel News', color = 0, sprite = 475, coords = vec3(-580.03, -931.9, 23.87) },
    [6] = { text = 'INEM', color = 59, sprite = 407, coords = vec3(-267.95, -957.88, 146.34) },
    [7] = { text = '???', color = 40, sprite = 378, coords = vec3(1346.35, 4370.88, 146.34) },

}

Citizen.CreateThread(function()
    for index = 1, #blips do
        local blip = AddBlipForCoord(blips[index].coords)

        SetBlipSprite (blip, blips[index].sprite)
        SetBlipScale  (blip, 0.8)
        SetBlipDisplay(blip, 4)
        SetBlipColour (blip, blips[index].color)
        SetBlipAsShortRange(blip, true)
        BeginTextCommandSetBlipName("STRING")
        AddTextComponentString(blips[index].text)
        EndTextCommandSetBlipName(blip)
    end
end)