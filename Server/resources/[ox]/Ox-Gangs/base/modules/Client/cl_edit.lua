RegisterNUICallback('editGang', function(data, cb)
    W.TriggerCallback('Ox-Gangs:editGang', function(edited, gangs)
        if edited then
            cb(gangs)
        else
            W.Notify('BANDAS', 'Algo ha ~r~fallado', 'error')
        end
    end, data)
end)