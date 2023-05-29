local W = exports.ZCore:get()

for channel, config in pairs(Config.RestrictedChannels) do
    exports['pma-voice']:addChannelCheck(channel, function(source)
        local Player = W.GetPlayer(source)

        if not player then
            return
        end

        return config[Player.job.name] and Player.job.duty
    end)
end
