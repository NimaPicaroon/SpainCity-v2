W.Dimensions = { }

W.Dimensions.Set = function(source, dimension)
    if type(source) ~= 'number' then
        return
    end

    if type(dimension) ~= 'number' then
        return
    end

    local self = {}
    self.source = source
    self.player = W.GetPlayer(self.source)

    self.dimension = dimension
    self.bucket = self.player.getDimension()

    if self.bucket ~= self.dimension then
        self.player.setDimension(self.dimension)
        self.player.Notify('Dimensiones', 'Te has cambiado de la dimensión ['..self.bucket..'] a la ['..self.dimension..']', 'verify')
    end
end

RegisterNetEvent('ZCore:setDimension', W.Dimensions.Set)