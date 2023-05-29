function log(txt)
    --if not txt then
        --print("^2"..GetCurrentResourceName().. ' [INFO] ^8 Attempting to print a nil value^0')
    --else
        --print("^2"..GetCurrentResourceName().. ' [INFO] ^8' ..txt..'^0')
    --end
end

function IsAllowed(_src)
    local xPlayer = W.GetPlayer(_src)
    if W.Groups[xPlayer.group] > 0 then
        return true
    end
    return false
end
