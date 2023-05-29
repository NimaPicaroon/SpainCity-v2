Config = {}
Config.StartingApartment = true -- Enable/disable starting apartments (make sure to set default spawn coords)
Config.Interior = vector3(-773.01, 342.64, 211.4) -- Interior to load where characters are previewed
Config.DefaultSpawn = vector3(-1035.71, -2731.87, 12.86) -- Default spawn coords if you have start apartments disabled
Config.PedCoords = vector4(-774.46, 324.48, 212.03, 355.51) -- Create preview ped at these coordinates
Config.HiddenCoords = vector4(-774.46, 324.48, 212.03, 355.51) -- Hides your actual ped Ma-cro guapo while you are in selection
Config.CamCoords = vector4(-773.01, 342.64, 211.4, 2.50) -- Camera coordinates for character preview screen 
Config.EnableDeleteButton = true -- Define if the player can delete the character or not

Config.DefaultNumberOfCharacters = 5 -- Define maximum amount of default characters (maximum 5 characters defined by default)
Config.PlayersNumberOfCharacters = { -- Define maximum amount of player characters by rockstar license (you can find this license in your server's database in the player table)
    { license = "license:ed41b87fcb55d24fc56b1e138843046c21a4b856", numberOfChars = 2 },
    { license = "license:3013edb87fd4a3d11f008f1fe7799cff27f25d64", numberOfChars = 2 },
    { license = "license:9f87fbbe817443617ee8cc60e029360e3eeb53c9", numberOfChars = 2 },
    { license = "license:33279aa53c7718b7c43057a743f7fd64072013ec", numberOfChars = 2 },
}
