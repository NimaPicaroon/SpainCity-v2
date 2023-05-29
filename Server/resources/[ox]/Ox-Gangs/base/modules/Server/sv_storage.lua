W.CreateCallback("Ox-Gangs:getInventory", function(source, cb, name)
    local Gang = Gangs[name]
    cb(Gang.inventory.getInventory())
end)