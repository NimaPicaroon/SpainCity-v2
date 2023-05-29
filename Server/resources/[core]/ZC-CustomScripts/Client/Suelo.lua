local ragdoll = false

RagdollInit = function()
  Citizen.CreateThread(function()
    while ragdoll do
      SetPedToRagdoll(PlayerPedId(), 1000, 1000, 0, 0, 0, 0)
      Wait(0)
    end
  end)
end

RegisterKeyMapping('suelo', 'Tirarte al suelo', 'keyboard', 'J')

RegisterCommand("suelo", function()
  --if exports['Ox-Phone']:IsPhoneOpened() then return end
  if exports['Ox-Jobcreator']:IsHandcuffed() then return end
  if exports['ZC-Ambulance']:IsDead() then return end
  if exports['ZC-CustomScripts']:getHostage() then return end

  if not IsPedInAnyVehicle(PlayerPedId(), false) then
    ragdoll = not ragdoll

    if ragdoll then
      RagdollInit()
    end
  end
end, false)