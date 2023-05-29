exports["target"]:AddTargetModel(`s_m_y_busboy_01`, {
    options = {
        {
            event = "doj:client:SellLegalFish",
            icon = "fa fa-fish",
            label = "Vender Pescado",
        },
		{
            event = "doj:client:SellillegalFish",
            icon = "fa fa-fish",
            label = "Vender Animal Exótico",
        },
    },
    distance = 10.0
})

exports["target"]:AddTargetModel(`a_m_m_bevhills_01`, {
    options = {
        {
            event = "openWeedCrafting",
            icon = "fa-solid fa-pills",
            label = "Empaquetar",
        },
    },
    distance = 5.0
})


exports["target"]:AddTargetModel(`a_m_m_hasjew_01`, {
    options = {
        {
            event = "openWeedCrafting",
            icon = "fa-solid fa-pills",
            label = "Empaquetar",
        },
    },
    distance = 5.0
})
