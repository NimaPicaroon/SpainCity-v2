Speed = { }
Speed.__data = { cam = nil, time = nil }
Speed.__index = Speed

Speed.InitCam = function(zone)
    if zone == 'beach' then
        local ply = PlayerPedId()

        SetEntityHeading(ply, 29.64)
        FreezeEntityPosition(ply, true)

        W.Notify('GIMNASIO', 'Este es la dirección del ~y~recorrido~w~ de la carrera. Debes llegar al final de la calle.')
        
        Wait(5000)

        W.Notify('GIMNASIO', 'Una vez llegues allí, ~y~deberás volver~w~ para acabar la carrera')
    end
end