walkModeHas = nil

function WalkMenuStart(name)
  RequestWalking(name)
  SetPedMovementClipset(PlayerPedId(), name, 0.2)
  RemoveAnimSet(name)
  walkModeHas = name
end

function RequestWalking(set)
  RequestAnimSet(set)
  while not HasAnimSetLoaded(set) do
    Citizen.Wait(1)
  end 
end

function WalksOnCommand(source, args, raw)
  local WalksCommand = ""
  for a in pairsByKeys(DP.Walks) do
    WalksCommand = WalksCommand .. ""..string.lower(a)..", "
  end
  EmoteChatMessage(WalksCommand)
  EmoteChatMessage("To reset do /walk reset")
end

function WalkCommandStart(source, args, raw)
  local name = firstToUpper(args[1])

  if name == "Reset" then
      ResetPedMovementClipset(PlayerPedId()) return
  end

  local name2 = table.unpack(DP.Walks[name])
  if name2 ~= nil then
    WalkMenuStart(name2)
  else
    EmoteChatMessage("'"..name.."' is not a valid walk")
  end
end


local crouched = false

RegisterCommand('-crouchKey', function()
  DisableControlAction( 0, 36, true ) 
  if ( not IsPauseMenuActive() ) then 
    
      RequestAnimSet( "move_ped_crouched" )
      RequestAnimSet("MOVE_M@TOUGH_GUY@")
      
      while ( not HasAnimSetLoaded( "move_ped_crouched" ) ) do 
        Citizen.Wait( 100 )
      end 
      while ( not HasAnimSetLoaded( "MOVE_M@TOUGH_GUY@" ) ) do 
        Citizen.Wait( 100 )
      end 		
      if ( crouched ) then 
        crouched = false 
        ResetPedMovementClipset( PlayerPedId() )
        ResetPedStrafeClipset(PlayerPedId())
        SetPedMovementClipset( PlayerPedId(),"MOVE_M@TOUGH_GUY@", 0.5)
        if walkModeHas then
          WalkMenuStart(walkModeHas)
        else
          ResetPedMovementClipset(PlayerPedId())
        end
        
        
      elseif ( not crouched ) then
        crouched = true 
        Citizen.CreateThread(function()
          while crouched do
            SetPedMovementClipset( PlayerPedId(), "move_ped_crouched", 0.55 )
            SetPedStrafeClipset(PlayerPedId(), "move_ped_crouched_strafing")
            DisablePlayerFiring(PlayerId(), true)
            DisableAimCamThisUpdate()
            Citizen.Wait(0)
          end
        end)
      end 
  end
end, false)


RegisterKeyMapping('-crouchKey', 'Agacharse', 'keyboard', 'LCONTROL')
