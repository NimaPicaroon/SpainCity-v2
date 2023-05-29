Config = {
    Framework = 3, --[ 1 = ESX / 2 = QBCore / 3 = Other ] Choose your framework

	FrameworkTriggers = {
		notify = '', -- [ ESX = 'esx:showNotification' / QBCore = 'QBCore:Notify' ] Set the notification event, if left blank, default will be used
		object = '', --[ ESX = 'esx:getSharedObject' / QBCore = 'QBCore:GetObject' ] Set the shared object event, if left blank, default will be used (deprecated for QBCore)
		resourceName = '', -- [ ESX = 'es_extended' / QBCore = 'qb-core' ] Set the resource name, if left blank, automatic detection will be performed
	},
    
    NotificationDistance = 10.0,
    PropsToRemove = {
        vector3(1992.803, 3047.312, 46.22865),
    },

    -- qtarget
	UseQTarget = false,

	-- BT-Target
	UseBTTarget = false,

	-- QB-Target
	UseQBTarget = false,

    --[[
        Uses esx/qbcore notifications. Set to false for native GTA notifications
    ]]
    UseFrameworkNotification = true,

    --[[
        -- To use custom menu, implement following client handlers
        AddEventHandler('rcore_pool:openMenu', function()
            -- open menu with your system
        end)

        AddEventHandler('rcore_pool:closeMenu', function()
            -- close menu, player has walked far from table
        end)


        -- After selecting game type, trigger one of the following setupTable events
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_8_BALL')
        TriggerEvent('rcore_pool:setupTable', 'BALL_SETUP_STRAIGHT_POOL')
    ]]
    CustomMenu = false,

    --[[
        When you want your players to pay to play pool, set this to true and set BallSetupCost
    ]]
    PayForSettingBalls = false,
    BallSetupCost = 100, -- for example: 1 or 200 - MUST be number

    --[[
        You can integrate pool cue into your system with

        SERVERSIDE HANDLERS
            - rcore_pool:onReturnCue - called when player takes cue
            - rcore_pool:onTakeCue   - called when player returns cue

        CLIENTSIDE EVENTS
            - rcore_pool:takeCue   - forces player to take cue in hand
            - rcore_pool:removeCue - removes cue from player's hand

        This prevents players from taking cue from cue rack if `false`
    ]]
    AllowTakePoolCueFromStand = true,

    --[[
        This option is for servers whose anticheats prevents
        this script from setting players invisible.

        When player's ped is blocking camera when aiming,
        set this to true
    ]]
    DoNotRotateAroundTableWhenAiming = false,
    
    Debug = false,

    MenuColor = {245, 127, 23},
    Keys = {
        BACK = {code = 200, label = 'INPUT_FRONTEND_PAUSE_ALTERNATE'},
        ENTER = {code = 38, label = 'INPUT_PICKUP'},
        SETUP_MODIFIER = {code = 21, label = 'INPUT_SPRINT'},
        CUE_HIT = {code = 179, label = 'INPUT_CELLPHONE_EXTRA_OPTION'},
        CUE_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        CUE_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        AIM_SLOWER = {code = 21, label = 'INPUT_SPRINT'},
        BALL_IN_HAND = {code = 29, label = 'INPUT_SPECIAL_ABILITY_SECONDARY'},

        BALL_IN_HAND_LEFT = {code = 174, label = 'INPUT_CELLPHONE_LEFT'},
        BALL_IN_HAND_RIGHT = {code = 175, label = 'INPUT_CELLPHONE_RIGHT'},
        BALL_IN_HAND_UP = {code = 172, label = 'INPUT_CELLPHONE_UP'},
        BALL_IN_HAND_DOWN = {code = 173, label = 'INPUT_CELLPHONE_DOWN'},
    },
    Text = {
        BACK = "Atrás",
        HIT = "Golpear",
        BALL_IN_HAND = "Bola en mano",
        BALL_IN_HAND_BACK = "Atrás",
        AIM_LEFT = "Izquierda",
        AIM_RIGHT = "Derecha",
        AIM_SLOWER = "Apuntar Lento",

        POOL = 'Pool',
        POOL_GAME = 'Pool game',
        POOL_SUBMENU = 'Configuración',
        TYPE_8_BALL = '8-ball',
        TYPE_STRAIGHT = 'Straight pool',
        POOL_SETUP = 'Setup: ',

        HINT_SETUP = 'Preparar Mesa',
        HINT_TAKE_CUE = 'Coger Taco',
        HINT_RETURN_CUE = 'Return pool cue',
        HINT_HINT_TAKE_CUE = 'Coge un Taco para Jugar',
        HINT_PLAY = 'Jugar',

        NOT_ENOUGH_MONEY = 'No tienes $%s Para ajustar mesa.',

        BALL_IN_HAND_LEFT = 'izquierda',
        BALL_IN_HAND_RIGHT = 'Derecha',
        BALL_IN_HAND_UP = 'arriba',
        BALL_IN_HAND_DOWN = 'abajo',
        BALL_POCKETED = 'Bola %s fue colada',
        BALL_IN_HAND_NOTIFY = 'Player has taken cue ball in hand',
        BALL_LABELS = {
            [-1] = 'Cue',
            [1] = '~y~Lisa 1~s~',
            [2] = '~b~Lisa 2~s~',
            [3] = '~r~Lisa 3~s~',
            [4] = '~p~Lisa 4~s~',
            [5] = '~o~Lisa 5~s~',
            [6] = '~g~Lisa 6~s~',
            [7] = '~r~Lisa 7~s~',
            [8] = 'Negra 8',
            [9] = '~y~Rallada 9~s~',
            [10] = '~b~Rallada 10~s~',
            [11] = '~r~Rallada 11~s~',
            [12] = '~p~Rallada 12~s~',
            [13] = '~o~Rallada 13~s~',
            [14] = '~g~Rallada 14~s~',
            [15] = '~r~Rallada 15~s~',
         }
    },
}

if Config.UseFrameworkNotification then
    for idx, text in pairs(Config.Text.BALL_LABELS) do
        Config.Text.BALL_LABELS[idx] = text:gsub('~.~', '')
    end
end

if Config.UseQTarget then
	Config.TargetResourceName = 'qtarget'
end
if Config.UseBTTarget then
	Config.TargetResourceName = 'bt-target'
end
if Config.UseQBTarget then
	Config.TargetResourceName = 'qb-target'
end