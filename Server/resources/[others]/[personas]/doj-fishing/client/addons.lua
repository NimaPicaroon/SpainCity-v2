
local W = exports.ZCore:get()

function BoatMenuLaPuerta()
    exports['menu']:openMenu({
        {
            header = "La Puerta Alquiler de barcos",
            isMenuHeader = true
        },
        {
            header = "Barco: "..Config.RentalBoat,
            txt = "Precio: $"..Config.BoatPrice,
            params = {
                event = "doj:client:rentaBoat",
				args = 1
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function BoatMenuPaletoCove()
    exports['menu']:openMenu({
        {
            header = "Paleto Cove Alquiler de barcos",
            isMenuHeader = true
        },
        {
            header = "Barco: "..Config.RentalBoat,
            txt = "Precio: $"..Config.BoatPrice,
            params = {
                event = "doj:client:rentaBoat",
				args = 2
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function BoatMenuElGordo()
    exports['menu']:openMenu({
        {
            header = "El Gordo Alquiler de barcos",
            isMenuHeader = true
        },
        {
            header = "Barco: "..Config.RentalBoat,
            txt = "Precio: $"..Config.BoatPrice,
            params = {
                event = "doj:client:rentaBoat",
				args = 3
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 


function BoatMenuActDam()
    exports['menu']:openMenu({
        {
            header = "Act Dam Alquiler de barcos",
            isMenuHeader = true
        },
        {
            header = "Barco: "..Config.RentalBoat,
            txt = "Precio: $"..Config.BoatPrice,
            params = {
                event = "doj:client:rentaBoat",
				args = 4
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function BoatMenuAlamoSea()
    exports['menu']:openMenu({
        {
            header = "Alamo Sea Alquiler de barcos",
            isMenuHeader = true
        },
        {
            header = "Barco: "..Config.RentalBoat,
            txt = "Precio: $"..Config.BoatPrice,
            params = {
                event = "doj:client:rentaBoat",
				args = 5
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 
--============================================================== ReturnMenus

function ReturnBoatLaPuerta()
    exports['menu']:openMenu({
		{
            header = "Alquiler de barcos de pesca",
            isMenuHeader = true
        },
		{
            header = "Regresar barco",
            txt = "regresa y obtiene $"..math.floor(Config.BoatPrice/2),
            params = {
                event = "doj:client:ReturnBoat",
				args = 1
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function ReturnBoatPaletoCove()
    exports['menu']:openMenu({
		{
            header = "Alquiler de barcos de pesca",
            isMenuHeader = true
        },
		{
            header = "Regresar barco",
            txt = "regresa y obtiene $"..math.floor(Config.BoatPrice/2),
            params = {
                event = "doj:client:ReturnBoat",
				args = 2
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function ReturnBoatElGordo()
    exports['menu']:openMenu({
		{
            header = "Alquiler de barcos de pesca",
            isMenuHeader = true
        },
		{
            header = "Regresar barco",
            txt = "regresa y obtiene $"..math.floor(Config.BoatPrice/2),
            params = {
                event = "doj:client:ReturnBoat",
				args = 3
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function ReturnBoatActDam()
    exports['menu']:openMenu({
		{
            header = "Alquiler de barcos de pesca",
            isMenuHeader = true
        },
		{
            header = "Regresar barco",
            txt = "regresa y obtiene $"..math.floor(Config.BoatPrice/2),
            params = {
                event = "doj:client:ReturnBoat",
				args = 4
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end 

function ReturnBoatAlamoSea()
    exports['menu']:openMenu({
		{
            header = "Alquiler de barcos de pesca",
            isMenuHeader = true
        },
		{
            header = "Regresar barco",
            txt = "regresa y obtiene $"..math.floor(Config.BoatPrice/2),
            params = {
                event = "doj:client:ReturnBoat",
				args = 5
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end

--============================================================== Sell/Gear Menus

RegisterNetEvent('doj:client:SellLegalFish')
AddEventHandler('doj:client:SellLegalFish', function()
    exports['menu']:openMenu({
		{
            header = "Pearl's Seafood Restaurante",
            isMenuHeader = true
        },
        {
            header = "Vender Caballa",
            txt = "Precio actual: $"..Config.mackerelPrice.." cada uno",
            params = {
				isServer = true,
                event = "fishing:server:SellLegalFish",
				args = 1
            }
        },
        {
            header = "Vender bacalao",
            txt = "Precio actual: $"..Config.codfishPrice.." cada uno",
            params = {
				isServer = true,
                event = "fishing:server:SellLegalFish",
				args = 2
            }
        },
		{
            header = "Vender lubina",
            txt = "Precio actual: $"..Config.bassPrice.." cada uno",
            params = {
				isServer = true,
                event = "fishing:server:SellLegalFish",
				args = 3 
            }
        },
        {
            header = "Vender Platija",
            txt = "Precio actual: $"..Config.flounderPrice.." cada uno",
            params = {
				isServer = true,
                event = "fishing:server:SellLegalFish",
				args = 4
            }
        },
		{
            header = "Vender mantarraya",
            txt = "Precio actual: $"..Config.stingrayPrice.." cada uno",
            params = {
				isServer = true,
                event = "fishing:server:SellLegalFish",
				args = 5
            }
        },		
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('doj:client:buyFishingGear')
AddEventHandler('doj:client:buyFishingGear', function() 
    exports['menu']:openMenu({
		{
            header = "Compra equipo de pesca",
            isMenuHeader = true
        },
        {
            header = "Comprar cebo de pesca",
            txt = "$"..Config.fishingBaitPrice,
            params = {
				isServer = true,
                event = "fishing:server:BuyFishingGear",
				args = 1
            }
        },
		{
            header = "Comprar caña de pescar",
            txt = "$"..Config.fishingRodPrice,
            params = {
				isServer = true,
                event = "fishing:server:BuyFishingGear",
				args = 2
            }
        },
        {
            header = "Comprar ancla de barco",
            txt = "$"..Config.BoatAnchorPrice,
            params = {
				isServer = true,
                event = "fishing:server:BuyFishingGear",
				args = 3
            }
        },
        {
            header = "Comprar caja de pesca",
            txt = "$"..Config.FishingBoxPrice,
            params = {
				isServer = true,
                event = "fishing:server:BuyFishingGear",
				args = 4
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end)

RegisterNetEvent('doj:client:SellillegalFish')
AddEventHandler('doj:client:SellillegalFish', function() 
    W.Notify('Pesca', 'Bienvenido a la tienda', 'verify')
    exports['menu']:openMenu({
        {
            header = "Pearl's Seafood Restaurante",
            isMenuHeader = true
        },
        {
            header = "Vender delfín",
            txt = "Precio actual: $"..Config.dolphinPrice.." cada uno",
            params = {
                isServer = true,
                event = "fishing:server:SellillegalFish",
                args = 1
            }
        },
        {
            header = "Vender tiburón tigre",
            txt = "Precio actual: $"..Config.sharktigerPrice.." cada uno",
            params = {
                isServer = true,
                event = "fishing:server:SellillegalFish",
                args = 2
            }
        },
        {
            header = "Vender tiburón martillo",
            txt = "Precio actual: $"..Config.sharkhammerPrice.." cada uno",
            params = {
                isServer = true,
                event = "fishing:server:SellillegalFish",
                args = 3
            }
        },
        {
            header = "vender orca",
            txt = "Precio actual: $"..Config.killerwhalePrice.." cada uno",
            params = {
                isServer = true,
                event = "fishing:server:SellillegalFish",
                args = 4
            }
        },
        {
            header = "Cerrar",
            txt = "",
            params = {
                event = "menu:closeMenu"
            }
        },
    })
end)
