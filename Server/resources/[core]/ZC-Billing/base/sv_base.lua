BillController = setmetatable({ }, BillController)
BillController.__store = {}
BillController.__ids = {}

BillController.__index = BillController

BillController.generateId = function()
    local maxnum = 999999
    local id = math.random(1, maxnum)

    local maxtries = 50
    local tries = 0

    while (BillController.__ids[id] and tries < maxtries) do
        id = math.random(1, maxnum)
        tries = tries + 1
    end

    if tries >= maxtries then
        return
    end

    return id
end

exports('generateId', BillController.generateId)

BillController.pay = function(billId)
    if type(source) ~= 'number' then
        return
    end
    
    if type(billId) ~= 'number' then
        return
    end

    local self = {}
    self.source = source
    self.billId = billId
    self.player = W.GetPlayer(self.source)
    
    if not self.player then
        return
    end

    if BillController.__ids[tonumber(self.billId)] then
        self.billData = self.player.bills[tostring(self.billId)]

        if not self.billData then
            return
        end

        if self.player.getMoney('bank') >= tonumber(self.billData.amount) then
            self.sernder = W.GetPlayer(self.billData.senderid)
            self.player.payBill(self.billId)
            self.player.removeMoney('bank', tonumber(self.billData.amount))
            BillController.__ids[tonumber(self.billId)] = nil
            self.player.Notify('MULTAS', 'Has ~y~pagado~w~ una multa de ~g~$'..self.billData.amount..'~w~.', 'info')
            self.sernder.Notify('MULTAS', 'El jugador con ID:'..self.player.src..' Ha ~y~pagado~w~ una multa de ~g~$'..self.billData.amount..'~w~.', 'info')
            
            if self.billData.society then
                local jobData = exports['Ox-Jobcreator']:getJobData(self.billData.society)

                if not jobData then
                    return
                end

                jobData.addMoney(tonumber(self.billData.amount))
            end
        else
            self.player.Notify('MULTAS', 'No tienes ~r~dinero suficiente~w~ en el banco.', 'error')
        end
    else
        self.player.Notify('MULTAS', 'Has intentado pagar una multa que no existe', 'error')
    end
end
RegisterNetEvent('billing:pay', BillController.pay)

BillController.send = function(target, data, src, notiSrcBlock)
    local self = {}
    self.notiSrcBlock = false
    if(not source and src)then
        source = src
        if(notiSrcBlock)then
            self.notiSrcBlock = true
        end
    end
    self.sender = source
    self.target = target
    self.senderPly = W.GetPlayer(self.sender)
    self.targetPly = W.GetPlayer(self.target)

    self.billId = BillController.generateId()
    self.billData = data

    if not self.senderPly then
        return
    end

    if not self.targetPly then
        return self.senderPly.Notify('Multa', 'Jugador inválido', 'error')
    end
    
    if not self.billId then
        return
    end
    BillController.__ids[self.billId] = true
    if BillController.__ids[self.billId] then
        self.billData.billId = self.billId
        self.targetPly.addBill(self.billId, self.billData)
        self.targetPly.Notify('Multa', 'Has ~y~recibido~w~ una multa de ~g~$'..self.billData.amount..'~w~.\nRazón: '..self.billData.reason..'.', 'info')
        
        if(not self.notiSrcBlock)then
            self.senderPly.Notify('Multa', 'Has ~y~enviado~w~ una multa de ~g~$'..self.billData.amount..'~w~.\nRazón: '..self.billData.reason..'.', 'info')
        end
    end
end
RegisterNetEvent('bill:send', BillController.send)

BillController.load = function()
    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)

    if not self.player then
        return
    end

    for k,v in pairs(self.player.bills) do
        if not BillController.__ids[tonumber(k)] then
            BillController.__ids[tonumber(k)] = true
        end
    end

    TriggerClientEvent('billing:add', self.source, self.player.bills)
end

RegisterNetEvent('billing:load', BillController.load)