
local n_stats = false
local Game_version = GetGameVersion()

local function OnScriptError(message)
	AddPlayerChat('<span color="#ff0000bb" style="bold">'..message..'</>')
end
AddEvent("OnScriptError", OnScriptError)

if ShowEvents then
    for i, v in ipairs(Events) do
        if (((v == "OnKeyPress" or v == "OnKeyRelease") and LogKeys == true) or (v ~= "OnKeyPress" and v ~= "OnKeyRelease")) then
            AddEvent(v, function(...)
                local tbl = {...}
                local text = ""
                local varargs
                if (tbl and #tbl > 0) then
                    varargs = true
                    for i, v in ipairs(tbl) do
                       if i == 1 then
                          text = tostring(v)
                       else
                          text = text .. " " .. tostring(v)
                       end
                    end
                end
                if varargs then
                    AddPlayerChat(v .. ", " .. text)
                else
                    AddPlayerChat(v)
                end
            end)
        end
    end
end

function DrawPlayerInformations(v)
   local x, y, z = GetPlayerLocation(v)
   local bs,sx,sy = WorldToScreen(x, y, z)
   if bs then
      DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy - 90, "ID : " .. tostring(v))

      local name = GetPlayerName(v)
      DrawText(sx-string.len("Name : " .. tostring(name)) * 3,sy - 75, "Name : " .. tostring(name))

      DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy - 60, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))

      local h = GetPlayerHeading(v)
      DrawText(sx-string.len("Heading : " .. tostring(math.floor(h + 0.5))) * 3,sy - 45, "Heading : " .. tostring(math.floor(h + 0.5)))

      local talking = IsPlayerTalking(v)
      DrawText(sx-string.len("Talking : " .. tostring(talking)) * 3,sy - 30, "Talking : " .. tostring(talking))

      local movement = GetPlayerMovementMode(v)
      DrawText(sx-string.len("Movement : " .. tostring(movement)) * 3,sy - 15, "Movement : " .. tostring(movement))

      local speed = GetPlayerMovementSpeed(v)
      DrawText(sx-string.len("Speed : " .. tostring(math.floor(speed + 0.5))) * 3,sy, "Speed : " .. tostring(math.floor(speed + 0.5)))
   end
end

function Debug_DrawRect(MinX, MinY, MinZ, MaxX, MaxY, MaxZ)
    local size = 2
    DrawLine3D(MinX, MinY, MinZ, MaxX, MinY, MinZ, size)
    DrawLine3D(MinX, MinY, MinZ, MinX, MaxY, MinZ, size)
    DrawLine3D(MinX, MinY, MinZ, MinX, MinY, MaxZ, size)

    DrawLine3D(MaxX, MinY, MinZ, MaxX, MaxY, MinZ, size)
    DrawLine3D(MaxX, MinY, MinZ, MaxX, MinY, MaxZ, size)

    DrawLine3D(MinX, MaxY, MinZ, MaxX, MaxY, MinZ, size)
    DrawLine3D(MinX, MaxY, MinZ, MinX, MaxY, MaxZ, size)

    DrawLine3D(MinX, MinY, MaxZ, MaxX, MinY, MaxZ, size)
    DrawLine3D(MinX, MinY, MaxZ, MinX, MaxY, MaxZ, size)

    DrawLine3D(MaxX, MaxY, MaxZ, MaxX, MaxY, MinZ, size)
    DrawLine3D(MaxX, MaxY, MaxZ, MinX, MaxY, MaxZ, size)
    DrawLine3D(MaxX, MaxY, MaxZ, MaxX, MinY, MaxZ, size)
end

