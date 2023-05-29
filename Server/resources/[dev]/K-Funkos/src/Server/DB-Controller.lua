DB = {}
PLAYERS = {}

function hasTableValue (tab, val) for index, value in pairs(tab) do if value == val then  return true end end  return false end

--- DB  Init function
function DB:init()
    local table_data = [[
        CREATE TABLE IF NOT EXISTS `users_funkos` (
          `id` int(11) NOT NULL AUTO_INCREMENT,
          `identifier` varchar(50) NOT NULL,
          `funko` varchar(255) NOT NULL,
          KEY `Índice 1` (`id`)
        ) ENGINE=InnoDB DEFAULT CHARSET=utf8 COLLATE=utf8_general_ci;
    ]]
    MySQL.execute(table_data, {}, function(rows) end)
end

---@generic Identifier: string
---@generic funko: string
function DB:insertFunko(identifier, funko, player)
    if not identifier or not funko then return end
    DB:getFunkoForPlayer(identifier, function(funkos)
        if hasTableValue(funkos, funko) then player.Notify('ERROR', 'Ya tienes ese funko pop', 'error') return end
        MySQL.insert('INSERT INTO users_funkos (identifier, funko) VALUES (?, ?)',
            { identifier, funko },
            function(id)
                player.Notify('INFO', "Compraste correctamente el funko pop, Gracias :)", 'succes')
            end
        )
    end)
end

---@generic Identifier: string
---@generic funko: string
function DB:deleteFunko(identifier, funko)
    if not identifier or not funko then return end
    MySQL.execute('DELETE FROM users_funkos WHERE identifier=? AND funko=?',
        { identifier, funko },
        function()end
    )
end

---@generic Identifier: string
---@generic DB: function
---@param identifier Identifier
---@param cb DB
function DB:getFunkoForPlayer(identifier, cb)

    if not identifier then return end

    userData = {}
    MySQL.query('SELECT * FROM users_funkos WHERE identifier=?',
        { identifier },
        function(data)
            for k,d in pairs(data) do
                table.insert(userData, d.funko)
            end
            cb(userData)
        end
    )

end

DB:init()