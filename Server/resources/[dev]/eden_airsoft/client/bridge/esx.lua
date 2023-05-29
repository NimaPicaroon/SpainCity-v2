
Framework.Notify = function(message)
    -- ESX.ShowNotification(message)
end

--- this is looped. You can write your custom checks to show custom text ui's
Framework.ShowHint = function(...)
    -- ESX.ShowHelpNotification(...)
    exports['ZC-HelpNotify']:open('Usa <strong>E</strong> para interactuar', 'cañeria')
end

Framework.HideHint = function()
    exports['ZC-HelpNotify']:close('cañeria')
end