AddEvent("OnRenderHUD", function()
    SetDrawColor(RGB(255, 255, 255, 255))
    local ScreenX, ScreenY = GetScreenSize()
    for i, v in ipairs(GetStreamedVehicles()) do
       local x, y, z = GetVehicleLocation(v)
       local fx, fy, fz = GetVehicleForwardVector(v)
       local rx, ry, rz = GetVehicleRightVector(v)
       local ux, uy, uz = GetVehicleUpVector(v)
       local size = 33
       for i2 = 1, 4 do
          local x, y, z = GetVehicleDoorLocation(v, i2)
          if x then
             Debug_DrawRect(x - size, y - size, z - size, x + size, y + size, z + size)
          end
       end

       local MinX, MinY, MinZ, MaxX, MaxY, MaxZ = GetVehicleBoundingBox(v)
       Debug_DrawRect(MinX, MinY, MinZ, MaxX, MaxY, MaxZ)

       local sw1 = GetVehicleWheelSurface(v, 0)
       local sw2 = GetVehicleWheelSurface(v, 1)
       local sw3 = GetVehicleWheelSurface(v, 2)
       local sw4 = GetVehicleWheelSurface(v, 3)

       local wsa1 = GetVehicleWheelSteerAngle(v, 0)
       local wsa2 = GetVehicleWheelSteerAngle(v, 1)
       local wsa3 = GetVehicleWheelSteerAngle(v, 2)
       local wsa4 = GetVehicleWheelSteerAngle(v, 3)

       local x1,y1,z1 = GetVehicleBoneLocation(v, "wheel_front_r",1)
       local x2,y2,z2 = GetVehicleBoneLocation(v, "wheel_front_l",1)
       local x3,y3,z3 = GetVehicleBoneLocation(v, "wheel_rear_r",1)
       local x4,y4,z4 = GetVehicleBoneLocation(v, "wheel_rear_l",1)

       local b1,sx1,sy1 = WorldToScreen(x1, y1, z1)
       local b2,sx2,sy2 = WorldToScreen(x2, y2, z2)
       local b3,sx3,sy3 = WorldToScreen(x3, y3, z3)
       local b4,sx4,sy4 = WorldToScreen(x4, y4, z4)

       if wsa1 then
          wsa1 = math.floor(wsa1 + 0.5)
       end

       if wsa2 then
          wsa2 = math.floor(wsa2 + 0.5)
       end

       if wsa3 then
          wsa3 = math.floor(wsa3 + 0.5)
       end

       if wsa4 then
          wsa4 = math.floor(wsa4 + 0.5)
       end

       if (b2 and sw1) then
          DrawText(sx2-string.len(sw1),sy2 - 15,"Wheel 0")
          DrawText(sx2-string.len(sw1)*3,sy2,sw1)
          DrawText(sx2-string.len(wsa1)*3,sy2 + 15,wsa1)
       end
       if (b1 and sw2) then
          DrawText(sx1-string.len(sw2),sy1 - 15,"Wheel 1")
          DrawText(sx1-string.len(sw2)*3,sy1,sw2)
          DrawText(sx1-string.len(wsa2)*3,sy1 + 15,wsa2)
       end
       if (b4 and sw3) then
          DrawText(sx4-string.len(sw3),sy4 - 15,"Wheel 2")
          DrawText(sx4-string.len(sw3)*3,sy4,sw3)
          --DrawText(sx4-string.len(wsa3)*3,sy4 + 15,wsa3)
       end
       if (b3 and sw4) then
          DrawText(sx3-string.len(sw4),sy3 - 15,"Wheel 3")
          DrawText(sx3-string.len(sw4)*3,sy3,sw4)
          --DrawText(sx3-string.len(wsa4)*3,sy3 + 15,wsa4)
       end

       local vehmodel = GetVehicleModel(v)
       local bmodelid,modelidx,modelidy = WorldToScreen(x, y, z)
       if bmodelid then
          DrawText(modelidx-string.len("Modelid : " .. tostring(vehmodel)) * 3,modelidy - 60, "Modelid : " .. tostring(vehmodel))
       end

       local vehmodelname = GetVehicleModelName(v)
       if bmodelid then
          DrawText(modelidx-string.len("Model : " .. tostring(vehmodelname)) * 3,modelidy - 75, "Model : " .. tostring(vehmodelname))
       end

       if bmodelid then
          DrawText(modelidx-string.len("ID : " .. tostring(v)) * 3,modelidy - 90, "ID : " .. tostring(v))
       end

       local rpm = math.floor(GetVehicleEngineRPM(v) + 0.5)
       if bmodelid then
          DrawText(modelidx-string.len("RPM : " .. tostring(rpm)) * 3,modelidy - 30, "RPM : " .. tostring(rpm))
       end

       local speed =  math.floor(GetVehicleForwardSpeed(v) + 0.5)
       if bmodelid then
          DrawText(modelidx-string.len("Speed : " .. tostring(speed)) * 3,modelidy - 45, "Speed : " .. tostring(speed))
       end

       local gear = GetVehicleGear(v)
       if bmodelid then
          DrawText(modelidx-string.len("Gear : " .. tostring(gear)) * 3,modelidy - 15, "Gear : " .. tostring(gear))
       end

       local light = GetVehicleLightState(v)
       if bmodelid then
          DrawText(modelidx-string.len("Light : " .. tostring(light)) * 3,modelidy, "Light : " .. tostring(light))
       end

       local health = math.floor(GetVehicleHealth(v) + 0.5)
       if bmodelid then
          DrawText(modelidx-string.len("Health : " .. tostring(health)) * 3,modelidy + 15, "Health : " .. tostring(health))
       end
    end
    DrawText(1,300, "Ping : " .. tostring(GetPing()))

    if not n_stats then
       DrawText(1,315, "N to toggle Network Stats")
    else
       local Stats = GetNetworkStats()
       DrawText(1,315, "packetlossTotal : " .. tostring(Stats.packetlossTotal))
       DrawText(1,330, "packetlossLastSecond : " .. tostring(Stats.packetlossLastSecond))
       DrawText(1,345, "messagesInResendBuffer : " .. tostring(Stats.messagesInResendBuffer))
       DrawText(1,360, "bytesInResendBuffer : " .. tostring(Stats.bytesInResendBuffer))
       DrawText(1,375, "bytesSend : " .. tostring(Stats.bytesSend))
       DrawText(1,390, "bytesReceived : " .. tostring(Stats.bytesReceived))
       DrawText(1,405, "bytesResent : " .. tostring(Stats.bytesResent))
       DrawText(1,420, "bytesSendTotal : " .. tostring(Stats.bytesSendTotal))
       DrawText(1,435, "bytesReceivedTotal : " .. tostring(Stats.bytesReceivedTotal))
       DrawText(1,450, "bytesResentTotal : " .. tostring(Stats.bytesResentTotal))
       DrawText(1,465, "isLimitedByCongestionControl : " .. tostring(Stats.isLimitedByCongestionControl))
       DrawText(1,480, "isLimitedByOutgoingBandwidthLimit : " .. tostring(Stats.isLimitedByOutgoingBandwidthLimit))
    end

    DrawText(1,510, "Game Launched since : " .. tostring(math.floor(GetTimeSeconds() + 0.5)) .. " s")

    DrawText(1,540, "Timers : " .. tostring(GetTimerCount()))
    DrawText(1,555, "Streamed Players : " .. tostring(GetPlayerCount()))
    DrawText(1,570, "Streamed NPCs : " .. tostring(GetNPCCount()))
    DrawText(1,585, "Streamed Objects : " .. tostring(GetObjectCount()))
    DrawText(1,600, "Streamed Pickups : " .. tostring(GetPickupCount()))
    DrawText(1,615, "Streamed Doors : " .. tostring(GetDoorCount()))
    DrawText(1,630, "Sounds : " .. tostring(GetSoundCount()))
    DrawText(1,645, "Streamed Text3Ds : " .. tostring(GetText3DCount()))
    DrawText(1,660, "Streamed Vehicles : " .. tostring(GetVehicleCount()))
    DrawText(1,675, "WebUIs : " .. tostring(GetWebUICount()))

    DrawText(1,705, "Time : " .. tostring(GetTime()))

    DrawText(1,ScreenY - 20, "Onset " .. tostring(Game_version))

    local x, y, z = GetPlayerLocation()
    if GetPlayerVehicle() ~= 0 then
        local rx,ry,rz = GetVehicleRotation(GetPlayerVehicle())
        DrawText(ScreenX/2-100, ScreenY-30, "Pos x : " .. math.floor(x + 0.5) .. " Pos y : " .. math.floor(y + 0.5) .. " Pos z : " .. math.floor(z + 0.5) .. " rx : " .. math.floor(rx + 0.5) .. " ry : " .. math.floor(ry + 0.5) .. " rz : " .. math.floor(rz + 0.5))
    else
        DrawText(ScreenX/2-100, ScreenY-30, "Pos x : " .. math.floor(x + 0.5) .. " Pos y : " .. math.floor(y + 0.5) .. " Pos z : " .. math.floor(z + 0.5) .. " heading : " .. math.floor(GetPlayerHeading(GetPlayerId()) + 0.5))
    end



    for i, v in ipairs(GetStreamedPlayers()) do
       if GetPlayerVehicle(v) == 0 then
          DrawPlayerInformations(v)
       end
    end
    if GetPlayerVehicle(GetPlayerId()) == 0 then
       DrawPlayerInformations(GetPlayerId())
    end

    for i, v in ipairs(GetStreamedNPC()) do
       local x, y, z = GetNPCLocation(v)
       local bs,sx,sy = WorldToScreen(x, y, z)
       if bs then
          DrawText(sx-string.len("NPC") * 3,sy - 30, "NPC")

          DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy - 15, "ID : " .. tostring(v))

          DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))
       end
    end

    for i, v in ipairs(GetStreamedObjects(true)) do
       local x, y, z = GetObjectLocation(v)
       local bs,sx,sy = WorldToScreen(x, y, z)
       if bs then
          DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy - 45, "ID : " .. tostring(v))

          local model = GetObjectModel(v)
          DrawText(sx-string.len("Modelid : " .. tostring(model)) * 3,sy - 30, "Modelid : " .. tostring(model))

          local modelname = GetObjectModelName(model)
          DrawText(sx-string.len("Model : " .. tostring(modelname)) * 3,sy - 15, "Model : " .. tostring(modelname))

          DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))

          local rx, ry, rz = GetObjectRotation(v)
          DrawText(sx-string.len("Rotation : " .. tostring(math.floor(rx + 0.5)) .. " " .. tostring(math.floor(ry + 0.5)) .. " " .. tostring(math.floor(rz + 0.5))) * 3,sy + 15, "Rotation : " .. tostring(math.floor(rx + 0.5)) .. " " .. tostring(math.floor(ry + 0.5)) .. " " .. tostring(math.floor(rz + 0.5)))

          local scx, scy, scz = GetObjectScale(v)
          DrawText(sx-string.len("Scale : " .. tostring(scx) .. " " .. tostring(scy) .. " " .. tostring(scz)) * 3,sy + 30, "Scale : " .. tostring(scx) .. " " .. tostring(scy) .. " " .. tostring(scz))

          local six, siy, siz = GetObjectSize(v)
          DrawText(sx-string.len("Size : " .. tostring(math.floor(six + 0.5)) .. " " .. tostring(math.floor(siy + 0.5)) .. " " .. tostring(math.floor(siz + 0.5))) * 3,sy + 45, "Size : " .. tostring(math.floor(six + 0.5)) .. " " .. tostring(math.floor(siy + 0.5)) .. " " .. tostring(math.floor(siz + 0.5)))

          local Mass = GetObjectMass(v)
          DrawText(sx-string.len("Mass : " .. tostring(Mass)) * 3,sy + 60, "Mass : " .. tostring(Mass))

          local MinX, MinY, MinZ, MaxX, MaxY, MaxZ = GetObjectBoundingBox(v)

          --AddPlayerChat(tostring(MinX) .. " " .. tostring(MinY) .. " " .. tostring(MinZ) .. " " .. tostring(MaxX) .. " " .. tostring(MaxY) .. " " .. tostring(MaxZ))

          Debug_DrawRect(x + MinX, y + MinY, z + MinZ, x + MaxX, y + MaxY, z + MaxZ)
       end
    end

    for i, v in ipairs(GetStreamedPickups()) do
      local x, y, z = GetPickupLocation(v)
      local bs,sx,sy = WorldToScreen(x, y, z)
      if bs then
         DrawText(sx-string.len("Pickup") * 3,sy - 30, "Pickup")

         DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy - 15, "ID : " .. tostring(v))

         DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))
      end
    end

    for i, v in ipairs(GetStreamedDoors()) do
      local x, y, z = GetDoorLocation(v)
      local bs,sx,sy = WorldToScreen(x, y, z)
      if bs then
         DrawText(sx-string.len("Door") * 3,sy - 30, "Door")

         DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy - 15, "ID : " .. tostring(v))

         DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))
      end
    end

    for i, v in ipairs(GetStreamedText3D()) do
      local x, y, z = GetText3DLocation(v)
      local bs,sx,sy = WorldToScreen(x, y, z)
      if bs then
         DrawText(sx-string.len("Text3D") * 3,sy + 15, "Text3D")

         DrawText(sx-string.len("ID : " .. tostring(v)) * 3,sy + 30, "ID : " .. tostring(v))

         DrawText(sx-string.len("Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5))) * 3,sy + 45, "Location : " .. tostring(math.floor(x + 0.5)) .. " " .. tostring(math.floor(y + 0.5)) .. " " .. tostring(math.floor(z + 0.5)))
      end
    end
end)

AddEvent("OnKeyPress", function(key)
    if key == "N" then
       n_stats = not n_stats
    end
end)