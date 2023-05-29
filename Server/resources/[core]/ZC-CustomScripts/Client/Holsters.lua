local config = Config.Holsters
local enabled = true
local active = false
local ped = nil -- The hash of the current ped
local currentPedData = nil -- Config data for the current ped
local weapons = { }

function table_invert(t)
  local s={}
  for k,v in pairs(t) do
    s[v]=k
  end
  return s
end

-- Returns if the given weapon (hash) is in the config
function isConfigWeapon(weapon)
  return weapons[weapon] ~= nil
end

-- Adds the weapon hash to the 'weapons' table, for a given string or hash
local function loadWeapon(weapon)
  local hash = weapon
  if not tonumber(weapon) then -- If not already a hash
    hash = GetHashKey(weapon)
  end
  if not IsWeaponValid(hash) then 
    error('Invalid weapon ' .. tostring(weapon))
  end
  if isConfigWeapon(weapon) then return end -- Don't add duplicate weapons
  weapons[hash] = true
end

if type(config.weapon) == 'table' then
  for _, weapon in ipairs(config.weapon) do
    loadWeapon(weapon)
  end
else -- Backwards compatibility for old config versions where 'config.weapon' was just a string
  loadWeapon(config.weapon)
end

-- Slow loop to determine the player ped and if it is of interest to the algorithm
CreateThread(function()
  while true do
    ped = PlayerPedId()
    local ped_hash = GetEntityModel(ped)
    local enable = false -- We updated the 'enabled' variable in the upper scope with this at the end
    -- Loop over peds in the config
    for config_ped, data in pairs(config.peds) do
      if GetHashKey(config_ped) == ped_hash then 
        enable = true -- By default, the ped will have its holsters enabled
        if data.enabled ~= nil then -- Optional 'enabled' option
          enable = data.enabled
        end
        currentPedData = data
        break
      end
    end
    active = enable
    Wait(5000)
  end
end)

-- Faster loop to change holster textures
local last_weapon = nil -- Variable used to save the weapon from the last tick
CreateThread(function()
  while true do
    local wait = 1000
    if active and enabled then
      wait = 500
      current_weapon = GetSelectedPedWeapon(ped)
      if current_weapon ~= last_weapon then -- The weapon in hand has changed, so we need to check for holsters
        for component, holsters in pairs(currentPedData.components) do
          local holsterDrawable = GetPedDrawableVariation(ped, component) -- Current drawable of this component
          local holsterTexture = GetPedTextureVariation(ped, component) -- Current texture, we need to preserve this

          local emptyHolster = holsters[holsterDrawable] -- The corresponding empty holster
          if emptyHolster and isConfigWeapon(current_weapon) then
            SetPedComponentVariation(ped, component, emptyHolster, holsterTexture, 0)
            break
          end

          local filledHolster = table_invert(holsters)[holsterDrawable] -- The corresponding filled holster
          if filledHolster and not isConfigWeapon(current_weapon) then
            SetPedComponentVariation(ped, component, filledHolster, holsterTexture, 0)
            break
          end
        end
      end
      last_weapon = current_weapon
    end
    Wait(wait)
  end
end)