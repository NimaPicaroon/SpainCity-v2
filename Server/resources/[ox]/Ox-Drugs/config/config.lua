Config = {}
Config.Texts = {
    ['opium'] = 'Tengo un ~y~colega motero~w~ que está plantando esta mierda al lado del puto lago, el pavo esta grillao',
    ['weed'] = 'Tengo un socio que tiene una tienda al lado de una ~y~granja~w~, igual tiene algo que te interesa sabes colega',
    ['hachis'] = 'Te paso una ubicación del ~y~vato~w~ que está por llegar, él les dará la merca. Recuerda llevar dinero en mano.',
    ['coke'] = "Un capullo que conozco esta plantando unas movidas ~y~cerca de una mina~w~ rara y grande de cojones, igual te interesa ir."
}

Config.Items = {
    ['opium'] = {
        {name = "cizallas", label = "Cizallas <span style='color: yellow;'>(90€)</span>", price = 90, blackmoney  = true},
        {name = "mortero", label = "Mortero <span style='color: yellow;'>(150€)</span>", price = 150, blackmoney  = true},
        {name = "bolsa_hermetica", label = "Bolsa hermética <span style='color: yellow;'>(5€)</span>", price = 5, blackmoney  = true},
        {name = "balanza", label = "Balanza <span style='color: yellow;'>(200€)</span>", price = 200, blackmoney  = true}
    },
    ['coke'] = {
        {name = "mortero", label = "Mortero <span style='color: yellow;'>(150€)</span>", price = 150, blackmoney  = true},
        {name = "bolsa_hermetica", label = "Bolsa hermética <span style='color: yellow;'>(5€)</span>", price = 5, blackmoney  = true},
        {name = "balanza", label = "Balanza <span style='color: yellow;'>(200€)</span>", price = 200, blackmoney  = true}
    },
    ['coke2'] = {
        {name = "soda_caustica", label = "Soda cáustica <span style='color: yellow;'>(50€)</span>", price = 50, blackmoney  = true},
        {name = "amoniaco", label = "Amoníaco <span style='color: yellow;'>(50€)</span>", price = 50, blackmoney  = true},
        {name = "acetona", label = "Acetona <span style='color: yellow;'>(50€)</span>", price = 50, blackmoney  = true}
    },
    ['hachis'] = {
        {name = "tamiz", label = "Tamiz <span style='color: yellow;'>(20€)</span>", price = 20, blackmoney  = true},
        {name = "bolsa_hermetica", label = "Bolsa hermética <span style='color: yellow;'>(5€)</span>", price = 5, blackmoney  = true},
        {name = "balanza", label = "Balanza <span style='color: yellow;'>(200€)</span>", price = 200, blackmoney  = true}
    },
    ['hachis2'] = {
        {name = "hoja_hachis", label = "Hojas de hachís <span style='color: red;'>(160€)</span>", price = 160, blackmoney  = true},
        {name = "cancel", label = "No quiero nada"}
    },
    ['weapons'] = {
        {name = "WEAPON_BAT", label = "Bate <span style='color: red;'>(5.500€)</span>", price = 5500, blackmoney  = true},
        {name = "WEAPON_KNIFE", label = "Cuchillo <span style='color: red;'>(6.200€)</span>", price = 6200, blackmoney  = true},
        {name = "semillas", label = "Semillas <span style='color: red;'>(600€)</span>", price = 600, blackmoney  = true},
        {name = "fertilizante", label = "Fertilizante <span style='color: red;'>(100€)</span>", price = 100, blackmoney  = true},
        {name = "agua_purificada", label = "Agua purificada <span style='color: red;'>(100€)</span>", price = 100, blackmoney  = true},
        {name = "WEAPON_KNUCKLE", label = "Puño americano <span style='color: red;'>(6.500€)</span>", price = 6500, blackmoney  = true},
        {name = "WEAPON_MACHETE", label = "Machete <span style='color: red;'>(7.000€)</span>", price = 7000, blackmoney  = true},
        {name = "saco", label = "Saco <span style='color: yellow;'>(1.000€)</span>", price = 1000, blackmoney  = true},
        {name = "WEAPON_CROWBAR", label = "Palanca <span style='color: red;'>(5.500€)</span>", price = 5500, blackmoney  = true},
        {name = "WEAPON_SWITCHBLADE", label = "Navaja <span style='color: red;'>(6.000€)</span>", price = 6000, blackmoney  = true},
        {name = "pistol_box", label = "Caja de 250 Balas de Pistola <span style='color: red;'>(5.000€)</span>", price = 5000, blackmoney  = true},
        {name = "subfusil_box", label = "Caja de 250 Balas de Subfusil <span style='color: red;'>(12.500€)</span>", price = 12500, blackmoney  = true},
        {name = "fusil_box", label = "Caja de 250 Balas de Fusil <span style='color: red;'>(45.000€)</span>", price = 45000, blackmoney  = true},
        {name = "sniper_box", label = "Caja de 250 balas de Sniper <span style='color: red;'>(60.000€)</span>", price = 60000, blackmoney  = true},
        {name = "shotgun_box", label = "Caja de 250 balas de escopeta <span style='color: red;'>(35.000€)</span>", price = 35000, blackmoney  = true},
        {name = "emptyclip", label = "Cargador vacio <span style='color: red;'>(750€)</span>", price = 750, blackmoney  = true},
        {name = "pistol_clip", label = "Cargador de pistola <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "appistol_clip", label = "Cargador de pistola AP <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "vintage_clip", label = "Cargador de pistola vintage <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "heavypistol_clip", label = "Cargador de pistola pesada <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "sns_clip", label = "Cargador de pistola SNS <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "skorpion_clip", label = "Cargador de skorpion <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "uzi_clip", label = "Cargador de uzi <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "shotgun_clip", label = "Cargador de escopeta <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "fusil_clip", label = "Cargador de fusil <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "sniper_clip", label = "Cargador de sniper <span style='color: red;'>(200€)</span>", price = 200, blackmoney  = true},
        {name = "kitauxilios", label = "Botiquin <span style='color: red;'>(500€)</span>", price = 500, blackmoney  = true},
        {name = "lockpick", label = "Ganzua <span style='color: red;'>(500€)</span>", price = 500, blackmoney  = true}
    },
    ['ikea'] = {
        {name = "botella_buceo", label = "Botella de buceo <span style='color: yellow;'>(1.000€)</span>", price = 1000, blackmoney  = false},
        {name = "drill", label = "Taladro <span style='color: yellow;'>(2.000€)</span>", price = 2000, blackmoney  = false},
        {name = "lockpick", label = "Ganzua <span style='color: yellow;'>(200€)</span>", price = 200, blackmoney  = false},
        {name = "bote_vacio", label = "Bote vacio <span style='color: yellow;'>(75€)</span>", price = 75, blackmoney  = false},
        {name = "fishingrod", label = 'Caña de Pescar <span style="color: yellow;">(150€)</span>', price = 150, blackmoney = false},
        {name = "fishbait", label = 'Carnada de Pez <span style="color: yellow;">(20€)</span>', price = 20, blackmoney = false},
        {name = "boombox", label = 'Altavoz <span style="color: yellow;">(500€)</span>', price = 500, blackmoney = false},
        {name = "racingtablet", label = 'Tablet de carreras <span style="color: yellow;">(1.500€)</span>', price = 1500, blackmoney = false},
        {name = "boostingtablet", label = 'Tablet de misiones <span style="color: yellow;">(4.500€)</span>', price = 4500, blackmoney = false}
    },
}

Config.Prices = {
    ["rolex"] = 450,
	["ring"] = 400,
	["necklace"] = 250,
	["vanDiamond"] = 35000,
	["paintingg"] = 15000,
	["paintingf"] = 15000,
	["paintingj"] = 15000,
	["paintingh"] = 15000
}