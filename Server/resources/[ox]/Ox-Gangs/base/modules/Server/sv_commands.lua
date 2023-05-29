W.RegisterCommand("setgang", "admin", function(source, args, player)
    if not tostring(args[2]) or not Gangs[tostring(args[2])] then
        return player.Notify('ERROR', 'Debes escribir una banda válida/existente.', 'error')
    end

    if not tonumber(args[3]) or not Gangs[tostring(args[2])].ranks[tonumber(args[3])] then
        return player.Notify('ERROR', 'Debes escribir un grado válido/existente.', 'error')
    end

    if args[1] == 'me' then
        if tostring(args[2]) and tonumber(args[3]) then
            AddGang(source, tostring(args[2]), tonumber(args[3]))
        end
    elseif tonumber(args[1]) then
        if tostring(args[2]) and tonumber(args[3]) then
            AddGang(args[1], tostring(args[2]), tonumber(args[3]))
        end
    end
end, { { name = 'playerId', help = 'ID del jugador' }, { name = 'gang', help = 'Nombre de la banda' }, { name = 'rank', 'Grado de la banda '} }, 'Comando para darle banda a un jugador.')

W.RegisterCommand("removegang", "admin", function(source, args, player)
    if args[1] == 'me' then
        RemoveGang(source)
    elseif tonumber(args[1]) then
        RemoveGang(args[1])
    end
end, { { name = 'playerId', help = 'ID del jugador' }}, 'Comando para quitarle la banda a un jugador.')

W.RegisterCommand("darbanda", "user", function(source, args, player)
    if(not args[1])then
        return player.Notify('Miembros', 'Debes escribir una ID válida/existente.', 'error')
    end
    if(not Gangs[player.gang.name])then
        return player.Notify('Miembros', 'La banda que tienes no es válida', 'error')
    end
    if not tonumber(args[2]) or not Gangs[player.gang.name].ranks[tonumber(args[2])] then
        return player.Notify('Miembros', 'Debes escribir un rango válido/existente.', 'error')
    end
    if(Gangs[player.gang.name].ranks[player.gang.rank].isBoss == "false")then
        return player.Notify('Miembros', 'Para utilizar esté comando tienes que ser el jefe de una banda', 'error')
    end
    local targetPlayer = W.GetPlayer(args[1])
    AddGang(args[1], player.gang.name, tonumber(args[2]))
    player.Notify('Miembros', 'Ahora la ID ' .. args[1] .. " es miembro de tu banda", 'verify')
end, { { name = "id", help = "ID de la persona a gestionar"}, {name = "grade", help = "Número del grado al que quieres asignar al usuario"}}, 'Comando para dar banda a un usuario siendo el jefe')

W.RegisterCommand("quitarbanda", "user", function(source, args, player)
    if(not args[1])then
        return player.Notify('Miembros', 'Debes escribir una ID válida/existente.', 'error')
    end

    local targetId = args[1]
    local targetPlayer = W.GetPlayer(targetId)

    if(targetPlayer.gang.name == player.gang.name)then
        if(Gangs[player.gang.name].ranks[player.gang.rank].isBoss == "false")then
            return player.Notify('Miembros', 'Para utilizar esté comando tienes que ser el jefe de una banda', 'error')
        end

        RemoveGang(targetId)
        player.Notify('Miembros', 'El jugador con la ID ' .. targetId .. ' ya no pertenece a tu banda', 'verify')
        targetPlayer.Notify("EMPLEO", 'Ya no eres miembro de la banda '..player.gang.label)
    else
        return player.Notify('Miembros', 'El jugador que intentas echar de la banda no es miembro de tu banda', 'error')
    end
end, { { name = "id", help = "ID de la persona a gestionar"}}, 'Comando para echar de la banda a un miembro')