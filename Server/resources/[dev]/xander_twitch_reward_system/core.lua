
W.RegisterCommand('addTwitch', 'admin', function(playerSrc, playerArgs, player)
    exports["xander_twitch_reward_system"]:addStreamer(playerArgs[1], playerArgs[2])
end, { { name = 'ID', help = 'id de la persona' }, { name = 'Nombre', help = 'nombre de la persona' } }, 'Comando para añadir twitch a un usuario')

AddEventHandler('twitchRewardNotifyB', function(data)
    print('Pagando a Streamers ...')
    for k, v in ipairs(data) do
        local source = v.source
        local money = v.money
        local viewers = v.viewers
        local title = v.title
        local login = v.login
        local player = W.GetPlayer(v.source)
        if viewers > 0 then
            player.Notify('Twitch', 'Te han pagado '..(viewers*100)..'$ por tener '..viewers..' viewers y 10$ por hacer stream :)')
        else
            player.Notify('Twitch', 'No tienes viewers :( pero te han pagado 10$ por compasion :)')
        end
        player.addMoney('bank', (viewers*100 + 100))
    end
end)