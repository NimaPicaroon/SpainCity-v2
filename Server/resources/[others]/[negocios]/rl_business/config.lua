Config              = {}
Config.DrawDistance = 50
Config.Size         = {x = 1.5, y = 1.5, z = 1.5}
Config.Color        = {r = 0, g = 128, b = 255}
Config.Type         = 25
Config.Locale       = 'es'
Config.AnnouncePrice = 10

Config.ItemEat = {
	["noodle_box"] = {
		object = "prop_ff_noodle_02",
		object2 = "prop_cs_fork",
		effect = 50,
		label = "Fidéos Chinos",
		dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
		anim = "base_idle",
		offset = {-0.08},
		type = "plate"
	},
	["plate_1"] = {
		object = "prop_cs_plate_01",
		object2 = "prop_cs_fork",
		effect = 80,
		label = "Guarnición",
		dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
		anim = "base_idle",
		offset = {-0.02},
		type = "plate"
	},
	["plate_2"] = {
		object = "v_res_tt_pizzaplate",
		object2 = "prop_cs_fork",
		effect = 40,
		label = "Porción de Pizza",
		dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
		anim = "base_idle",
		offset = {-0.02},
		type = "plate"
	},
	["plate_3"] = {
		object = "prop_plate_03",
		object2 = "prop_cs_fork",
		effect = 40,
		label = "Burrito",
		dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
		anim = "base_idle",
		offset = {-0.02},
		type = "plate"
	},
	["plate_4"] = {
		object = "prop_cs_bowl_01b",
		object2 = "h4_prop_h4_caviar_spoon_01a",
		effect = 80,
		label = "Cuenco de lentejas",
		dict = "anim@scripted@island@special_peds@pavel@hs4_pavel_ig5_caviar_p1",
		anim = "base_idle",
		offset = {-0.03},
		type = "plate"
	},
	["coffee_serve"] = {
		object = "p_amb_coffeecup_01",
		effect = 40,
		label = "Café",
		dict = "amb@world_human_drinking@coffee@male@idle_a",
		anim = "idle_c",
		offset = {-0.05},
		type = "drink"
	},
	["cola_serve"] = {
		object = "prop_ecola_can",
		effect = 40,
		label = "refresco",
		dict = "amb@world_human_drinking@coffee@male@idle_a",
		anim = "idle_c",
		offset = {-0.05},
		type = "drink"
	},
	["sprunk_serve"] = {
		object = "prop_beer_blr",
		effect = 40,
		label = "Cerveza",
		dict = "amb@world_human_drinking@beer@male@idle_a",
		anim = "idle_c",
		offset = {-0.00},
		type = "drink"
	},
	["vinewood_blanc"] = {
		object = "prop_drink_redwine",
		effect = 40,
		label = "Vino Rojo",
		dict = "amb@world_human_drinking@beer@male@idle_a",
		anim = "idle_c",
		offset = {-0.05},
		type = "drink"
	},
	["vinewood_red"] = {
		object = "prop_drink_whtwine",
		effect = 40,
		label = "Vino Blanco",
		dict = "amb@world_human_drinking@beer@male@idle_a",
		anim = "idle_c",
		offset = {-0.05},
		type = "drink"
	}
}
--
Config.ItemShots = {
	["ronshot"] = {
		object = "prop_rum_bottle",
		effect = 10,
		label = "Ron",
	},
	["whiskeyshot"] = {
		object = "prop_cs_whiskey_bottle",
		effect = 15,
		label = "Whisky",
	},
	["shot"] = {
		object = "prop_bottle_richard",
		effect = 20,
		label = "Tequila",
	},
	["herbshot"] = {
		object = "prop_plonk_red",
		effect = 10,
		label = "Licor Hierbas",
	},
	["cnshot"] = {
		object = "prop_plonk_red",
		effect = 70,
		label = "Chuck Norris",
	}
}