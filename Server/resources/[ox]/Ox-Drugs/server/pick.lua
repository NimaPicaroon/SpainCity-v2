local shop = {}

function createShop(job, time)
    local info = {job = job, count = {['coke'] = 0, ['opium'] = 0, ['hachis'] = 0}, time = time}

    table.insert(shop, info)

    addJobInfo(info)
    saveShop(shop)
end

function updateShop(info)
    for k,v in pairs(shop) do
        if v.job == info.job then
            v = info
        end
    end

    saveShop(shop)
end

function saveShop(info)
    SaveResourceFile(GetCurrentResourceName(), "shop.json", json.encode(info, {indent = true}), -1)
end

function LoadShop()

    local content = LoadResourceFile(GetCurrentResourceName(), "shop.json")
    shop = json.decode(content)

    for i, info in ipairs(shop) do -- 604800
        if os.time() - info.time < 604800 then
            addJobInfo(info)
        else
            table.remove(shop, i)
            createShop(info.job, os.time())
        end
    end
end

function addJobInfo(info)
    recolect[info.job] = info
end

LoadShop()