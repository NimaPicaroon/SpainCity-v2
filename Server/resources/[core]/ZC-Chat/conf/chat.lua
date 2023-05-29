Settings.chat = {
    proximityRadius = 15,
    types = {
        ['me'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(255, 0, 0, 0.3); border:2px solid rgba(255, 0, 0, 0.5); border-radius: 3px; color: rgb(255, 0, 0)">{0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['oop'] = '<div style="color: rgb(169,169,169)">{0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['do'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(0, 108, 255, 0.3); border:2px solid rgba(0, 96, 255, 0.5); border-radius: 3px; color: rgb(0, 126, 255)">{0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['pme'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(255, 0, 0, 0.3); border:2px solid rgba(255, 0, 0, 0.5); border-radius: 3px; color: rgb(255, 0, 0)">Priv - {0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['pdo'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(0, 108, 255, 0.3); border:2px solid rgba(0, 96, 255, 0.5); border-radius: 3px; color: rgb(0, 126, 255)">Priv - {0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['try'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(102, 51, 152, 0.5);border:2px solid #8f68b5; border-radius: 3px; color: #c664ff";>{0}:<span style="color: white; margin-left:5px">%s</span></div>' ,
        ['dados'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(0, 255, 12, 0.3); border:2px solid rgba(0, 194, 50, 0.5); border-radius: 3px; color: rgb(0, 255, 84)";>{0}:<span style="color: white; margin-left:5px">%s</span></div>',
        ['id'] = '<div style="padding: 2.5px; padding-right: 5px; padding-left: 5px; margin-bottom: 5px; margin-right: 0.40vw; background-color: rgba(0, 255, 12, 0.3); border:2px solid rgba(0, 194, 50, 0.5); border-radius: 3px; color: rgb(0, 255, 84)";>{0}:<span style="color: yellow; margin-left:5px">%s</span></div>'
    
    },
    factions = {
        ['police'] = {
            message = '🚓 CNP |^0 %s',
            color = { 100, 100, 255 },
        },
        ['mechanic'] = {
            message = '🧰 LSC |^0 %s',
            color = { 125, 125, 125 },
        },
        ['taxi'] = {
            message = '🚕 Downtown Cab Co. |^0 %s',
            color = { 255, 227, 51 },
        },
        ['ambulance'] = {
            message = '🚑 EMS |^0 %s',
            color = { 255, 51, 51 },
        },
        ['police-ambulance'] = {
            message = '🚓 CNP para SAMS |^0 %s',
            color = { 158, 242, 255 },
        },
        ['ambulance-police'] = {
            message = '🚑 EMS para CNP |^0 %s',
            color = { 255, 71, 71 },
        },
        ['illegalmechanic'] = {
            message = '🧰 HWM |^0 %s',
            color = { 125, 125, 125 }, 
        }
    },
}