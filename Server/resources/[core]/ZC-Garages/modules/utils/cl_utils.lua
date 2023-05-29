UtilsModule = setmetatable({ }, UtilsModule)
UtilsModule.__index = UtilsModule

function UtilsModule:parse(text)    
    return string.gsub(text, " ", "")
end