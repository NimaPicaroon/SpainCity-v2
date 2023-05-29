JOB.GlobalData = {}

RegisterNetEvent('ZCore:updateData', function(data)
    JOB.GlobalData = data
end)

---comment
---@param title any
---@param name any
---@param data any
---@param cb function
JOB.OpenMenu = function(title, name, data, cb)
    W.OpenMenu(title, name, data, function(result)
        cb(result, name)
    end)
end