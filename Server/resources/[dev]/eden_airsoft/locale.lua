local strings = {
    ['en'] = {
        ['press_to_play'] = 'Press ~INPUT_CONTEXT~ to play Airsoft',
        ['out_of_zone'] = '~r~Out of zone!',
        ['no_money'] = 'You need %s$ to start an airsoft match',
        ['you_win'] = '~g~You won the round',
        ['other_win'] = '~r~Team %s won the round',
        ['team_win'] = '~g~Your team won the match!',
        ['team_lost'] = '~r~Team %s won',
        ['out_of_time'] = '~r~Time Out!',
        ['players_left'] = 'The other team needs to kill %s players to finish',
        ['team_needs_to_kill'] = 'Team %s needs to kill %s players to finish',
        ['cannot_access_weapons'] = 'You cant play with weapons!',
        ['blacklisted_lobby_name'] = 'Your lobby name contains a blacklisted word: %s',
        ['nui_title'] = 'AIRSOFT',
        ['nui_create_room'] = 'New Room',
        ['nui_join_room'] = 'Join Room',
        ['nui_lobby_password'] = 'Room Password',
        ['nui_back_question'] = 'Back',
        ['nui_choose_map'] = 'Select map',
        ['nui_choose_weapon'] = 'Select weapon',
        ['nui_room_config'] = 'Match Config',
        ['nui_room_name'] = 'Room name',
        ['nui_room_pwd'] = 'Room password',
        ['nui_room_rounds'] = 'Rounds',
        ['nui_cancel'] = 'Cancel',
        ['nui_continue'] = 'Continue',
        ['nui_confirm'] = 'Confirm',
        ['nui_room_players'] = 'Room Players',
        ['nui_no_rooms'] = 'No Lobbies!',
        ['nui_room_locked'] = 'Locked',
        ['nui_team'] = 'Team',
        ['nui_round'] = 'Round',
        ['nui_join'] = 'Join',
        ['nui_ready'] = 'READY',
        ['nui_unready'] = 'NOT READY',
        ['nui_exit'] = 'EXIT',
        ['nui_start'] = 'START',
    },

    ['es'] = {
        ['press_to_play'] = 'Presiona ~INPUT_CONTEXT~ para jugar Airsoft',
        ['out_of_zone'] = '~r~Estás fuera de la zona',
        ['no_money'] = 'Necesitas al menos %s$ para hacer una partida de airsoft',
        ['you_win'] = '~g~Has ganado la ronda',
        ['other_win'] = '~r~El equipo %s ha ganado la ronda',
        ['team_win'] = '~g~Tu equipo ha ganado la partida',
        ['team_lost'] = '~r~El equipo %s ha ganado',
        ['out_of_time'] = '~r~Se ha acabado el tiempo!',
        ['players_left'] = 'El equipo contrario tiene que eliminar a %s para finalizar',
        ['team_needs_to_kill'] = 'El equipo %s tiene que eliminar a %s para finalizar',
        ['cannot_access_weapons'] = 'No puedes entrar con armas equipadas!',
        ['blacklisted_lobby_name'] = 'El nombre de la sala contiene una palabra prohibida: %s',
        ['nui_title'] = 'AIRSOFT',
        ['nui_create_room'] = 'Crear Sala',
        ['nui_join_room'] = 'Ver Salas',
        ['nui_lobby_password'] = 'Contraseña de la sala',
        ['nui_back_question'] = 'Atras',
        ['nui_choose_map'] = 'Selecciona un mapa',
        ['nui_choose_weapon'] = 'Selecciona un arma',
        ['nui_room_config'] = 'Configuración de Partida',
        ['nui_room_name'] = 'Nombre de la Sala',
        ['nui_room_pwd'] = 'Contraseña de la Sala',
        ['nui_room_rounds'] = 'Rondas',
        ['nui_cancel'] = 'Cancelar',
        ['nui_continue'] = 'Continuar',
        ['nui_confirm'] = 'Confirmar',
        ['nui_room_players'] = 'Jugadores',
        ['nui_no_rooms'] = '¡No hay salas!',
        ['nui_room_locked'] = 'Protegida',
        ['nui_team'] = 'Equipo',
        ['nui_round'] = 'Ronda',
        ['nui_join'] = 'Unirse',
        ['nui_ready'] = 'LISTO',
        ['nui_unready'] = 'NO LISTO',
        ['nui_exit'] = 'SALIR',
        ['nui_start'] = 'COMENZAR',
    },
}

local lang = Config.Language

if not strings[lang] then
    lang = 'en'
    print(('[EDEN_AIRSOFT] [WARN] Locale %s not found, using en instead'):format(Config.Locale))
end

function L(name, ...)
    if not strings[lang][name] then
        print(('[EDEN_AIRSOFT] [ERROR] Missing translation %s for locale %s'):format(name, lang))
        return 'Missing translation'
    end
    return strings[lang][name]:format(...)
end

function GetLocales(language)
    print(language)
    return strings[language]
end
