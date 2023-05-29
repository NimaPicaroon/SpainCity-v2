function DialogMenu()
    local choosed = ''

    W.OpenDialog("Cantidad", "dialog2_qua", function(amount)
        if amount and amount ~= '' then
            W.CloseDialog()
            choosed = amount
        else
            W.Notify("CREADOR", 'Inválido', 'error')
        end
    end)

    while choosed == '' do Citizen.Wait(500) end

    return choosed
end

function SelectMenu()
    local choosed = ''

	local elements = {
		{ label = 'Añadir', value = 'add'},
		{ label = 'Quitar', value = 'remove'}
	}
    Wait(150)
	W.OpenMenu("Creador de Items", "crea4t_menu", elements, function (data, name)
		W.DestroyMenu(name)
        choosed = data.value
    end)

    while choosed == '' do Citizen.Wait(500) end

    return choosed
end

function SelectMenu2()
    local choosed = ''

	local elements = {
		{ label = 'Bebida', value = 'drink'},
		{ label = 'Comida', value = 'food'}
	}
    Wait(150)
	W.OpenMenu("Creador de Items", "crea3t_menu", elements, function (data, name)
		W.DestroyMenu(name)
        choosed = data.value
    end)

    while choosed == '' do Citizen.Wait(500) end

    return choosed
end

RegisterCommand("createitem", function(source, args)
	local xPlayerData = W.GetPlayerData()
	if(xPlayerData.group == "admin")then
		local selected = {
			name = '❌',
			label = '❌',
			limit = '❌',
			weight = '❌',
			toeattodrink = '❌',
			prop = '❌',
			thirst = '❌',
			hunger = '❌',
			--stress = '❌',
			drunk = '❌',
			mbebida = '❌',
			mhambre = '❌',
			--mstress = '❌',
			mborrachera = '❌',
			selthirst = '❌',
			selhunger = '❌',
			--selstress = '❌',
			seldrunk = '❌',
			type = '❌',
			metadata = '❌',
			metadata2 = '❌'
		}
	
		local elements = {
			{ label = 'Nombre de spawn - '.. selected.name, value = 'name'},
			{ label = 'Nombre que saldrá - ' .. selected.label, value = 'label'},
			{ label = 'Límite - ' .. selected.limit, value = 'limit'},
			-- { label = 'Peso - ' .. selected.weight, value = 'weight'},
			{ label = 'Modificar bebida - ' .. selected.mbebida, value = 'mbebida'},
			{ label = 'Modificar hambre - ' .. selected.mhambre, value = 'mhambre'},
			--{ label = 'Modificar stress - ' .. selected.mstress, value = 'mstress'},
			{ label = 'Modificar borrachera - ' .. selected.mborrachera, value = 'mborrachera'},
			{ label = 'Prop - ' .. selected.prop, value = 'prop'},
			{ label = 'Tipo - ' .. selected.type, value = 'type'},
			{ label = 'Terminar', value = 'end'}
		}
	
		CreateItemMenu(elements, selected)
	end
end)

function CreateItemMenu(elements, selected)

	elements = {
		{ label = 'Nombre de spawn - '.. selected.name, value = 'name'},
		{ label = 'Nombre que saldrá (Label) - ' .. selected.label, value = 'label'},
		{ label = 'Límite - ' .. selected.limit, value = 'limit'},
		-- { label = 'Peso (el valor se dividirá entre 10) - ' .. selected.weight, value = 'weight'},
		{ label = 'Modificar bebida - ' .. selected.mbebida, value = 'mbebida'},
		{ label = 'Modificar hambre - ' .. selected.mhambre, value = 'mhambre'},
		--{ label = 'Modificar stress - ' .. selected.mstress, value = 'mstress'},
		{ label = 'Modificar borrachera - ' .. selected.mborrachera, value = 'mborrachera'},
		{ label = 'Prop - ' .. selected.prop, value = 'prop'},
        { label = 'Tipo - ' .. selected.type, value = 'type'},
		{ label = 'Terminar', value = 'end'}
	}
    Wait(200)
	W.OpenMenu("Creador de Items", "creat_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == "name" then
			selected.name = DialogMenu()
            CreateItemMenu(elements, selected)
        elseif data.value == "label" then
			selected.label = DialogMenu()
            CreateItemMenu(elements, selected)
		elseif data.value == "limit" then
            selected.limit = DialogMenu()
            CreateItemMenu(elements, selected)
        elseif data.value == "weight" then
            selected.weight = DialogMenu()
            CreateItemMenu(elements, selected)
		elseif data.value == "prop" then
            selected.prop = DialogMenu()
            CreateItemMenu(elements, selected)
        elseif data.value == "type" then
            selected.type = DialogMenu()
            CreateItemMenu(elements, selected)
		elseif data.value == "mbebida" then
			if selected.mbebida == '✔️' then
				selected.mbebida = '❌'
			else
            	selected.mbebida = '✔️'
			end
            CreateItemMenu(elements, selected)
		elseif data.value == "mhambre" then
			if selected.mhambre == '✔️' then
				selected.mhambre = '❌'
			else
            	selected.mhambre = '✔️'
			end
            CreateItemMenu(elements, selected)
		-- elseif data.value == "mstress" then
		-- 	if selected.mstress == '✔️' then
		-- 		selected.mstress = '❌'
		-- 	else
        --     	selected.mstress = '✔️'
		-- 	end
        --     CreateItemMenu(elements, selected)
		elseif data.value == "mborrachera" then
			if selected.mborrachera == '✔️' then
				selected.mborrachera = '❌'
			else
            	selected.mborrachera = '✔️'
			end
            CreateItemMenu(elements, selected)
        elseif data.value == "end" then
            if selected.name == '❌' or selected.label == '❌' or selected.prop == '❌' or selected.limit == '❌' then
                W.Notify("CREADOR", 'Inserta todos los valores')
                CreateItemMenu(elements, selected)
            else
                CreateItemMenu2(selected)
            end
		end
    end)
