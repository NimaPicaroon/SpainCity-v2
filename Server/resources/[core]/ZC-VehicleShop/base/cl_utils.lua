local NumberCharset = {}
local Charset = {}
Utils = {}

for i = 48,  57 do table.insert(NumberCharset, string.char(i)) end

for i = 65,  90 do table.insert(Charset, string.char(i)) end
for i = 97, 122 do table.insert(Charset, string.char(i)) end

function Utils.GeneratePlate()
	local generatedPlate
	local doBreak = false

	while true do
		Wait(2)
		math.randomseed(GetGameTimer())
		generatedPlate = string.upper(GetRandomLetter(3) .. GetRandomNumber(3))

		W.TriggerCallback('vehicleshop:plateTaken', function(isPlateTaken)
			if not isPlateTaken then
				doBreak = true
			end
		end, generatedPlate)

		if doBreak then
			break
		end
	end

	return generatedPlate
end

exports('generatePlate', Utils.GeneratePlate)

function GetRandomNumber(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomNumber(length - 1) .. NumberCharset[math.random(1, #NumberCharset)]
	else
		return ''
	end
end

function GetRandomLetter(length)
	Wait(1)
	math.randomseed(GetGameTimer())
	if length > 0 then
		return GetRandomLetter(length - 1) .. Charset[math.random(1, #Charset)]
	else
		return ''
	end
end

HaveKeys = function(plate)
    local inventory = W.GetItemsForInventory()

    for k,v in pairs(inventory.data) do
        if v.name == 'carkey' then
            if tostring(json.decode(v.metadata).plate) == tostring(plate) then
                return true
            end
        end
    end

    return false
end

exports('HaveKeys', HaveKeys)