---@generic Prop: table
---@param PropSettings Prop
function createPersonAnimation(PropSettings)
    exports['dpemotes']:PlayEmote(PropSettings)
end

---@generic Prop: string
---@param PropName Prop
---@return table
function getEmoteConfig(PropName)
    return {
    "impexp_int-0",
    "mp_m_waremech_01_dual-0",
        "Teddy",
        AnimationOptions = {
            Prop = PropName,
            PropBone = 24817,
            PropPlacement = {-0.20, 0.46, -0.016, -180.0, -90.0, 0.0},
            EmoteMoving = true,
            EmoteLoop = true
        }
    }
end

-- Open shop menu
function openShop()
    W.OpenMenu("Funko Shop", "funko_shop_menu", Config.ShopItems,
        function (data, name)
            TriggerServerEvent('funko:buy', data.price, data.id)
            W.DestroyMenu(name)
        end
    )
end

-- Open player menu
function openPlayerFunkos()
    W.TriggerCallback('funko:getPlayerFunkos', function(funkos)
        if #funkos < 1 then return end
        local funkoMenu = {}
        for _,v in pairs(funkos) do
            local funkoInfo = Config.OwnedMenuLabels[v]
            if funkoInfo then
                table.insert(funkoMenu, {label = funkoInfo.label, prop = funkoInfo.prop})
            end
        end
        W.OpenMenu("Funko Menu", "funko_user_menu", funkoMenu,
            function (data, menu)
                local config = getEmoteConfig(data.prop)
                createPersonAnimation(config)
                W.DestroyMenu(menu)
            end
        )
    end)
end

-- Main Thread
CreateThread(
    function()
        while true do
            local sleep = 1000
            for _,v in pairs(Config.ShopPositions) do
                local playerDistance = GetEntityCoords(PlayerPedId(), true)
                if #(playerDistance-v) <= 1 then
                    sleep = 1
                    W.ShowText(v + vector3(0,0,1), '~y~Funko Shop\n~w~Comprar funkos', 0.5, 8)
                    if IsControlPressed(1, 38) then
                        openShop()
                    end
                end
            end
            Wait(sleep)
        end
    end
)

RegisterCommand('funkomenu',
    function()
        openPlayerFunkos()
    end
)