W = setmetatable({ }, W)
W.__index = W
W.Plys = { }
W.Items = { }

GetCore = function ()
    return W
end