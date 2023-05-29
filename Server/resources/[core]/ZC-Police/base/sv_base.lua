MainController = setmetatable({ }, MainController)
MainController._garages = {
    [1] = false,
    [2] = false
}
MainController.__index = MainController

MainController.changeAssignation = function(assignation)
    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)

    if self.player.job and assignation then
        self.player.setAssignation(assignation)
    end
end

RegisterNetEvent('police:changeAssignation', MainController.changeAssignation)