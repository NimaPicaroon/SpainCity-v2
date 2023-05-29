BillController = setmetatable({ }, BillController)
BillController.__store = {}

BillController.__index = BillController

Citizen.CreateThread(function()
    while not NetworkIsPlayerActive(PlayerId()) do
        Wait(100)
    end

    while not W.GetPlayerData().job do
        Citizen.Wait(500)
    end

    TriggerServerEvent('billing:load')
end)

BillController.add = function(bills)
    if type(bills) ~= 'table' then
        return
    end

    local self = {}
    self.bills = bills

    for k,v in pairs(self.bills) do
        BillController.__store[tonumber(k)] = {
            billId = tonumber(k),
            sender = tostring(v.sender),
            reason = tostring(v.reason),
            amount = tonumber(v.amount),
            payed = v.payed
        }
    end
end

BillController.remove = function(billId)
    if type(billId) ~= 'number' then
        return
    end

    local self = {}
    self.billId = billId

    if BillController.__store[self.billId] then
        BillController.__store[self.billId] = nil
    end
end

BillController.show = function()
    if type(BillController.__store) ~= 'table' then
        return
    end

    local self = {}
    self.bills = BillController.__store
    self.data = {}

    for k, v in pairs(self.bills) do
        if not v.payed and k and v.reason and v.amount and v.sender then
            table.insert(self.data, { label = v.sender..': $'.. tonumber(v.amount), value = k, reason = v.reason })
        end
    end

    local billId = nil
    local reason = nil

    if next(self.data) ~= nil then
        print(json.encode(self.data))
        W.OpenMenu('Lista de multas', 'biling_menu', self.data, function(data, name)
            W.DestroyMenu(name)
            Wait(250)
            billId = data.value
            reason = data.reason

            if billId then
                W.OpenMenu('¿Quieres pagar la multa?', 'pay_bill_menu', {
                    { label = 'Pagar', value = 'pay' },
                    { label = 'Ver razón', value = 'reason' }
                }, function(data, name)
                    print(1,2)
                    W.DestroyMenu(name)

                    if data.value == 'pay' then
                        TriggerServerEvent('billing:pay', billId)
                    elseif data.value == 'reason' then
                        W.Notify('Multa', 'La razón es: '..reason, 'info')
                    else
                        BillController.show()
                    end
                end)
            end
        end)
    else
        W.Notify('MULTAS', 'No tienes ninguna multa que pagar', 'error')
    end
end

RegisterNetEvent('billing:remove', BillController.remove)
RegisterNetEvent('billing:add', BillController.add)

RegisterKeyMapping('bills', 'Ver multas', 'keyboard', 'F7')
RegisterCommand('bills', function()
    BillController.show()
end)