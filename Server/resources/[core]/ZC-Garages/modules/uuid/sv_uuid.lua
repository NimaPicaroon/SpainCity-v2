UUIDModule = setmetatable({}, UUIDModule)
UUIDModule.__index = UUIDModule

function UUIDModule:generate(template)
    if not template then
        template = UUID_DATA.template
    end

    return string.gsub(template, '[xy]', function (c)
        local v = (c == 'x') and math.random(0, 0xf) or math.random(8, 0xb)

        return string.format('%x', v)
    end)
end

exports('newUUID', function(template); local uuid = UUIDModule:generate(template) return uuid; end)