end

function CreateItemMenu2(selected)
    W.DestroyAllMenus()

	local elements = {}

	if selected.mbebida == '✔️' then
		table.insert(elements, { label = 'Quitar o Añadir Bebida - ' .. selected.selthirst, value = 'selthirst'})
		table.insert(elements, { label = '% de Bebida - ' .. selected.thirst, value = 'thirst'})
        table.insert(elements, { label = 'mL de Bebida (se quitan 10 por uso) - ' .. selected.metadata, value = 'metadata'})
	end
	if selected.mhambre == '✔️' then
		table.insert(elements, { label = 'Quitar o Añadir Comida - ' .. selected.selhunger, value = 'selhunger'})
		table.insert(elements, { label = '% de Hambre - ' .. selected.hunger, value = 'hunger'})
        table.insert(elements, { label = 'g de la comida (se quitan 10 por uso) - ' .. selected.metadata2, value = 'metadata2'})
	end
	-- if selected.mstress == '✔️' then
	-- 	table.insert(elements, { label = 'Quitar o Añadir Stress - ' .. selected.selstress, value = 'selstress'})
	-- 	table.insert(elements, { label = '% de Stress - ' .. selected.stress, value = 'stress'})
	-- end
	if selected.mborrachera == '✔️' then
		table.insert(elements, { label = 'Quitar o Añadir Borrachera - ' .. selected.seldrunk, value = 'seldrunk'})
		table.insert(elements, { label = '% de Borrachera - ' .. selected.drunk, value = 'drunk'})
        table.insert(elements, { label = 'mL de Bebida (se quitan 10 por uso) - ' .. selected.metadata, value = 'metadata'})
	end

	table.insert(elements, { label = '¿Para comer o beber? - ' .. selected.toeattodrink, value = 'toeattodrink'})
	table.insert(elements, { label = 'Terminar', value = 'end'})
    Wait(200)
	W.OpenMenu("Creador de Items", "creat2_menu", elements, function (data, name)
		W.DestroyMenu(name)
		if data.value == "toeattodrink" then
			selected.toeattodrink = SelectMenu2()
			CreateItemMenu2(selected)
		elseif data.value == "selthirst" then
			selected.selthirst = SelectMenu()
			CreateItemMenu2(selected)
        elseif data.value == "metadata" then
			selected.metadata = DialogMenu()
			CreateItemMenu2(selected)
        elseif data.value == "metadata2" then
			selected.metadata2 = DialogMenu()
			CreateItemMenu2(selected)
		elseif data.value == "selhunger" then
			selected.selhunger = SelectMenu()
			CreateItemMenu2(selected)
		-- elseif data.value == "selstress" then
		-- 	selected.selstress = SelectMenu()
		-- 	CreateItemMenu2(selected)
		elseif data.value == "seldrunk" then
			selected.seldrunk = SelectMenu()
			CreateItemMenu2(selected)
		elseif data.value == "thirst" then
            selected.thirst = DialogMenu()
            CreateItemMenu2(selected)
		elseif data.value == "hunger" then
            selected.hunger = DialogMenu()
            CreateItemMenu2(selected)
		-- elseif data.value == "stress" then
        --     selected.stress = DialogMenu()
        --     CreateItemMenu2(selected)
		elseif data.value == "drunk" then
            selected.drunk = DialogMenu()
            CreateItemMenu2(selected)
        elseif data.value == "end" then
			TriggerServerEvent('ZCore:createItem', selected)
		end
    end)
end