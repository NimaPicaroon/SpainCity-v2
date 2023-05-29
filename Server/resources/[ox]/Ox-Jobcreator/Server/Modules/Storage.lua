W.CreateCallback("jobcreatorv2:server:getInventory", function(source, cb, name)
    local Job = JOB.GetJob(name)

    if Job and Job.inventory then
        cb(Job.inventory.getInventory())
    else
        cb({})
    end
end)

JOB.BuyItem = function(name, price, quantity, job)
    local src <const> = source
    local ply = W.GetPlayer(src)
    local Job = JOB.GetJob(job)
    local item = {name = name}
    item.slotId = W.SlotId()

    if Job.getMoney() >= (price * quantity) then
        Job.removeMoney(price * quantity, function(removed)
            if removed then
                if Job.addItemToInv(item.name, quantity, nil, item.slotId, src) then
                    ply.Notify('SOCIEDAD', 'Has ~y~comprado~w~ x'..quantity..' de '..GlobalState.Items[item.name].label..' por ~g~$'..price * quantity, 'verify')
                else
                    ply.Notify('ARMARIO', 'Algo ha ~r~fallado', 'error')
                end
            end
        end)
    else
        ply.Notify('SOCIEDAD', 'No tienes ~r~fondos suficientes~w~ en tu sociedad para comprar esto.', 'error')
    end
end

RegisterServerEvent("jobcreatorv2:server:buyItem", JOB.BuyItem)