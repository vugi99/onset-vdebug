

for i, v in ipairs(Events) do
   AddEvent(v, function(...)
       local tbl = {...}
       local text = ""
       local varargs
       if #tbl > 0 then
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
          print(v .. ", " .. text)
       else
          print(v)
       end
   end)
end

AddEvent("OnPackageStart", function()
   CreateNPC(126000.000000, 80246.000000, 1600.000000, -90)
   CreateObject(1, 126200, 80400, 1600)
   CreatePickup(1, 126200, 80600, 1600)
   CreateText3D("test", 16, 126000, 80800, 1600, 0, 0, 0)
end)

AddEvent("OnPackageStart", function()
   print("vDebug Loaded")
   print("Onset " .. GetGameVersionString())
   print("Server Name : " .. GetServerName())
   print("Max Players : " .. tostring(GetMaxPlayers()))
end)