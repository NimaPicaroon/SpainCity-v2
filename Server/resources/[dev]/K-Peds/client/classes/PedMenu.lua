function PedMenu(peds, core, name)

    self = {}

    self.core = core
    self.peds = peds
    self.name = name
    self.menuPeds = {}

    self.OpenMenu = function()
        
        if Config.Debug then print('^2[ks_peds] - ^2debuggin ^1(^3OpenMenu^1)^2 function in class ^1(^3PedMenu^1)^2 ...') end
        
        SetNuiFocus(true, true)
        SendNUIMessage({
            action = "showPeds",
            peds = self.peds
        })

        if Config.Debug then print('^2[ks_peds] - ^2debuggin ^1(^3OpenMenu^1)^2 function in class ^1(^3PedMenu^1)^2 menu opened') end

    end

    self.setPed = function(ped)
        TriggerServerEvent('ks_peds:setPed', ped)
    end

    self.setDefaultPed = function()
        TriggerServerEvent('ks_peds:setPed', "")
    end

    RegisterNUICallback("close",
        function()
            SetNuiFocus(false, false)
        end
    )

    RegisterNUICallback("default_ped",
        function()
            SetNuiFocus(false, false)
            self.setDefaultPed()
        end
    )

    RegisterNUICallback("setPed",
        function(data)
            print(json.encode(data))
            SetNuiFocus(false, false)
            self.setPed(data.ped)
        end
    )

    return self

end