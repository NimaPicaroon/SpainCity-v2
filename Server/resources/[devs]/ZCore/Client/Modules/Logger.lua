W.Logger = setmetatable({ }, W.Logger)
W.Logger.__Index = W.Logger
W.Logger.Types = { }

W.Logger.__RegisterLog = function(type)
    W.Logger.Types[type] = true
    Citizen.Trace('^2[ZCore] ['..type..'] '..tostring("^7New type registered into the logger! ^7")..'\n')
end

W.Print = function(type, content)
    if not W.Logger.Types[type] then return end
    Citizen.Trace('^2[ZCore] ['..type..']^7 '..tostring(content)..'^7\n')
end

W.Thread(function()
    W.Logger.__RegisterLog("INFO")
    W.Logger.__RegisterLog("ERROR")
    W.Logger.__RegisterLog("EXPLOIT")
end)