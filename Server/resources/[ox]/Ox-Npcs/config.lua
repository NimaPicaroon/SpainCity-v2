Config = {}

Config.Key = 38 -- [E] Key to open the interaction, check here the keys ID: https://docs.fivem.net/docs/game-references/controls/#controls

Config.AutoCamPosition = true -- If true it'll set the camera position automatically

Config.AutoCamRotation = true -- If true it'll set the camera rotation automatically

Config.HideMinimap = false -- If true it'll hide the minimap when interacting with an NPC

Config.UseOkokTextUI = false -- If true it'll use okokTextUI 

Config.CameraAnimationTime = 1000 -- Camera animation time: 1000 = 1 second

Config.TalkToNPC = {
	{
		npc = 'u_m_y_abner', -- Banco tocho
		header = 'Empleado',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(254.17, 222.8, 105.3),
		heading = 160.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_m_y_hasjew_01', -- Banco mecanico
		header = 'Empleado',
		name = 'Brayan',
		uiText = "Brayan",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-352.76, -50.76, 48.04),
		heading = 340.64,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_f_y_business_01', -- Banco gc
		header = 'Empleada',
		name = 'Jessica',
		uiText = "Jessica",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(148.08, -1041.56, 28.36),
		heading = 342.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_f_y_business_02', -- Banco lifeinvader
		header = 'Empleada',
		name = 'Alisson',
		uiText = "Alisson",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-1213.24, -332.6, 36.8),
		heading = 29.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_m_y_business_02', -- Banco autopista
		header = 'Empleado',
		name = 'Ethan',
		uiText = "Ethan",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-2961.16, 481.4, 14.68),
		heading = 87.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_m_y_busicas_01', -- Banco sandy
		header = 'Empleado',
		name = 'Maverick',
		uiText = "Maverick",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(1176.44, 2708.24, 37.08),
		heading = 181.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'a_m_y_business_01', -- Banco paleto
		header = 'Empleado',
		name = 'George',
		uiText = "George",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-111.28, 6470.04, 30.64),
		heading = 135.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero cobrar mi sueldo', 'ZCore:paycheck', 's'},
			{'¿Cómo puedo robar el banco?', 'okokTalk:rob', 'c'},
			{"He perdido mi tarjeta, ¿me podéis dar otra? (200$)", 'Ox-Banking:newCreditBank', 's'},
			{"Quiero crearme una cuenta", 'Ox-Banking:createAccount', 's'},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-719.04, -1326.15, 0.6),
		heading = 60.0,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(-719.04, -1326.15, 0.6)},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-3427.03, 967.55, 7.35),
		heading = 266.77,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(-3427.03, 967.55, 8.35)},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-1612.11, 5260.41, 2.97),
		heading = 266.77,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(-1612.11, 5260.41, 3.97)},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(-275.91, 6638.13, 6.48),
		heading = 227.77,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(-275.91, 6638.13, 7.48)},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(3854.76, 4463.93, 1.73),
		heading = 266.77,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(3854.76, 4463.93, 2.73)},
		},
		jobs = {

		},
	},
	{
		npc = 'ig_ramp_hic', -- Alquiler barcos
		header = 'Alquiler de Barcos',
		name = 'Robert',
		uiText = "Robert",
		dialog = 'Muy buenas, ¿en que puedo ayudarte?',
		coordinates = vector3(12.37, -2801.16, 1.53),
		heading = 266.77,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'¿Cómo alquilo un barco?', 'rent:rentBoat', 'c', vector3(12.37, -2801.16, 2.53)},
		},
		jobs = {

		},
	},
	{
		npc = 'cs_omega', -- Opio
		header = 'Desconocido',
		name = 'Dereck',
		uiText = "Dereck",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(2485.15, 3718.53, 42.47),
		heading = 218.96,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero comprarte algo', 'Ox-Drugs:buyItems', 'c', 'opium'},
			{'¿Dónde puedo ir?', 'Ox-Drugs:goSite', 'c', 'opium'},
		},
		jobs = {

		},
		gangs = true
	},
	{
		npc = 'u_m_m_aldinapoli', -- Hachis
		header = 'Desconocido',
		name = 'Tovaldo',
		uiText = "Tovaldo",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(848.84, -2504.26, 39.69),
		heading = 274.16,
		camOffset = vector3(0.0, 0.0, 0.0),
		scenario = "WORLD_HUMAN_DRUG_DEALER",
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero comprarte algo', 'Ox-Drugs:buyItems', 'c', 'hachis'},
			{'¿Dónde puedo ir?', 'Ox-Drugs:goSite', 'c', 'hachis'},
		},
		jobs = {

		},
		gangs = true
	},
	{
		npc = 'cs_wade', -- coke
		header = 'Desconocido',
		name = 'Wade',
		uiText = "Wade",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(2932.59, 4284.09, 70.96),
		heading = 177.49,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero comprarte algo', 'Ox-Drugs:buyItems', 'c', 'coke'},
			{'¿Dónde puedo ir?', 'Ox-Drugs:goSite', 'c', 'coke'},
		},
		jobs = {

		},
		gangs = true
	},
	{
		npc = 'mp_m_meth_01', -- coke
		header = 'Desconocido',
		name = 'Smith',
		uiText = "Smith",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(-110.36, -14.51, 69.52),
		heading = 342.23,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		options = {
			{'Quiero comprarte algo', 'Ox-Drugs:buyItems', 'c', 'coke2'},
		},
		jobs = {

		},
		gangs = true
	},
	{
		npc = 'g_m_y_famfor_01', -- weapons
		header = 'Desconocido',
		name = 'Tyson',
		uiText = "Tyson",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(-764.46, -690.54, 10.6),
		heading = 192.96,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'Quiero comprarte algo', 'Ox-Drugs:buyItems', 'c', 'weapons'},
		},
		jobs = {

		},
		gangs = true
	},
	{
		npc = 'a_f_y_gencaspat_01', -- ikea
		header = 'Desconocido',
		name = 'Lara',
		uiText = "Lara",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(2749.2, 3482.84, 54.73),
		heading = 66.96,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'Quiero comprar algo', 'Ox-Drugs:buyItems', 'c', 'ikea'},
		},
		jobs = {

		}
	},
	{
		npc = 'g_f_y_vagos_01', -- venta joyas
		header = 'Desconocido',
		name = 'Harrison',
		uiText = "Harrison",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(-3107.31, 326.09, 2.99),
		heading = 77.78,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'Quiero vender lo que tengo', 'Ox-Drugs:sellItems', 'c'},
		},
		jobs = {

		}
	},
	{
		npc = 's_m_m_paramedic_01', -- venta joyas
		header = 'Desconocido',
		name = 'Robert',
		uiText = "Robert",
		dialog = '¿Tu compañero necesita auxilio?',
		coordinates = vector3(2487.5398, 3726.3240, 42.9216),
		heading = 44.3408,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'¡Ayuda a mi amigo por favor!', 'cherry-medicoilegal:c:revivir', 'c'},
		},
		jobs = {

		}
	},
	{
		npc = 'g_f_y_ballas_01', -- venta drogas
		header = 'Desconocido',
		name = 'Gisela',
		uiText = "Gisela",
		dialog = 'Que pasa, ¿que quieres?',
		coordinates = vector3(2329.26, 2569.67, 45.72),
		heading = 309.37,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'Quiero vender lo que tengo', 'Ox-Drugs:sellDrugs', 'c'},
		},
		jobs = {
		},
		gangs = true
	},
	{
		npc = 'u_m_m_jewelsec_01', -- INEM
		header = 'Empleador',
		name = 'Antonio',
		uiText = "Antonio",
		dialog = '¿De qué quieres trabajar?',
		coordinates = vector3(-268.38, -957.42, 30.22),
		heading = 205.81,
		camOffset = vector3(0.0, 0.0, 0.0),
		camRotation = vector3(0.0, 0.0, 0.0),
		interactionRange = 2.5,
		anim = {"anim@amb@casino@hangout@ped_male@stand@01a@base", "base"},
		options = {
			{'Electricista', 'Ox-Npcs:Waypoint', 'c', 'electricista'},
			{'Carguero', 'Ox-Npcs:Waypoint', 'c', 'carguero'},
			{'Cultivo', 'Ox-Npcs:Waypoint', 'c', 'cultivo'},
			{'Ganadero', 'Ox-Npcs:Waypoint', 'c', 'ganadero'},
			{'Camionero del Sur', 'Ox-Npcs:Waypoint', 'c', 'camsur'},
			{'Camionero del Norte', 'Ox-Npcs:Waypoint', 'c', 'camnorte'},
		},
		jobs = {
		},
		gangs = false
	},
}