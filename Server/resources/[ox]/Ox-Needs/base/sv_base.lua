NeedsController = setmetatable({ }, NeedsController)
NeedsController._variables = {Props = nil}

NeedsController.__index = NeedsController

W.RegisterCommand("setstatus", "admin", function(source, args, player)
    local target = args[1]
    if(target == "me")then
        target = player
    elseif(tonumber(target))then
        target = W.GetPlayer(target)
    else
        return player.Notify("ERROR", "El jugador no fue encontrado", "error")
    end
    local status = args[2]
    local value = tonumber(args[3])
    if(not value or not target or not value)then
        return player.Notify("ERROR", "Alguno de los valores necesarios no fueron indicados correctamente", "error")
    end
    if(status == "thirst" or status == "hunger" or status == "stress")then
        target.status[status] = value 
        target.updateStatus(target.status)
        W.SendToDiscord('admin', "SETSTATUS", GetPlayerName(source).. "ha actualizado el status " .. status .. " | " .. value .. " a " .. target.name, source)
        return player.Notify("ADMINISTRACIÓN", "Actualizaste el status del usuario correctamente", "verify")
    else
        return player.Notify("ERROR", "El nombre del status indicado no es válido", "error") 
    end
end, { { name = 'playerId', help = 'ID del jugador' }, { name = 'status', help = 'thirst|hunger|stress' }, { name = 'value', help = 'Valor del seteo'} }, 'Comando para darle setearle status needs a un jugador')