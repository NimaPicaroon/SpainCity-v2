if GetCurrentResourceName() == 'ZCore' then
    exports('get', function()
        return W
    end)
end

W = exports.ZCore:get()