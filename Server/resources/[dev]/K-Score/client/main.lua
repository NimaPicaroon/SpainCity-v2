-- Global Variables
local showing = false

-- Main Functions
function openScore (src, args)
    if showing then showHide() end
    local jobsData = getActiveJobs().jobsData
    showHide(jobsData)
    showing = not showing
end

function showHide (data)
    if showing then
        SendNUIMessage({
            show = false
        })
    else
        SendNUIMessage({
            show = true,
            data = data,
            userID = GetPlayerServerId(NetworkGetEntityOwner(PlayerPedId())),
            players = getActivePlayers()
        })
    end
end

function getActivePlayers()
    local players = promise.new()
    W.TriggerCallback('K-Score:getData',
        function(plys)
            players:resolve(plys)
        end
    )
    return Citizen.Await(players)
end

function getActiveJobs()
    self = {}
    self.jobsData = {}
    for k,v in pairs(Shared.Jobs) do
        local data = promise.new()
        W.TriggerCallback('Wave:GetPlayersJob',
            function(k_job)
                if k_job then
                    data:resolve({
                        name = k,
                        count = #k_job,
                        label = v.label
                    })
                end
            end, k, true
        )
        self.jobsData[k] = Citizen.Await(data)
    end
    return self
end

--  Configurations

Shared = {
    Jobs = {
        ['police'] = {
            label = "CNP"
        },
        ['ambulance'] = {
            label = "EMS"
        },
        ['taxi'] = {
            label = "TAXI"
        }
    }
}

-- Rich presence

SetDiscordAppId(1069776413688877127)

Citizen.CreateThread(function()
	while true do
		SetDiscordRichPresenceAsset('spaincitylogo') 
		SetDiscordRichPresenceAssetText('SpainCity RP Servidor de Rol de GTAV') 
		SetDiscordRichPresenceAssetSmall('')
		SetDiscordRichPresenceAssetSmallText('discord.gg/spaincityrp')
		SetRichPresence("ID: " ..GetPlayerServerId(PlayerId()).. " | " .. getActivePlayers() .. " Jugadores") 
		SetDiscordRichPresenceAction(0, 'Únete al Discord!', 'https://discord.gg/spaincity')
        SetDiscordRichPresenceAction(1, 'Conéctate al Servidor!', 'fivem://connect/cfx.re/join/d9qxjd')
		Wait(5000)
	end
end)

-- Command And Keymapping 
RegisterCommand('scoreboard', openScore)
RegisterKeyMapping('scoreboard', 'Abrir scoreboard', 'keyboard', 'F9')