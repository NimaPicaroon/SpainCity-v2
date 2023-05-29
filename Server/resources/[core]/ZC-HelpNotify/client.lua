PLAYED_NOTIFIES = {}

function Open(message, id)
	if not PLAYED_NOTIFIES[id] then
		PLAYED_NOTIFIES[id] = true
		SendNUIMessage({
			action = 'open',
			message = message,
			id = id
		})
	end
end

function Close(id)
	if not PLAYED_NOTIFIES[id] then return end

	PLAYED_NOTIFIES[id] = false
	SendNUIMessage({
		action = 'close',
		id = id
	})
end

RegisterCommand('fixnotify', function()
	for key in next, PLAYED_NOTIFIES do
		Close(key)
	end
end)

exports('open', Open)
exports('close', Close)