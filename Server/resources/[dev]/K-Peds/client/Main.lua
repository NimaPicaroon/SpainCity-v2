RegisterNetEvent('ks_peds:client:openMenu',
    function(peds, name)
        if peds then
            if Config.Debug then
                print('^2[ks_peds] - ^2debuggin ^1(^3ks_peds:client:openMenu^1)^2 client event ...')
            end
            local PedMenu = PedMenu(peds, W, name..math.random(0, 10000))
            PedMenu.OpenMenu()
            if Config.Debug then
                print('^2[ks_peds] - ^2debuggin ^1(^3ks_peds:client:openMenu^1)^2 client event peds ^1(^3'..json.encode(peds)..'^1)^2 sended to ^1(^3PedMenu^1)^2 class successfully!')
            end
        else
            W.Notify('PEDS', Config.Lang.NoPed)
        end
    end
)

RegisterCommand('peds',
    function(source, arguments)
        TriggerServerEvent('ks_peds:server:openMenu')
    end
)