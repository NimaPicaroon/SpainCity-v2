Config = {
	uage = "es",					-- You can change the uage here. I translated some with a tool online so they might not be 100% accurate. Let me know!
	ExtrasEnabled = true,				-- This toggles the extra commands (Shirt, Pants) in case you dont want your players stripping their clothes for whatever reason.
	Debug = false,						-- Enables logging and on screen display of what your character is wearing.
	GUI = {
		Position = {x = 0.65, y = 0.5},	-- 0.5 is the middle!
		AllowInCars = true,			-- Allow the GUI in cars?
		AllowWhenRagdolled = false,			-- Allow the GUI when ragdolled?
		Enabled = true, 				-- You can turn the gui off here, the base commands will still work.
		Key = 311, 				-- Change the GUI key here.
		Sound = true,					-- You can disable sound in the GUI here.
		TextColor = {255,255,255},
		TextOutline = true,
		TextFont = 0,					-- Change font, useful for other uages.
		TextSize = 0.21,				-- Change the text size below buttons here, useful for other uages.
	}
}

Config.Commands = {
	["zapatos"] = {
		Func = function() ToggleClothing("Shoes") end,
		Sprite = "shoes",
		Desc = string.format('Quitar / Poner tu %s', string.lower('Zapatos')),
		Button = 5,
		Name = '~y~Zapatos'
	},
	["chaleco"] = {
		Func = function() ToggleClothing("Vest") end,
		Sprite = "vest",
		Desc = string.format('Quitar / Poner tu %s', string.lower('chaleco')),
		Button = 14,
		Name = "~y~Chaleco"
	},
	["mascara"] = {
		Func = function() ToggleClothing("Mask") end,
		Sprite = "mask",
		Desc = string.format('Quitar / Poner tu %s', string.lower('máscara')),
		Button = 6,
		Name = "~y~Máscara"
	},
	["chaqueta"] = {
		Func = function() ToggleClothing("Top", true) end,
		Sprite = "top",
		Desc = string.format('Quitar / Poner tu %s', string.lower('chaqueta')),
		Button = 1,
		Name = "~y~Chaqueta"
	},
	-- [("chaqueta")] = {
	-- 	Func = function() ToggleClothing("Top") end,
	-- 	Sprite = "top",
	-- 	Desc = ("Variación de la camisa de cambio"),
	-- 	Button = 1,
	-- 	Name = ("~y~Chaqueta")
	-- },
	[("guantes")] = {
		Func = function() ToggleClothing("Gloves") end,
		Sprite = "gloves",
		Desc = string.format(("Quitar / Poner tus %s"), string.lower(("guantes"))),
		Button = 2,
		Name = ("~y~Guantes")
	},
	[("visor")] = {
		Func = function() ToggleProps("Visor") end,
		Sprite = "visor",
		Desc = ("Variación del gorro"),
		Button = 3,
		Name = ("~y~Visor")
	},
	[("mochila")] = {
		Func = function() ToggleClothing("Bag") end,
		Sprite = "bag",
		Desc = ("Abre o cierra tu bolsa"),
		Button = 8,
		Name = ("~y~Mochila")
	},
	[("togglehair")] = {
		Func = function() ToggleClothing("Hair") end,
		Sprite = "hair",
		Desc = ("Pon tu cabello arriba/abajo en un moño/cola de caballo"),
		Button = 7,
		Name = ("~y~Pelo")
	},
	[("gorro")] = {
		Func = function() ToggleProps("Hat") end,
		Sprite = "hat",
		Desc = string.format(("Quitar / Poner tu %s"), string.lower(("gorro"))),
		Button = 4,
		Name = ("~y~Gorro")
	},
	[("gafas")] = {
		Func = function() ToggleProps("Glasses") end,
		Sprite = "glasses",
		Desc = string.format(("Quitar / Poner tus %s"), string.lower(("gafas"))),
		Button = 9,
		Name = ("~y~Gafas")
	},
	[("pendientes")] = {
		Func = function() ToggleProps("Ear") end,
		Sprite = "ear",
		Desc = string.format(("Quitar / Poner tus %s"), string.lower(("pendientes"))),
		Button = 10,
		Name = ("~y~Pendiente")
	},
	[("cadena")] = {
		Func = function() ToggleClothing("Neck") end,
		Sprite = "neck",
		Desc = string.format(("Quitar / Poner tu %s"), string.lower(("Cadena"))),
		Button = 11,
		Name = ("~y~Cadena")
	},
	[("reloj")] = {
		Func = function() ToggleProps("Watch") end,
		Sprite = "watch",
		Desc = string.format(("Quitar / Poner tu %s"), string.lower(("Reloj"))),
		Button = 12,
		Name = ("~y~Reloj"),
		Rotation = 5.0
	},
	[("brazalete")] = {
		Func = function() ToggleProps("Bracelet") end,
		Sprite = "bracelet",
		Desc = string.format(("Quitar / Poner tu %s"), string.lower(("Brazalete"))),
		Button = 13,
		Name = ("~y~Brazalete")
	},
}

local Bags = {				-- This is where bags/parachutes that should have the bag sprite, instead of the parachute sprite.
	[40] = true,
	[41] = true,
	[44] = true,
	[45] = true
}

Config.ExtraCommands = {
	["resetclothing"] = {
		Func = function() if not ResetClothing() then W.Notify('ERROR', "Ya estás usando esto") end end,
		Sprite = "reset",
		Desc = "Volver todo a la normalidad",
		Name = "~y~Resetear",
		OffsetX = 0.12,
		OffsetY = 0.2,
	},
	['mochila'] = {
		Func = function() ToggleClothing("Bagoff", true) end,
		Sprite = "bagoff",
		SpriteFunc = function()
			local Bag = GetPedDrawableVariation(PlayerPedId(), 5)
			local BagOff = LastEquipped["Bagoff"]
			if LastEquipped["Bagoff"] then
				if Bags[BagOff.Drawable] then
					return "bagoff"
				else
					return "paraoff"
				end
			end
			if Bag ~= 0 then
				if Bags[Bag] then
					return "bagoff"
				else
					return "paraoff"
				end
			else
				return false
			end
		end,
		Desc = string.format('Quitar / Poner tu %s', string.lower('mochila')),
		Name = 'Mochila',
		OffsetX = -0.12,
		OffsetY = 0.2,
	},
	['pantalones'] = {
		Func = function() ToggleClothing("Pants", true) end,
		Sprite = "pants",
		Desc = string.format('Quitar / Poner tus %s', string.lower('pantalones')),
		Name = '~y~Pantalones',
		OffsetX = -0.04,
		OffsetY = 0.0,
	},
	['camiseta'] = {
		Func = function() ToggleClothing("Shirt", true) end,
		Sprite = "shirt",
		Desc = string.format('Quitar / Poner tu %s', string.lower('camiseta')),
		Name = '~y~Camiseta',
		OffsetX = 0.04,
		OffsetY = 0.0,
	},
}