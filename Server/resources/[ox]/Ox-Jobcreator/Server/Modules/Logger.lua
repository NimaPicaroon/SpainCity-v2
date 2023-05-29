---comment
---@param type any
---@param message any
JOB.Print = function(type, message)
    Citizen.Trace('^4['..os.date('%c')..'] ^2[Ox-Jobcreator] ['..type..'] ^7'..tostring(message)..'\n')
end