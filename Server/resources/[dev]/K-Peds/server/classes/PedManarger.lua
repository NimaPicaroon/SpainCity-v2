function PedManarger(source, core, player)

    self = {}

    self.source = source
    self.core = core
    self.player = core.GetPlayer(source)
    self.identifier = self.player.identifier

    self.addPed = function(ped, label, type)
        MySQL.Async.execute('INSERT INTO ks_peds (identifier, ped, type, label) VALUES (@identifier, @ped, @type, @label)',{
            ['@identifier'] = self.identifier,
            ['@ped'] = ped,
            ['@type'] = type,
            ['@label'] = label,
        })
    end

    self.removePed = function(ped)
        MySQL.Async.execute('DELETE FROM `ks_peds` WHERE ped=@ped AND identifier=@identifier',{
            ['@ped'] = ped,
            ['@identifier'] = self.identifier
        })
    end

    self.havePed = function(ped, callback)
        MySQL.Async.fetchAll('SELECT `ped`,`identifier` FROM `ks_peds` WHERE identifier=@identifier AND ped=@ped',{
            ['@identifier'] = self.identifier,
            ['@ped'] = ped
        }, function(res)
            if res[1] and res[1].ped then
                callback(true)
            else
                callback(false)
            end
        end)
    end

    self.getPeds = function(callback)
        MySQL.Async.fetchAll('SELECT `ped`,`label`,`type` FROM `ks_peds` WHERE identifier=@identifier',{
            ['@identifier'] = self.identifier
        }, function(res)
            peds = {}
            if res[1] and res[1].ped then
                for _,v in pairs(res) do
                    table.insert(peds, {ped = v.ped, label = v.label, type = v.type})
                end
                callback(peds)
            else
                callback(false)
            end
        end)
    end

    self.alert = function(message)
        self.player.Notify(message)
    end    

    return self

end