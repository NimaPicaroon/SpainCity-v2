RegisterNUICallback('GetJobsState', function(a, cb)
	W.TriggerCallback("jobscontroller:getActiveStores", function (data)
        cb(json.encode(data))
	end)
end)

function cnpplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : CNP" }, color = {255, 0, 145} })
			end
		end
	end, 'police', true)
end

function lscplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Los Santos Customs" }, color = {255, 0, 145} })
			end
		end
	end, 'lsc', true)
end

function ambulanceplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : EMS" }, color = {255, 0, 145} })
			end
		end
	end, 'ambulance', true)
end

function vanillaplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Vanilla" }, color = {255, 0, 145} })
			end
		end
	end, 'vanilla', true)
end

function bennysplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Taller Benny's" }, color = {255, 0, 145} })
			end
		end
	end, 'bennys', true)
end

function galaxyplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Galaxy" }, color = {255, 0, 145} })
			end
		end
	end, 'galaxy', true)
end

function uwucafeplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : UwU cafe" }, color = {255, 0, 145} })
			end
		end
	end, 'uwucafe', true)
end

function badugroveplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Badulaque grove" }, color = {255, 0, 145} })
			end
		end
	end, 'badugrove', true)
end

function baduvanillaplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Badulaque vanilla" }, color = {255, 0, 145} })
			end
		end
	end, 'baduvanilla', true)
end

function baducentralplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Badulaque central" }, color = {255, 0, 145} })
			end
		end
	end, 'baducentral', true)
end

function tequilaplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Tequila" }, color = {255, 0, 145} })
			end
		end
	end, 'tequila', true)
end

function bahamasplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Bahamas" }, color = {255, 0, 145} })
			end
		end
	end, 'bahamas', true)
end

function terrazacasinoplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Terraza del casino" }, color = {255, 0, 145} })
			end
		end
	end, 'terrazacasino', true)
end

function taxiplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Taxi's" }, color = {255, 0, 145} })
			end
		end
	end, 'taxi', true)
end

function pacificplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Pacific" }, color = {255, 0, 145} })
			end
		end
	end, 'pacific', true)
end

function pearlsplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Pearls" }, color = {255, 0, 145} })
			end
		end
	end, 'pearls', true)
end

function pizzaplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Hoover's Pizza" }, color = {255, 0, 145} })
			end
		end
	end, 'pizza', true)
end

function ottosplayers()
	W.TriggerCallback("Wave:GetPlayersJob", function (players)
		for k,v in ipairs(players) do
			if v then
				TriggerEvent('chat:addMessage', { args = {v," : Mecánico Otto's:" }, color = {255, 0, 145} })
			end
		end
	end, 'mecaotto', true)
end

RegisterCommand("revisolocales", function()
    local data = W.GetPlayerData()
    if data.group == 'mod' or data.group == 'admin' then
		TriggerEvent('chat:addMessage', { args = {"------ GENTE DE SERVICIO EN LOCALES ------" }, color = {255, 255, 255} })
		Wait (700)
		lscplayers()
		Wait (700)
		--cnpplayers()
		--Wait (500)
		ambulanceplayers()
		Wait (700)
		vanillaplayers()
		Wait (700)
		bennysplayers()
		Wait (700)
		galaxyplayers()
		Wait (700)
		uwucafeplayers()
		Wait (700)
		--badugroveplayers()
		--Wait (700)
		baduvanillaplayers()
		Wait (700)
		baducentralplayers()
		Wait (700)
		tequilaplayers()
		Wait (700)
		bahamasplayers()
		Wait (700)
		terrazacasinoplayers()
		Wait (700)
		taxiplayers()
		Wait (700)
		pacificplayers()
		Wait (700)		
		pearlsplayers()
		Wait (700)		
		pizzaplayers()
		Wait (700)
		ottosplayers()
		Wait (700)
		TriggerEvent('chat:addMessage', { args = {"--------------------------------------------" }, color = {255, 255, 255} })
    else
        W.Notify("ADMINISTRACIÓN", "No tienes permiso para este comando", 'warn')
    end
end)

RegisterCommand("deserviciocnp", function()
	local data = W.GetPlayerData()
    if data.group == 'admin' then
		cnpplayers()
	end
end)