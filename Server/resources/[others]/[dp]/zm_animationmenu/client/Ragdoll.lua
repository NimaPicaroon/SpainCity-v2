local isInRagdoll = false

W = exports.ZCore:get()

Citizen.CreateThread(function()
    while true do
    Citizen.Wait(250)
    if isInRagdoll then
      SetPedToRagdoll(PlayerPedId(), 3000, 3000, 0, 0, 0, 0)
    end
  end
end)


RegisterCommand('suelo', function()
  if not IsPedInAnyVehicle(PlayerPedId(), false) then
    isInRagdoll = not isInRagdoll
    if isInRagdoll then
      W.Notify('Animaciones', "Te estás dejando caer en el suelo.", "info")
      -- ShowNotification("Te estás dejando caer en el suelo")
    else
      W.Notify('Animaciones', "Te estás levantando del suelo.", "info")
      -- ShowNotification("Te estás levantando del suelo")
    end
  end
end, false)

RegisterKeyMapping('suelo', 'Tirarse al suelo', 'keyboard', 'J')


